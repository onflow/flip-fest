/*
	This project is addressing problem "New Standard: NFT metadata #16"
	The below code is untested and is meant as an illustration of the concept.
	
	
	MetaDataUtil is added as a new default contract.
	
	Metadata is instantiated in the form of structs at the time the NFT is minted.
	Metadata is organized by string tags, and each metadata element may have multiple tags allowing NFTs to conform to multiple tag schemas.
	Metadata elements cannot be added after the NFT is minted, but Mutable elements can allow data to be modifiable.
	
	MetaDataElements are wrappers around two possible types of structs, one of which is immutable and the other of which is Mutable.
	Immutable elements can use default types or be defined in custom structs that implement ITaggedMetaData and IImmutableMetaData. 
		Defining a custom class allows the data elements to be immutable while allowing a developer to upgrade the contract that defines the struct to alter the tags.
	Mutable elements store Capability pointers to IMetaDataProvider instances that can be stored anywhere.
		Mutable elements can be used for metadata that can be modified, such as for leveling up a character.
		Mutable elements can also be used for metadata that is shared between multiple NFTs, to minimize redundant data storage.
			A Side-effect (benefit?) here is that if the instance is stored in a contract in the developers account, the developer will need to cover the metaData storage costs instead of the NFT holder.
			PNG_RemoteDefaultImage is a default implementation that can be used to give an NFT a shared and/or updatable image.
				RemotePNGProvider is an example of an implementation of IMetaDataProvider that allows multiple NFTs to share the same image via Capability reference.
*/

pub contract MetaDataUtil {
    pub struct interface ITaggedMetaData {
        pub fun getTags() : [String]
    }

    pub struct interface IMetaDataProvider {
        pub fun getData() : AnyStruct
        pub fun getDataType() : String
    }

    pub struct interface IImmutableMetaData {
        pub let data: AnyStruct
        pub let type: String
    }

    pub struct interface IMutableMetaData {
        pub let dataProvider: Capability<&AnyStruct{IMetaDataProvider}>
    }

    pub struct MetaData {
        pub let elements : [MetaDataElement]

        init(metaData : [MetaDataElement]?) {
            self.elements = metaData ?? []
        }

        pub fun getMetaDataByTag(tag : String) : MetaDataElement? {
            for element in self.elements {
                if (element.hasTag(tag : tag)) {
                    return element
                }
            }
            return nil
        }

        pub fun conformsToSchema(schemaTags : [String]) : Bool {
            var tags : [String] = []
            for element in self.elements {
                tags.appendAll(element.getTags())
            }
            for tag in schemaTags {
                if(!tags.contains(tag)) { 
                    return false
                }
            }
            return true
        }
    }

    pub struct MetaDataElement {
        pub let metaData : AnyStruct{ITaggedMetaData}
        init (metadata : AnyStruct{ITaggedMetaData}) {
            if (!metadata.isInstance(Type<AnyStruct{IMutableMetaData}>()) && !metadata.isInstance(Type<AnyStruct{IImmutableMetaData}>())) {
                panic("Invalid Metadata Type")
            }
            self.metaData = metadata
        }

        pub fun getData() : AnyStruct {
            let m1 = self.metaData as? AnyStruct{IMutableMetaData}
            if(m1 != nil) {
                return m1!.dataProvider.borrow()!.getData()
            }
            let m2 = self.metaData as? AnyStruct{IImmutableMetaData}
            if(m2 != nil) {
                return m2!.data
            }

            panic("Invalid MetaData")
        }

        pub fun getDataType() : String {
            let m1 = self.metaData as? AnyStruct{IMutableMetaData}
            if(m1 != nil) {
                return m1!.dataProvider.borrow()!.getDataType()
            }
            let m2 = self.metaData as? AnyStruct{IImmutableMetaData}
            if(m2 != nil) {
                return m2!.type
            }

            panic("Invalid MetaData")
        }

        pub fun getTags() : [String] {
            return self.metaData.getTags() 
        }

        pub fun hasTag(tag : String) : Bool {
            return self.metaData.getTags().contains(tag)
        }

        pub fun isMutable() : Bool {
            return self.metaData.isInstance(Type<AnyStruct{IMutableMetaData}>())
        }
    }

    pub struct ImmutablyTaggedString : IImmutableMetaData, ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: String
        pub let tags: [String]

        init(data : String, tags: [String]) {
            self.data = data
            self.type = "string"
            self.tags = tags
        }

        pub fun getTags() : [String] {
            return self.tags
        }
    }

    pub struct DefaultName : IImmutableMetaData, ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: String

        init(name : String) {
            self.data = name
            self.type = "string"
        }

        pub fun getTags() : [String] {
            return ["name", "title"]
        }
    }

    pub struct DefaultDescription : IImmutableMetaData, ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: String

        init(description : String) {
            self.data = description
            self.type = "string"
        }

        pub fun getTags() : [String] {
            return ["description"]
        }
    }

    pub struct PNG_DefaultImage : IImmutableMetaData, ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: String

        init(imgData : [UInt8]) {
            self.data = imgData
            self.type = "png"
        }

        pub fun getTags() : [String] {
            return ["image", "portrait"]
        }
    }

    pub struct PNG_RemoteDefaultImage : IMutableMetaData, ITaggedMetaData {
        pub let dataProvider: Capability<&AnyStruct{IMetaDataProvider}>
        
        init(provider : Capability<&AnyStruct{IMetaDataProvider}>) {
            self.dataProvider = provider
        }

        pub fun getTags() : [String] {
            return ["image", "portrait"]
        }
    }

    pub struct RemotePNGProvider : IMetaDataProvider {
        access(self) var data: [UInt8]
        access(self) var isStatic : Bool

        init (imgData : [UInt8], static : Bool) {
            self.data = imgData
            self.isStatic = static
        }

        access(account) fun setImage(imgData : [UInt8]) {
            if(self.isStatic) {
                panic("Cannot Set Static Image")
            }
            self.data = imgData
        }

        pub fun getData() : AnyStruct {
            return self.data
        }

        pub fun getDataType() : String { 
            return "png"
        }
    }
}

