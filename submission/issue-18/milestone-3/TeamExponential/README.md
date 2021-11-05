# Playground Feature: Markdown READMEs - Milestone 4

## Description

This PR is for issue #18.

We added support for storing and loading the README data on the backend and updating the GraphQL API. We followed the existing pattern and updated the storage, model and controller to include the new variables. We further added [sanitization](https://github.com/microcosm-cc/bluemonday) on save to make sure no untrusted data is stored. The tests were also updated to include tests for the newly introduced fields and sanitization. 

Our code submission can be found here [#13](https://github.com/onflow/flow-playground-api/pull/13)