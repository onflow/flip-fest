# hichana submission for milestone #1, FLIP issue #58

### SUMMARY
Thank you for reviewing my submission for FLIP issue #58 milestone: "1. Eliminate each error referenced in the issues above. When applicable, refactor the code to avoid similar errors in the future.". I previously made a PR [#167](https://github.com/onflow/flip-fest/pull/59) with the basic solution. My latest PR [#172](https://github.com/onflow/flow-playground/pull/172) includes that fix together with a refactor that removes unecessary redirects and results in a better experience for users. I think that this refactor solution adds value to the playground, but if it is not acceptable or preferred for any reason my milestone [milestone #0.5](https://github.com/hichana/flip-fest/blob/submission/issue-%2358/milestone-%230.5/hichana/submission/issue-%2358/milestone-%230.5/hichana/%23%20milestone_readme.md) solution can be considered as my final solution for this FLIP.

My code submission is PR [#172](https://github.com/onflow/flow-playground/pull/172) on the playground repo.

As I explained in my 0.5 solution, when loading the playground, 5 entries are added into the browser's history stack. 

        - http://localhost:3000/
        - http://localhost:3000/local
        - http://localhost:3000/LOCAL-project?type=account&id=LOCAL-account-0
        - http://localhost:3000/?type=account&id=LOCAL-account-0
        - http://localhost:3000/local?type=account&id=LOCAL-account-0

I was able to reduce this to 1 entry per user action. Below are some example routes that results from a given user action (consider 'http://localhost:3000/' as 'https://play.onflow.org'):

##### USER:
User visits the playground:
http://localhost:3000/

Saves the projcet: 
http://localhost:3000/a5051080-76f5-483a-8b93-9e4cfe31acf9

Clicks on any given Account in the sidebar: 
http://localhost:3000/a5051080-76f5-483a-8b93-9e4cfe31acf9?type=account&id=6e9f4a3e-a374-44b0-8519-55111c222c9a

Click on a transaction in the sidebar:
http://localhost:3000/a5051080-76f5-483a-8b93-9e4cfe31acf9?type=tx&id=f5de3435-856a-462f-afbc-b351c976d4e2

Clicks on a script in the sidebar:
http://localhost:3000/a5051080-76f5-483a-8b93-9e4cfe31acf9?type=script&id=49b58d42-f5f2-400d-8687-4dcf3c5c0cc0

##### VISITOR:
Visitor visits the owner's playground:
- enters in browser URL bar: 
  - URL persists the owner's UUID and type, replaces the type id with the local version: http://localhost:3000/a5051080-76f5-483a-8b93-9e4cfe31acf9?type=script&id=LOCAL-script-temp-0
- clicks on any given account, transaction or script:
  - URL changes to http://localhost:3000/LOCAL-project?type=account&id=LOCAL-account-1 but persists the data from the owner's playground (same behavior as play.onflow.org)

##### REDIRECT HANDLING:
- any incorrect project ID will redirect to the root http://localhost:3000 with a new project
- any incorrect id entered for any given account, tx or script will redirect to the first id in the array for an account, tx or script