## Adding Decentralized Capability To Crypto Dappy

![](https://miro.medium.com/max/1230/0*lIs7FOBwwaIX5WQS.png)

If you haven’t heard about it, Flow Chain is a powerful blockchain service, focusing on NFT and already had killer applications running like NBA Topshot, SportsIcon. There are several starter projects for Flow chain: [Dapp Starter](https://dappstarter.decentology.com/), [Kitty Items](https://github.com/dapperlabs/kitty-items), but my favorite one is Crypto Dappy ([demo app here](https://demo.cryptodappy.com/) ) for these reasons:

*   **It has intuitive interface**. I love the little details like item animations and smooth SVG rendering that which was carefully crafted by Ben Ebner and the team behind.
*   **It it simple to deploy and run**. It will run straight out of the box on Flow testnet, without the headache of a long build. Most starter app will encourage you to first run on a combo of emulator and dev wallet; Crypto Dappy however take a testnet-first approach, I believe. The lead-time can be a few minutes before you are fully up and running on testnet.
*   **It has least dependencies**. One brilliant idea from the team was getting rid of the DB behind and made all data available on-chain. I believe that approach is only available on flow network, due to its special architecture of different node types that enable users to store more data with less cost and processing time. You can read more about it on its [mission #2](https://www.cryptodappy.com/missions/mission-2)

![image](https://user-images.githubusercontent.com/2296203/140015065-25d115ee-ae08-440d-bf57-b32c56a55922.png)

Revolutionary Design Of Flow Blockchain with Different Types of Nodes

When I first read about the project, it was essentially a centralized trading example. After logging in users will be able to mint NFT from some readily available templates (those templates are also stored on chain). Their NFT will then be available for viewing only by the owners as a collection.

For the purpose of a starter app, it works pretty well because new learners can easily grasp the idea of the code behind. I however think I could contribute to the code base in these ways:

*   After purchasing the NFT from the store, the users should be able to re-list their assets for sale. It is best for all parties if the assets remain in the owner’s custody while listed because it is more secured, and it is scalable when there are many sale agents or aggregators can list the assets simultaneously.
*   The project already has a “pack” purchase features, which users can buy NFT in bulk. So it is simple for me to enable them to pack and sell their own NFTs.
*   It is natural for me to think of a “breeding” feature for the little dappies because their appearance are already defined based on a DNA string (like "FF5A9D.FFE922.60C5E5.0")

I decided to use a drag and drop interface so that if those features are added the app will stay as intuitive as it was.

![image](https://user-images.githubusercontent.com/2296203/140015120-e7a12ec9-12c3-48a0-add3-85978bec11c0.png)


UI Sketch

❸ seems to be easiest on, at least on the surface, however it hold the keys to ❶ and ❷. For one reason, if you can list one NFT in a decentralized manner, you can also list them in bulk, or breed them, literally you can do everything with them before sending them to smart contract.

The hint from the team was using [NFTStorefront smart contract](https://github.com/onflow/nft-storefront/) as a starting point. One (big) problem was that Dappy Crypto was designed decoupled the standard NonFungibleToken.cdc. NFTStorefront.cdc contract, which was released much later than NBA Topshot smart contract templates, relied heavily on NonFungibleToken.cdc. The natural and probably most effective approach is to mofify DappyContract.cdc to conform with NonFungibleToken.cdc (as a sub type contract). However I didn’t have any clearance to do such a thing, plus to do that meant I have to modified many little places here and there for the current code base to normally function.

I decided to wrapped the resouce Dappy inside another Resource type DappyNFT, which was implemented under NonFungibleToken.cdc standard.

![image](https://user-images.githubusercontent.com/2296203/140015171-d12411a4-6212-43e7-9096-a6f297ac3f9a.png)


For the time being, there is a bug in Flow testnet that prevent us to load data from a nested resource. For example if you declare a nested resource and later access its property like this:

```
pub resource NFT: NonFungibleToken.INFT { pub let id: UInt64 pub let nft: @{UInt64: DappyContract.Dappy}...let dappyID = NFT.nft.id
```

An error will be thrown from no where:

```
error: Missing value for member id.
```

My solution was to put the nested resource in side a resource dict: `let nft: @{UInt64: DappyContract.Dappy}` and later access it like `let res <- self.nft[self.nftUUID!] <-nil` Note that only resource dict will work, resource array will not 🤔

I took the same approach for PackNFT, to pack several @Dappy resources into a resource dict and store it under PackNFT.NFT resource.

One thing that puzzled me was the design of NFTStorefront.cdc contract: I wouldn’t work out of the box IMAO. Let’s check this out: under @Listing resource defined in NFTStorefront contract, there is a function to borrow a reference to NFT.

```
pub fun borrowNFT(): &NonFungibleToken.NFT
```

The purpose of this function is that we can use the reference borrowed to read the properties of the NFT (price, name, etc.), without having to “load” the whole NFT out of its storage (which also requires owner’s privilege)

DappyNFT is a contract sub type of NonFungibleToken, so Dappy.NFT is also a resource sub type of NonFungibleToken.NFT. Hence, if you have a @Collection of @DappyNFT.NFT, sometime down the line you should be able to call something like this:

```
collectionRef.borrowNFT() as! &DappyNFT.NFTlet id = collectionRef.id
```

Except you _cannot_ do such an downcast of NonFungibleToken.NFT to DappyNFT.NFT, at least in current testnet. One way of fixing this is to “patch” a custom provider interface into that capability and also create a custom borrowNFT function:

```
pub var nftProviderCapability: Capability<&{NonFungibleToken.Receiver, IProvider}>?...pub resource CustomProvider: IProvider, NonFungibleToken.Receiver {...
```

That will save us from modifying NonFungibleToken contract, but we _do_ need to adjust both NFTStorefront and DappyNFT contracts to conform with our new standard. So I choose to just simply add “auth” keyword in front of any reference to NonFungibleToken.NFT return type and be done with it:

```
pub fun borrowNFT(): **auth** &NonFungibleToken.NFT {
```

It’s far more simpler because I just have to do only 4 inserts and I can start downcast from NonFungibleToken.NFT to DappyNFT.NFT without any problem!

All in all, because of all this not-so-readiness of the contract templates, I had to deploy almost all of them to my own service account instead of using them straight from their default addresses. Except for FungibleToken and FUSD, I wrote a scripts to deploy NonFungibleToken, DappyNFT, PackNFT, NFTStorefront, DappyContract and GalleryContract to my service account and referenced all imports there.

The most interesting part of the project was breeding. For preping up we need to drag two dappies into the right panel component BreedPanel.comp.js. I use react-dnd and add drag-n-drop code to the component:

```
const [, drop] = useDrop(() => ({  
  drop: item => addMate(item)  
}));  
...<div ref={drop} className="right\_panel">  
...
```

One cool thing about dappies is that their graphics are dynamically generated in SVG format, so all the colors, the shapes and contours mix so smoothly together. I take advantage of the SVG tags to make some blinking eye animations when dappies are ready to breed, first by adding `<g className=”dappy_eye”>` to DappyEyes.js and then add animation to it in the css file:

```
@keyframes blink {  
  0%   {transform: scale(.8);}  
  100% {transform: scale(1.5);}  
}@-webkit-keyframes blink {  
  0%   {transform: scale(.8);}  
  100% {transform: scale(1.5);}  
}.right\_panel .dappy\_eye {  
  animation: blink .5s alternate 0s infinite;  
  -webkit-animation: blink .5s alternate 0s infinite;  
  transform-origin: 50% 50%;  
}
```

The DNA should look like this: `"df1f4f.ac069b.25443c.1922ff.1"` or `"ad634b.798f9d.6c2af1.19a9f7.3"` with the segments as its stripe colors and last segment as either eye color index among those segment or a hex color code it self. So the idea of breeding is just randomly pick the segment of both parents and put them together within the rule of dappy’s DNA: no more than 5 stripes, no less than 3 stripes.

These kinds of string algorithms are trivial in scripts, regardless it is Perl, Python or TypeScript. However when it becomes a puzzle if you want to implement it in a smart contract, or at least in Cadence. Let’s look at some issues:

*   pseudoRandom function does not work in Playground, so I have to fake it to test the contracts out.
*   There are no min and max function. Of course one can always use a XOR function, but I didn’t even bother to look further to see if Cadence support a XOR or not. I just implemented them myself, and it pumped the gas price through the roof.
*   String manipulation is very primitive. There is not regex, no string formating, just plain concat function. I guess the more barebone it is, the more secure it gets.

So I implement the breeding logic in BreedDappies.cdc and shoot up the max gas price ⚡

```
try {  
let res = await mutate({  
cadence: BREED\_DAPPIES,  
limit: 6000,  
....
```

To sum up, I am happy to work on this project because with educational purpose in mind, the team really organized the code in to modules with least dependencies, least bugs possible. There is no backend to install and config so we can focus on the smart contracts and react code itself. [The final demo](https://www.youtube.com/watch?v=Udsn45p7gRE) can be watch here:

Demo of peer to peer sale, packing, breeding of dappies

I personally believe this resource oriented approach of Flow Blockchain is revolutionary. It enable end-user the freedom to list their assets for sale while still having them in custody. Imagine you have a piece of land and your land registration is an NFT; the minute you list it for sales, hundreds of trading hub will receive your info and list it without having to collect further information. When your sale is done, those listing would be taken down automatically to avoid double sale.

So for me the idea of peer to peer sale, packing and breeding functionality just came naturally, and I was very lucky to complete the project with prompt support of Max and Ben from Dapper Lab. I hope we will have a chance to work on some other projects in the future.
