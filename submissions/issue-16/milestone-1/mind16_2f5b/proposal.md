# New Standard: NFT metadata - Milestone 1

This is an extended standard specified for the NFT standard on Flow Blockchain to describe the metadata held by the NFT.

## Objective

The goal of the FLIP is to define a unified methodology for defining metadata, not just the format of the content.
Essentially, the standard should contain some other capabilities regarding standard extensibility, security, etc., in addition to the description of the rules for labeling metadata and the implementation on Cadence.

In our opinion, the standard should:
1. provide limited customization capabilities, preferably a combination of standard specifications;
2. be fixed at the interface layer and support customization in content 
3. focus (in this discussion) on presentation layer standards rather than storage layer standards

## Motivation

（Copied from #16）NFTs are more than just numbers and bytes — at their best, they are rich representations of digital goods that people around the world can fall in love with. The current Flow NFT interface, however, does not include a metadata standard that allows these representations to flourish. NFTs should be able to include structured data, images, videos and other types of data. 

Metadata itself has two seemingly contradictory requirements: flexibility and standardization. 
For NFT publishers, they need to be able to easily define any form of metadata that can be used to package artwork, IP, and other digital assets into NFT, 
while for the various infrastructures in the NFT ecosystem, they need a relatively fixed standard that guides the development of systems for circulating, displaying, and storing NFT, which provides strong compatibility, to ensure that the system can be adapted to various NFT projects with less additional development.

So we want to propose a solution to meet these two requirements.

## Design Proposal


We believe that a metadata standard is not the same as a single, fixed schema, and that it is difficult to develop a perfect solution through a single discussion or contest. So we will first discuss here what should be considered in building a metadata standard.
Or rather, we will first list some design points that can be used as a reference for building the standard.
Even if our solution will not be adopted, these points of consideration will provide some help for the construction and optimization of other solutions.
We will then give a preliminary Cadence-based implementation.

### 1. Users of the standard 

Although metadata will be recorded on the Flow blockchain as much as possible, it will be used in a variety of ways by different users.
The first thing we need to discuss here is the users, which may not directly affect the definition of the standard, but can help understand the requirements and provide ideas for building some infrastructure later.
The focus of the standard should not be limited to "how metadata is written on the Flow blockchain", but should also take a global view of the needs of the metadata as it circulates among different users.

We have compiled a list of roles that may use the standard (**feel free to add**):
1. On-chain smart contracts
2. Marketplace Tools
3. Storage Service Provider: AWS S3, Dropbox, Filecoin, AR...
4. Wallet
5. Browser
6. Other Developers


Metadata may be recorded in completely different ways in the hands of different roles. For a blockchain browser, the data will be stored in a database maintained by itself and some database management tools will be used to improve the retrieval efficiency, while for the smart contracts, the metadata may be recorded in the contract as a combination of some basic data types to ensure the integrity of the data.
So we plan to divide the metadata standard proposal into two parts: the standard specification (based on Json) and the corresponding Cadence implementation.


#### 2. Standard specification:modularity & plugin pattern

The content of metadata may be diverse, including various types of text descriptions, images, audio, and any combination thereof.
Often, each NFT may have its own unique metadata structure.
We do not intend to specify a completely definitive data structure, such as:

```
metadata: {
        name:"",
        description:"",
        image:""
        }
```

and force all NFT issuers to comply with it. This would lose a lot of flexibility and thus limit the ability of NFT.
At the same time, we do not intend to design a completely free standard that, for example, jam everything into a string. This also introduces many problems, such as weaker standard binding, weaker type safety, and even worse contract interaction.

We would like to draw on the ideas of modularity and plugin pattern in software design to try to solve this problem.

Modularity: Depending on the differences in scalability requirements, we can divide the total metadata into different modules:

1. **Basic Info**: Basic info includes the most basic and common fields, which are always required by some infrastructures (browser, wallet, etc.). We believe that this part of the information should have a uniform set of specifications (such as field naming) and will not always be updated, and each NFT should contain this information as far as possible.

 ```
   "basic_info": {
        "name":"",
        "description":"",
        "portrait":""
    }
```

