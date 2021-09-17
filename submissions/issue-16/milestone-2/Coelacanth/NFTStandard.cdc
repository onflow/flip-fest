/*
	This project is addressing problem "New Standard: NFT metadata #16"
	The below code is untested and is meant as an illustration of the concept.
	
	MetaDataUtil, MIME, and CommonMetaDataElements are added as a new default contracts.
	
	Metadata is instantiated in the form of structs at the time the NFT is minted.
	Metadata is organized by string tags, and each metadata element may have multiple tags allowing NFTs to conform to multiple tag schemas.
	Metadata elements cannot be added after the NFT is minted, but Mutable elements can allow data to be modifiable.
	
	MetaDataElements are wrappers around two possible types of structs, one of which is immutable and the other of which is Mutable.
	MetaDataElements possess 3 accessible functions that access stored properties 
		The getData function can return an object of any AnyStruct type, and contains the actual metadata itself
		The getDataType function returns a DataType object that describes the MIME type of the object for reference by off-chain systems
			MIME type is used as it is a widely used standard that can already be understood by browsers
			DataTypes also contain isLink, which is true if the data element describes a link to externaly hosted data.
			compressedMIME is used to describe the internal data type if the data blob should be decompressed by the client 
	Immutable elements can use default types or be defined in custom structs that implement ITaggedMetaData and IImmutableMetaData. 
		Defining a custom class allows the data elements to be immutable while allowing a developer to upgrade the contract that defines the struct to alter the tags.
	Mutable elements store Capability pointers to IMetaDataProvider instances that can be stored anywhere.
		Mutable elements can be used for metadata that can be modified, such as for leveling up a character.
		Mutable elements can also be used for metadata that is shared between multiple NFTs, to minimize redundant data storage.
			A Side-effect (benefit?) here is that if the instance is stored in a contract in the developers account, the developer will need to cover the metaData storage costs instead of the NFT holder.
			PNG_RemoteDefaultImage is a default implementation that can be used to give an NFT a shared and/or updatable image.
				RemotePNGProvider is an example of an implementation of IMetaDataProvider that allows multiple NFTs to share the same image via Capability reference.

	MIME contains a number of commonly used DataTypes for convenience
	CommonMetaDataElements contains default struct implementations that can be wrapped by MetaDataElements
		More default struct implementations should be added for any other common use cases
*/

