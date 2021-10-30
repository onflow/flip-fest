## Intro

This PR is the milestone #2 submission of FLIP Fest issue [#21](https://github.com/onflow/flip-fest/issues/21)

## Code

_Backend_: flow-playground-api has been forked and work is done on [flip-21 branch]()

Run datastore emulator first
```
  gcloud beta emulators datastore start
```

Then run the server
```
  make run-datastore
```


Frontend: flow-playground has been forked and work is done on [flip-21 branch]()

```
  npm install
  npm run start
```

## What has been done
- [x] frontend: project default loading with multiple contracts per account
- [x] frontend: contracts can be added, edited, deployed and deleted
- [x] backend: support the above interactions


## To-dos
- [ ] fix bugs
- [ ] code clean-up
- [ ] add tests
- [ ] add documentations
