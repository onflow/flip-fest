## PR Title
CryptoDappy Feature: NFT Marketplace

## Description

This PR is for issue #5

In this PR I include coding functionalities in both frontend and backend (smartcontracts)

#### A. Front End:
  - Different UI for collector's listing in storefront: Green border and burst-out shape
  - Auto re-fetch data from chain to reflect the dappie after sale / purchase
  - Drag-n-drop capability to breed panel on the right hand side. 
  - Animations for the whole breeding process: 
    + Before signing the transaction: Eye pumping,
    + After transaction succeeded: Baby dappies appear and fade out in 5s.
    
#### B. Backend (smart-contract)

  - New smart contracts: DappyNFT.cdc, PackNFT.cdc, GalleryContract.cdc.
  - Modified smart contracts: DappyContract.cdc, NonFungibleToken.cdc, NFTStorefront.cdc
  - 7 Unit tests to support newly created smart contract and code changed.
  - 15 new transactions to support three main process: list dappy in storefront, pack and sell dappies and breed dappies
  - Various scripts and code changes    
  
  - List of requirements that are being submitted.
    - [x] Frontend implementation
    - [x] Smart contract implementation, documentation & video walkthrough
  

## Submission Links & Documents

Link to crypto-dappy PR: [https://github.com/bebner/crypto-dappy/pull/15]
Link to Demo: https://youtu.be/Udsn45p7gRE

## Requirements Check

- Have have you met the milestone requirements? Yes
- Have you included tests (if applicable)? Yes
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)? Yes
- If this is the last milestone:
  - Demonstrate that you've met all the acceptance criteria (link to code, demos, instructions to run etc.) Yes
  - Demonstrate that you've met all milestone requirements and highlight any extensions or additional work done. Yes
  - Include a payout structure by percentage for each team member (ie. Bob: 20%, Alice: 80%). Payout: Nwin 100%

## Other Details

- Is there anything specific you'd like the PoC to know or review for? N/A
- Are there other references, documentation, or relevant artificats to mention for this PR (ie. external links to justify design decisions, etc.)? N/A
