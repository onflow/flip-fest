## Flow-.Net-SDK - Milestone 3, 4

This PR is for issue #20.

## SDK repo

https://github.com/tyronbrand/flow.net

### Current Status

The flow.net SDK has completed all required milestones. This includes, tests, documentation and examples.

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

### Milestones

- 1 [x] Implement the gRPC layer of the SDK, allowing communication with the Flow blockchain
- 2 [x] Accomplish transaction signing in a way that handles the complex algorithm / hashing / encoding for the user.
- 3 [x] Meet and exceed Flow SDK guidelines
- 4 [x] Complete documentation and common usage examples are available
