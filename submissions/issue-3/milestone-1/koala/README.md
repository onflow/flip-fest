# VS Code Extension: Architecture improvements - Milestone 1
For issue #3 (https://github.com/onflow/flip-fest/issues/3)

Ed Burnette (ed.burnette@gmail.com) / Team Koala

## Problem statement (copied from issue #3)
The VS Code extension architecture could be improved so the extension becomes lighter and only handles the communication with the language server and the UI. This simplification would allow easier testing, less complexity and, better UX during the installation process. Currently, the extension requires the Flow CLI pre-installed in order to start and manage the emulator as well as to start the language server itself.

The proposed improved architecture would be for the language server to wrap the emulator by including flowkit dependency and start and manage the emulator state from there. The language server would then need to stream the emulator output to the extension for a developer to see in the output. The language server should also be bundled together with the extension as an npm module so it can be started directly from the VS Code.

## Current architecture

    Extension --> Language Server (in the CLI)
              \-> CLI --> Emulator (in the CLI)

Currently, the CLI includes the emulator and language server. The extension composes and executes CLI commands to start both the emulator and language server, and requires the CLI to be installed ahead of time.

## Basic architecture for the extension improvements

    Extension --> Language Server -> Emulator
                  (in Extension)     (in Language Server)

This lets the user install one thing - the extension - and control everything from VSCode. They could optionally install the CLI if they wish, but the CLI would *not* be installed or required by the extension.

The flowkit package is currently part of the flow-cli repo. I propose moving it out to its own top level repo, and documenting it with a README. This will be the way the language server runs the emulator. 

The CLI will need to be refactored to reflect the move. Any internal calls in or out of flowkit will need to be refactored as public calls. Dependencies between the packages should be limited.

## Requirements Check

- Have have you met the milestone requirements? YES
- Have you included tests (if applicable)? N/A
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)? N/A
- If this is the last milestone: N/A

## Other Details

- Is there anything specific you'd like the PoC to know or review for? NO
- Are there other references, documentation, or relevant artificats to mention for this PR (ie. external links to justify design decisions, etc.)? NO

