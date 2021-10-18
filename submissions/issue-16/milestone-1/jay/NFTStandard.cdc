/*
	This project is addressing problem "New Standard: NFT metadata #16"
	The below code is untested and is meant as an illustration of the concept.

    NftBase is added as a new default contract.


    The standard should
        fields are clear: any developer should comply, and browsers and other integrators can get the same type of data without any hassle
        very few restrictions: only abstract the common parts, whether they are needed for games, artwork or other projects
        easy to understand: standard contracts should not use complex design patterns and concepts, novice developers should also be able to understand and agree
        can be inherited: complex projects need to inherit this standard contract, and then it is easy to write their own extensions
*/

pub contract NftBase {
    pub struct Metadata {
        // the title of Nft
        pub let title: String
        // the creator address of Nft, royalty income should be transferred to this address
        pub let creator: Address
        // the description of Nft
        pub let description: String
        // Nft data storage links, either on a centralized server or on another chain, such as ipfs
        pub let url: String
        // the MD5Hash of Nft's file, used to verify the correctness of the Nft
        pub let MD5Hash: String
        // whether the metadata of this Nft is frozen, stored on the centralized server should be false, this field can be modified by the owner of the contract
        pub let isFrozened: Bool
        // Nft's trading royalties can be modified by the creator

        // I'm not sure if there is official support for storing files directly on the flow chain, which should be very costly
        // pub let rawdataOnChain: String

        init(title: String,creator: Address,description: String,url: String,MD5Hash: String,royalty: UFix64) {
            self.title=title
            self.creator=creator
            self.description=description
            self.url=url
            self.MD5Hash=MD5Hash
            self.isFrozened=false
            self.royalty=royalty
        }
    }

    // Anyone can call and see the metadata of the Nft
    pub fun GetData(NftID: UInt64):Metadata? {

    }

    // only can be called by Nft's creator
    pub fun SetRoyalty(NftID: UInt64,royalty: UFix64):Bool{

    }

    // only can be called by contract's owner
    pub fun SetFrozened(NftID: UInt64):Bool{

    }
}

/*
just add  `metadata: NftBase.MetaData?`
older NFTs will still be available after the NonFungibleToken contract is updated,but without new standard function to use.
*/

pub contract interface NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()

    pub event Withdraw(id: UInt64, from: Address?)

    pub event Deposit(id: UInt64, to: Address?)

    pub resource interface INFT {
        pub let id: UInt64
        pub let metadata: NftBase.MetaData?
    }

    pub resource NFT: INFT {
        pub let id: UInt64
        pub let metadata: NftBase.MetaData?
    }

    pub resource interface Provider {
        pub fun withdraw(withdrawID: UInt64): @NFT {
            post {
                result.id == withdrawID: "The ID of the withdrawn token must be the same as the requested ID"
            }
        }
    }

    pub resource interface Receiver {
        pub fun deposit(token: @NFT)
    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NFT
    }

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