2. **Specific metadata packages**: We know that different NFT projects will have very different metadata structure, for example, a pixel painting like Cryptopunk needs some bit values to build the image, while Nba Topshot needs to hold video data (or the url of the video). Here, inspired by the discussion of schema in [issue#9](https://github.com/onflow/flow-nft/issues/9), we intend to introduce a plug-in style approach to constructing the standard for this part of the metadata.
   
   First we want to set different schemas for different types of data, and build a public schema library that prebuilts some common schemas for different data types. This library also supports adding new schemas.
   NFT issuers can choose one or more schemas from the library to build their own unique metadata sets. Ideally, the schema in the library will meet all of the issuers's needs, but if not, the issuers can still build a new schema of its own.
   
   Each schema will have a fixed name, initially named {datatype}\_{data|dataGroup}\_{versionNumber}. (The dataGroup implies that this will be an array type of metadata package. The version number is used to distinguish between different schemas for the same data type)
    
    As an example, if a issuer needs to design a portrait NFT, containing a character introduction and some images of components.

   ```
    {
        "string_data_v1":{
            "name":"description",
            "description":"the description of this avatar",
            "data":"This avatar is xxxxxxx..."
        },
        "image_dataGroup_01":[
            {
                "name":"headwear",
                "description":"This is the image of the headwear",
                "data":0x123412345 
            },
            {
                "name":"body",
                "description":"This is image of the body",
                "data":0x56785678
            },
            {
                "name":"feet",
                "description":"This is image of the feet",
                "data":0xabcdabcd
            }
        ]
    } 
    ```

3. **Raw data anchor**: A portion of raw data (e.g. ~10GB size video files) cannot be fully placed on the blockchain due to the large size.
    This part of data is usually stored in off-chain facilities, such as AWS S3 or some decentralized storage networks, such as Filecoin, CATA, etc..
   And it is enough to keep the proof of integrity of raw data on the chain.
   The real circulation and use of the original data happens completely off-chain, and the chain only assists in the verification, so the structure of the on-chain part should be relatively simple.
   Here we intend to set up a special module for these anchors, which tend to have the same simple structure and the same processing flow.
   ```
   {
       "vedio_data_anchor":{
           "name":"movie data",
           "description":"raw data of the movie",
           "url":"http://abc.efg/1.mp4",
           "integrity proof":"0x1234abcd"
       }
   }
   ```

4. **Mutable Data**: For some projects, especially in the game category, there may be some fields (e.g. player's level and experience, attack power and other attributes) that need to be updated frequently.
   Then it would be a good strategy to bring them together, which can be managed in a unified way (e.g. control of update permissions, version control, etc.).
   So we plan to set up a special module for this data as well.
   
   Since this part of data is mostly project-side custom data with a high degree of freedom, we do not give a fixed-format design solution here for now, but allow custom data combinations and only set the fixed field of version number.
   ```
   {
       "mutable_data":{

           ”version_number“: "1.1.1",
            
           "attack":{
               "description":"The initial damage that can be dealt by one normal attack",
               "type":"int",
               "value":100
           },
           "defense":{
               "description":"Value of damage that can be offset",
               "type":"int",
               "value":100
           },
           ...
       }
   }
   ```
    So, a complete metadata set containing all modules might look like:

    ```
    {
    "basic_info":{
       "name":"",
       "description":"",
       "portrait":""
    },
    "schemas":{
        "string_data_v1":{
            "name":"description",
            "description":"the description of this avatar",
            "data":"This avatar is xxxxxxx..."
        },
        "image_dataGroup_01":[
            {
                "name":"headwear",
                "description":"This is the image of the headwear",
                "data":0x123412345 
            },
            {
                "name":"body",
                "description":"This is image of the body",
                "data":0x56785678
            },
            {
                "name":"feet",
                "description":"This is image of the feet",
                "data":0xabcdabcd
            }
        ]
    },
    "anchors":{
        "vedio_data_anchor":{
           "name":"movie data",
           "description":"raw data of the movie",
           "url":"http://abc.efg/1.mp4",
           "integrity proof":"0x1234abcd"
       }
    },
    "mutable_data":{
        ”version_number“: "1.1.1",

        "attack":{
               "description":"The initial damage that can be dealt by one normal attack",
               "type":"int",
               "value":100
           },
        "defense":{
               "description":"Value of damage that can be offset",
               "type":"int",
               "value":100
           },
           ...
        }
 
    }

    ```

#### 3. Cadence Implementation

The previous section roughly described some design ideas of the metadata standard in terms of data structure.
Another main goal of this proposal is to make an implementation for the standard based on Cadence.
Cadence itself has a very well-developed type system, which is sufficient to support a flexible implementation of the data structure.
Likewise, there are many ways to implement the above rules based on Cadence, and the most straightforward way is to jam all the data into a single string
```
    pub let metadata:String

    ...

    metadata = "{'basic_info': ......}"
```
But obviously this approach is just for storage and loses the ability to express metadata in smart contracts, and also fails to take advantage of Cadence for type safety.

So we still plan to introduce a solution with generality based on Cadence's type system that can satisfy.
1. a fixed interface specification
2. storage of arbitrary basic types and structures
3. the ability to declare a variety of schema
4. support for adding new schema
5. support for mutable metadata

We refered to the Cadence documentation and read the discussion in [issue#9](https://github.com/onflow/flow-nft/issues/9) and came up with the following basic solution:


```
We ARE STILL REFINING THIS PART OF THE CADENCE DATA. IT IS COMING SOON!!
```

#### 4. Composability & Dynamic Metadata

Composability is a very interesting feature. In some projects, there may be multiple combinations between different NFTs, which might be reflected in the organization of metadata management.
For example, a game character will wear some equipments, such as helmet, armor, boots, etc. Each piece of equipment may be a separate NFT and has its own properties(e.g., attack, defense, etc.). And the overall properties of the character may be the sum of all equipments' properties.
So maybe we can try to extend the static metadata standard to include some arithmetic operators to support some dynamic calculation process? This would eliminate the need to update attributes of the game character after changing or enhancing its equipments.

This part is more complicated, we are still thinking about it, and would like some suggestions.

Another type of composability is inheritance relationship. Let's take the Crypto Cat as a example. Cats can inherit part of their parents' genetic attributes (e.g. skin color, coat color, etc.). Is it possible to define an inheritance rule so that part of the determined inherited attributes can be directed to the parent by reference, without having to save a new copy in the child NFT?


#### 5. Royalty

Royalty is also a hot topic often discussed in [issue#9](https://github.com/onflow/flow-nft/issues/9). Since NFT itself has a high IP value, it could often require some rules related to rights and interests, and this part of the rules should also be written into the metadata.
For example, the NFT minter can still enjoy a 5% cut of the transaction fee of subsequent transactions even after the NFT is sold.
This can be used as an incentive mechanism for creators in some creative NFT projects.

The royalty may be inserted into the metadata structure as a fixed schema:
```
{
    "royalty_v1":{
        "beneficiaries":[
            "0x1234...abc",
            "0x1234...fed"
        ],
        "share":[
            0.05,
            0.025
        ]
    }
}
```

#### 6. Mutable Metadata

Some of the fields in the metadata may be updated frequently, as described in Section 2, and there should be a uniform mechanism to manage this part of data.

The first issue worth thinking about is update permission.
Intuitively, it must be the NFT owner who can modify the metadata, because the owner has whole permissions of the NFT.
But this is not always the case. For some game projects， it is actually the game's code that can update of the character's metadata.
In this case, a reasonable process should be to decouple some of the fields that need to be controlled by external services and authorize them to some third-party contracts, while other parts of the metadata remain under the control of the owner.
So in Section 2, we set a separate module to keep this part of metadata, and in Cadence, we also try to manage this part of data by way of cabalities.

The second issue is version management. The second issue is version management. If there are multiple people updating at the same time, a version management mechanism is needed to ensure the consistency of the update process. 
However, this requirement currently looks very unimportant, so for now just a version number field is used to mark the latest version, and new suggestions are welcome.


#### 7. Naming conventions
This section is mainly used to discuss the conventions when naming the metadata name as well as the schema's name. Although arbitrary naming schemes can work, a uniform specification will be easier to manage.

The detailed solution is TDB, suggestions are welcome:)

#### 8. Standard Extension Process

The standard should not be a one-step process, but rather an ongoing iterative process that accepts open discussion and updates.
Since on-chain facilities are involved, the process to update the standard will also be an issue.
Here we propose some points to consider:
1. the process of updating the standard, including proposal, review, voting and implementation.
2. the need to go through a complete code audit process for updates involving on-chain facilities.
3. the assurance of backward compatibility, ensuring that the systems already in operation are not affected.
4. others...


#### 9. Certificates
Some NFTs, especially those from the art or collectibles domain, may require some certificates from an authority(e.g., Christie's), which adds credibility to the value of the NFT itself. If needed, the metadata of the certificate type can also be constructed into a specific schema, for example:
```
{
    "certificate_v1":{
        "institution_pk":"",
        "claim":"",
        "signature":""
    }
}
```

#### 10. Security Issues

Open for discussion~

#### 11. Discussion on generics in Cadence

Open for discussion~

#### 12. Domain-specific Standards

This is a new idea, but just ideas.
We can encourage projects in different fields to explore some domain-specific standards together, such as the game field, sports field, etc.
Take the game field, if different game projects can follow a set of standards to construct NFT as much as possible, then in the future, it can easily realize the interaction between different games, such as equipment trading. And some trading platforms can also be built according to this set of standards, so as to easily dock all game projects.

Just a idea ....

#### 13. About Storage

Our team plans to build a metadata retrieval engine based on the decentralized storage facility CATA, which will be developed according to the final version of the metadata standard introduced by Flow.
Users will then be able to easily access detailed information about any NFT, such as pattern, type, rarity, transaction records, etc.
Project owners can also interface with us to build a monitoring dashboard of all NFT data.

Stay tuned.