pub contract MetaDataUtil {
    //Utilizing MIME types as existing standard, this will allow metadata to be more easily parsed by a browser
    //Any non-conformant type should use a MIME type with the following syntax "application.cadence+T" where T is the Type
    pub struct DataType {
        //This should be an IANA MIME type
        pub let MIME : String
        //Is the data a link to a file on an external service (ipfs for instance)
        pub let isLink : Bool
        //if the data is compressed, this IAMA MIME type of the data inside the compressed bytes
        pub let compressedMIME : String?

        init(MIME : String, isLink : Bool, compressedMIME : String?)  {
            self.MIME = MIME
            self.isLink = isLink
            self.compressedMIME = compressedMIME
        }
    }

    //Interface for Partial MetaDataElement implementation.
    pub struct interface ITaggedMetaData {
        pub fun getTags() : [String]
        pub let id: UInt64
    }

    pub struct interface IMetaDataProvider {
        pub fun getData(id: UInt64) : AnyStruct
        pub fun getDataType(id: UInt64) : DataType
        pub fun getTags(id: UInt64) : [String]
    }

    pub struct interface IImmutableMetaData {
        pub let data: AnyStruct
        pub let type: DataType
    }

    pub struct interface IMutableMetaData {
        pub let dataProvider: Capability<&{IMetaDataProvider}>
    }

    pub struct MetaData {
        pub let elements : [MetaDataElement]

        init(metaData : [MetaDataElement]?) {
            self.elements = metaData ?? []
        }

        pub fun getMetaDataByTag(tag : String) : [MetaDataElement] {
            var taggedElements : [MetaDataElement] = []
            for element in self.elements {
                if (element.hasTag(tag : tag)) {
                    taggedElements.append(element)
                }
            }
            return taggedElements
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

    //Struct wrapper around metadata implemenations.
    //Because this struct is defined in default contract, users can rest assured that the code that accesses their metadata cannot be altered.
    pub struct MetaDataElement {
        pub let metaData : {ITaggedMetaData}

        init (metadata : {ITaggedMetaData}) {
            //This forces metadata to conform to expected implementations of "ITaggedMetaData,IMutableMetaData" or "ITaggedMetaData,IImmutableMetaData"
            if (!metadata.isInstance(Type<{IMutableMetaData}>()) && !metadata.isInstance(Type<{IImmutableMetaData}>())) {
                panic("Invalid Metadata Type")
            }
            self.metaData = metadata
        }

        pub fun getData() : AnyStruct {
            let m1 = self.metaData as? {IMutableMetaData}
            if(m1 != nil) {
                return m1!.dataProvider.borrow()!.getData(id: self.metaData.id)
            }
            //Immutable data directly references storage via default contract code, ensuring it cannot be altered by contract upgrade
            let m2 = self.metaData as? AnyStruct{IImmutableMetaData}
            if(m2 != nil) {
                return m2!.data
            }

            //this cannot be reached
            panic("Invalid MetaData")
        }

        pub fun getDataType() : DataType {
            let m1 = self.metaData as? {IMutableMetaData}
            if(m1 != nil) {
                return m1!.dataProvider.borrow()!.getDataType(id: self.metaData.id)
            }
            //Immutable data directly references storage via default contract code, ensuring it cannot be altered by contract upgrade
            let m2 = self.metaData as? AnyStruct{IImmutableMetaData}
            if(m2 != nil) {
                return m2!.type
            }

            //this cannot be reached
            panic("Invalid MetaData")
        }

        pub fun getTags() : [String] {
            //ITaggedMetaData relies on function to return tags for both immutable and mutable. This allows contract upgrades to effect tags.
            return self.metaData.getTags()
        }

        pub fun hasTag(tag : String) : Bool {
            return self.metaData.getTags().contains(tag)
        }

        //This method can be checked to determine if the associated metadata is able to be altered by developers
        pub fun isMutable() : Bool {
            return self.metaData.isInstance(Type<AnyStruct{IMutableMetaData}>())
        }
    }
}

pub contract MIME {
    pub let TextPlain : MetaDataUtil.DataType
    pub let HttpLink : MetaDataUtil.DataType
    pub let ImagePNG : MetaDataUtil.DataType
    pub let Numeric : MetaDataUtil.DataType
    pub let AnyStruct : MetaDataUtil.DataType

    init() {
        self.TextPlain = MetaDataUtil.DataType("text/plain",false,nil)
        self.HttpLink = MetaDataUtil.DataType("text/plain",true,nil)
        self.ImagePNG = MetaDataUtil.DataType("image/png",false,nil)
        //Not an official MIME type, but can be used for numeric data that will be returned in cadence object format
        self.Numeric = MetaDataUtil.DataType("application/cadence+Number",false,nil)
        //Not an official MIME type, but can be used for arbitrary data that will be returned in cadence object format
        self.AnyStruct = MetaDataUtil.DataType("application/cadence+AnyStruct",false,nil)
    }
}

pub contract CommonMetaDataElements {
    //This implementation allows the tags to also be immutable if required for some reason
    pub struct ImmutablyTaggedData : MetaDataUtil.IImmutableMetaData, MetaDataUtil.ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: MetaDataUtil.DataType
        pub let tags: [String]
        pub let id: UInt64

        init(data : AnyStruct, type: MetaDataUtil.DataType, tags: [String]) {
            self.data = data
            self.type = type
            self.tags = tags
            self.id = 0
        }

        pub fun getTags() : [String] {
            return self.tags
        }
    }

    //Default element implementation for a named NFT, most NFTs will need this
    pub struct DefaultName : MetaDataUtil.IImmutableMetaData, MetaDataUtil.ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: MetaDataUtil.DataType
        pub let id: UInt64

        init(name : String) {
            self.data = name
            self.type = MIME.TextPlain
            self.id = 0
        }

        pub fun getTags() : [String] {
            return ["name", "title"]
        }
    }

    //Default element implementation for an NFT with a text description, most NFTs will need this
    pub struct DefaultDescription : MetaDataUtil.IImmutableMetaData, MetaDataUtil.ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: MetaDataUtil.DataType
        pub let id: UInt64

        init(description : String) {
            self.data = description
            self.type = MIME.TextPlain
            self.id = 0
        }

        pub fun getTags() : [String] {
            return ["description"]
        }
    }

    //Default element implementation for an NFT with unique and immutable binary data that stores a png format image
    pub struct PNG_DefaultImage : MetaDataUtil.IImmutableMetaData, MetaDataUtil.ITaggedMetaData {
        pub let data: AnyStruct
        pub let type: MetaDataUtil.DataType
        pub let id: UInt64

        init(imgData : [UInt8]) {
            self.data = imgData
            self.type = MIME.ImagePNG
            self.id = 0
        }

        pub fun getTags() : [String] {
            return ["image", "portrait"]
        }
    }

    pub struct UpdatableStats : MetaDataUtil.IMutableMetaData, MetaDataUtil.ITaggedMetaData {
         pub let dataProvider: Capability<&AnyStruct{MetaDataUtil.IMetaDataProvider}>
        pub let id: UInt64
        
        init(id: UInt64, provider : Capability<&UpdatableStatsProvider{MetaDataUtil.IMetaDataProvider}>,) {
            self.dataProvider = provider
            self.id = id
        }

        pub fun getTags() : [String] {
            return self.dataProvider.borrow()!.getTags(id: self.id)
        }
    }

    //An instance of this struct is needed for any NFT that utilizes UpdatableStatistics. 
    //A single instance can be shared by multiple resources.
    //As a statistic entry, type of data is assumed to be a number, a string, or a complex struct (Array/Dictionary/Custom)
    //Data can be updated arbitrarily by the account that holds this struct in storage, so this should only be stored in developer controlled account
    pub struct UpdatableStatsProvider : MetaDataUtil.IMetaDataProvider {
        access(self) var data: {UInt64: AnyStruct}
        access(self) var tags: {UInt64: [String]}
        access(self) var type: {UInt64: MetaDataUtil.DataType}

        init () {
            self.data = {}
            self.tags = {}
            self.type = {}
        }

        pub fun addData (id: UInt64, data : AnyStruct, tags : [String]) {
            if(self.data[id] != nil) {
                panic("data already exists for id")
            }

            self.data[id] = data
            self.tags[id] = tags
            self.type[id] = MIME.AnyStruct

            if(data as? Number != nil) {
                self.type[id] = MIME.Numeric
            }
            else if(data as? String != nil) {
                self.type[id] = MIME.TextPlain
            }
        }

        pub fun setData(id: UInt64, data : AnyStruct) {
            if(data.getType() != self.data.getType()) {
                if(data as? Number != nil) {
                    self.type[id] = MIME.Numeric
                }
                else if(data as? String != nil) {
                    self.type[id] = MIME.TextPlain
                }
                else {
                    self.type[id] = MIME.AnyStruct
                }
            }
            
            self.data[id] = data
        }

        //Tags are not static and can be updated
        pub fun setTags(id: UInt64, tags : [String]) {
            self.tags[id] = tags
        }

        pub fun getData(id: UInt64) : AnyStruct {
            return self.data[id]!
        }

        pub fun getDataType(id: UInt64) : MetaDataUtil.DataType { 
            return self.type[id]!
        }

        pub fun getTags(id: UInt64) : [String] {
            return self.tags[id]!
        }
    }

    //Default element implementation for an NFT with mutable or shared binary data that stores a png format image
    pub struct PNG_RemoteDefaultImage : MetaDataUtil.IMutableMetaData, MetaDataUtil.ITaggedMetaData {
        pub let dataProvider: Capability<&AnyStruct{MetaDataUtil.IMetaDataProvider}>
        pub let id: UInt64
        
        init(id: UInt64, provider : Capability<&CommonMetaDataElements.RemotePNGProvider{MetaDataUtil.IMetaDataProvider}>) {
            self.dataProvider = provider
            self.id = id
        }

        pub fun getTags() : [String] {
            return self.dataProvider.borrow()!.getTags(id: self.id)
        }
    }

    //An instance of this struct is needed for any NFT that utilizes PNG_RemoteDefaultImage. 
    //A single instance can be shared by multiple resources.
    //This provider allows the data to be either mutable or semi-immutable
    //Data can be updated arbitrarily by the account that holds this struct in storage, so this should only be stored in developer controlled account
    //If needing to store the image in the storage of the resource holder, developers will need to make a custom provider.
    pub struct RemotePNGProvider : MetaDataUtil.IMetaDataProvider {
        access(self) var data: {UInt64: [UInt8]}
        access(self) var isStatic: {UInt64: Bool}

        init() {
            self.data = {}
            self.isStatic = {}
        }

        pub fun addImage (id: UInt64, imgData : [UInt8], static : Bool) {
            if(self.data[id] != nil) {
                panic("")
            }

            self.data[id] = imgData
            self.isStatic[id] = static
        }

        pub fun setImage(id: UInt64, imgData : [UInt8]) {
            if(self.isStatic[id]!) {
                panic("Cannot Set Static Image")
            }
            self.data[id] = imgData
        }

        pub fun getData(id: UInt64) : AnyStruct {
            return self.data
        }

        pub fun getDataType(id: UInt64) : MetaDataUtil.DataType { 
            return MIME.ImagePNG
        }

        pub fun getTags(id: UInt64) : [String] {
            return ["image", "portrait"]
        }
    }
}

pub contract interface NonFungibleToken2 {

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