/**

## The Flow Non-Fungible Token standard
The only modification made is to add "pub let metadata: MetaDataUtil.MetaData?"
If the NonFungibleToken contract is updated, older NFTs will still be valid but cannot take advantage of the new standard without a wrapper.

*/

// The main NFT contract interface. Other NFT contracts will
// import and implement this interface
//
pub contract interface NonFungibleToken {

    // The total number of tokens of this type in existence
    pub var totalSupply: UInt64

    // Event that emitted when the NFT contract is initialized
    //
    pub event ContractInitialized()

    // Event that is emitted when a token is withdrawn,
    // indicating the owner of the collection that it was withdrawn from.
    //
    // If the collection is not in an account's storage, `from` will be `nil`.
    //
    pub event Withdraw(id: UInt64, from: Address?)

    // Event that emitted when a token is deposited to a collection.
    //
    // It indicates the owner of the collection that it was deposited to.
    //
    pub event Deposit(id: UInt64, to: Address?)

    // Interface that the NFTs have to conform to
    //
    pub resource interface INFT {
        // The unique ID that each NFT has
        pub let id: UInt64
        pub let metadata: MetaDataUtil.MetaData?
    }

    // Requirement that all conforming NFT smart contracts have
    // to define a resource called NFT that conforms to INFT
    pub resource NFT: INFT {
        pub let id: UInt64
        pub let metadata: MetaDataUtil.MetaData?
    }

    // Interface to mediate withdraws from the Collection
    //
    pub resource interface Provider {
        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NFT {
            post {
                result.id == withdrawID: "The ID of the withdrawn token must be the same as the requested ID"
            }
        }
    }

    // Interface to mediate deposits to the Collection
    //
    pub resource interface Receiver {

        // deposit takes an NFT as an argument and adds it to the Collection
        //
        pub fun deposit(token: @NFT)
    }

    // Interface that an account would commonly 
    // publish for their collection
    pub resource interface CollectionPublic {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NFT
    }

    // Requirement for the the concrete resource type
    // to be declared in the implementing contract
    //
    pub resource Collection: Provider, Receiver, CollectionPublic {

        // Dictionary to hold the NFTs in the Collection
        pub var ownedNFTs: @{UInt64: NFT}

        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NFT

        // deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NFT)

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64]

        // Returns a borrowed reference to an NFT in the collection
        // so that the caller can read data and call methods from it
        pub fun borrowNFT(id: UInt64): &NFT {
            pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
        }
    }

    // createEmptyCollection creates an empty Collection
    // and returns it to the caller so that they can own NFTs
    pub fun createEmptyCollection(): @Collection {
        post {
            result.getIDs().length == 0: "The created collection must be empty!"
        }
    }
}