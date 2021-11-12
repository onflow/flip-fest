## New Tool: Build a Flow SDK - Milestone 4

## Description

This PR is for issue #20.

This version of the Ruby SDK provides gRPC communication and a number of the SDK user stories, including script execution and single sig transaction signing and sending.

Usage documentation is available at https://github.com/glucode/flow_client

## Milestone 4

All user stories from the SDK guidelines have been completed and tests have been added that execute against the emulator.

Usages documentation can be found at https://github.com/glucode/flow_client

### Features

Blocks:
- [x] retrieve a block by ID
- [x] retrieve a block by height
- [x] retrieve the latest block

Collections:
- [x] retrieve a collection by ID 

Events:
- [x] retrieve events by name in the block height range

Scripts:
- [x] submit a script and parse the response
- [x] submit a script with arguments
- [x] create a script that returns complex structure and parse the response

Accounts:
- [x] retrieve an account by address
- [x] create a new account
- [x] deploy a new contract to the account
- [x] remove a contract from the account
- [x] update an existing contract on the account

Transactions: 
- [x] retrieve a transaction by ID
- [x] sign a transaction with same payer, proposer and authorizer
- [x] sign a transaction with different payer and proposer
- [x] sign a transaction with different authorizers using sign method multiple times
- [x] submit a signed transaction
- [x] sign a transaction with arguments and submit it
