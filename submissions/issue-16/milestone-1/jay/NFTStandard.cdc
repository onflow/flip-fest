/*
	This project is addressing problem "New Standard: NFT metadata #16"
	The below code is untested and is meant as an illustration of the concept.

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