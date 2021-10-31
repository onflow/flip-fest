# New Tool: Block explorer GUI  - Milestone 4


## Description

This PR is for issue [#2](https://github.com/onflow/flip-fest/issues/2)

This submission includes implementation of remaining minimum feature set to be fully functional in a bare-bones UI, additionally some optional features are included.

## Features submitted
- Emulator configuration
  - support for all config variables defined [here](https://github.com/onflow/flow-emulator#configuration)
  - setup & manage multiple independant emulators from the Flowser UI
- Blockchain explorer:
  - accounts 
    - transactions
    - contracts (cadence syntax highlighting)
    - keys
    - storage (nicely formatted & highlighted json view)
  - blocks
    - transactions
    - collections
  - transactions
    - script (cadence syntax highlighting)
    - signatures
    - events
  - contracts
    - code
  - events
    - data
- Emulator logs
    - View and easily search through the log output of the emulator.
    - Nicely highlighted & formatted log syntax
- Common features
  - navigation with "count badges" (badges showing total number of items - accounts, contracts, transactions,... on the network)
  - filterable lists
- Support for other networks
  - "out of the box" support for other flow networks (currently testnet, possibly mainnet in the future)
  - app is containerised and is therefore easily deployable/portable to any server or cloud provider
- Native support for [fcl-dev-wallet](https://github.com/onflow/fcl-dev-wallet)
  - log in with service account
  - send arbitrary transactions (tx arguments are also supported)
- Minimal test coverage
- Custom made project website: [flowser.dev](https://bartolomej.github.io/flowser)

## Submission Links & Documents

- Project website: [flowser.dev](https://bartolomej.github.io/flowser)
- [Source code](https://github.com/bartolomej/flowser)
- [Known issues + enhancement ideas](https://github.com/bartolomej/flowser/issues)
- [Wireframes](https://xd.adobe.com/view/819fdc90-8c90-4464-a971-dfadb2223b5d-d4cc/specs/): Link to XD Adobe where wireframes can be seen. Use navigation arrows at the bottom of the screen to step through the wireframes.


## Requirements Check

- Have have you met the milestone requirements? YES
- Have you included tests (if applicable)? YES (more to come)
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)? YES
- If this is the last milestone:
    - Demonstrate that you've met all the acceptance criteria (link to code, demos, instructions to run etc.) - check "Submission Links & Documents"
    - Demonstrate that you've met all milestone requirements and highlight any extensions or additional work done. - YES
    - Include a payout structure by percentage for each team member. 
      -  monikaxh: 18%
      -  jgololicic: 45.5%
      -  bartolomej: 36.5%

## Other Details

- Is there anything specific you'd like the PoC to know or review for? NO
- Are there other references, documentation, or relevant artificats to mention for this PR (ie. external links to justify design decisions, etc.)?
  - CREDITS: [@bluesign](https://github.com/bluesign) - provided a useful [script](https://gist.github.com/bluesign/df24b31a61bf4cd11f88efb6edd78925) for indexing flow emulator db