## Flow Providers: Non-custodial wallets - Milestone 1

## Description

This PR is for issue [#28](https://github.com/onflow/flip-fest/issues/28).

- We have complete the desigining of the wallet.
 - Brief introduction of the features we'll cover and how we'll achieve them.
 - Details about the architecture of key management and user flow.
 - Prospects to the future when we can implement the full version of UniPass on Flow to present a keyless experience for users in an non-custodial way.

## Submission Links & Documents

- Document link: https://lay2.notion.site/UniPass-Flow-Wallet-Design-4b165a80e5ba4e64b7051461fab3a0cf.

## Requirements Check

- Have have you met the milestone requirements?
  - Yes
- Have you included tests (if applicable)?
  - No tests for this milestone
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)?
  - No code for this milestone

## Other Details

- Is there anything specific you'd like the PoC to know or review for?
  - UniPass has one of the best account abstraction design, yet it requires RSA signature verification ability from the Layer1 to make it possible.
  - For now we have to use mnemonics as the backup method, which we think is too much for ordinory users.
  - We would like to bring an Internet experience also to Flow users, so maybe we can discuss about this feature after we complete this request.
  
- Are there other references, documentation, or relevant artificats to mention for this PR (ie. external links to justify design decisions, etc.)?
  - UniPass adheres to a pure web format, so as to achieve maximum compatibility and cross-platform ability, and significantly reduce user cost with instant access through links.
  - We are not compromising on security because of convenience, because we manage the keys through built-in managers of the browsers(SubtleCrypto) and even the devices(Webauthn).
