## [Improve Existing SDK: Python] - Milestone 1 & 2

## Description

This PR is for issue #46.

All user stories are completed, examples and usage documentions are available at: https://github.com/janezpodhostnik/flow-py-sdk 

## Features:

Blocks:

- [x] retrieve a block by ID
- [x] retrieve a block by height
- [x] retrieve the latest block

Collections:

- [x] retrieve a collection by ID

Events:

- [x] retrieve events by name in the block height range

Scripts:

- [x]  submit a script and parse the response
- [x] submit a script with arguments and parse the response

Accounts:

- [x] retrieve an account by address
- [x] create a new account
- [x] deploy a new contract to the account
- [x] remove a contract from the account
- [x] update an existing contract on the account

Transactions:

- [x] retrieve a transaction by ID
- [x] sign a transaction (single payer, proposer, authorizer or combination of multiple)
- [x] submit a signed transaction
- [x] sign a transaction with arguments and submit it

## Milestones

- [x] 1: Implement examples covering all user stories.
- [x] 2: Create tests, documentation, and optimize for performance and usability.

## Other Details

### Authers

@amhossaini
@barekati