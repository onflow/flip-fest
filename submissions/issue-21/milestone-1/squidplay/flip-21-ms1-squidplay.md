## Intro

This PR is the milestone #1 submission of FLIP Fest issue [#21](https://github.com/onflow/flip-fest/issues/21)

## UI for multiple contracts

Contracts are proposed to be put as horizontal tabs above the Cadence editor following familiar UX of various code editors such as VS Code. It is also to overloading links on the sidebar along with accounts, transaction templates and script templates.

- Initial mockup: https://user-images.githubusercontent.com/81572453/139025502-7b69fe75-8be4-4255-95c5-a8efa6f2f0de.png
- Initial prototype video: https://youtu.be/Od1YxuHA0iA

## Backend changes

New contract schema will be introduced and relevant code changes will be made.

```
type Contract {
  id: UUID!
  accountId: UUID
  index: Int!
  title: String!
  script: String!
  deployedScript: String
}
```
