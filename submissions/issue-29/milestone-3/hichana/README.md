# hichana submission for milestone #3, FLIP issue #29

Thank you for reviewing my submission for FLIP issue #29 milestone: "3. Add support for new features on both the frontend and backend.". Before providing instructions and a screenshot-walkthrough, some notes:

- I have chosen to submit this final milestone as early as possible and using remaining time to continue soliciting feedback and iteratively improving my solution wherever possible right up until the deadline of the flip fest.
- I did minor refactoring and updates where needed to ensure new features function as expected
- I attempted to align all code style, element styling, etc. with what exists in the codebase currently. Most importantly I did my best to build the feature set, yet do so within the existing look and feel of the playground.
- I did not introduce any unecessary third-party libraries. For example, when creating the toast feature, I could have npm-installed a pre-built library for a quick solution, however it likely would have been difficlut to enforce styling continuity, it would have increased the bundle size, and might have posed a number of other problems. Instead, I used framer-motion (which we already use) to build a simple yet well-functioning toast. Below are some examples of libraries which I investigated but chose not to use.
    https://www.npmjs.com/package/react-toastify
    https://www.npmjs.com/package/react-simple-toasts- 


### Screenshot walkthrough
- URL params

  - 'none' renders no resources explorer on load
  ![URL-params-1]()

  - '0x01' renders resources explorer for account 0x01 on load 
  ![URL-params-2]()


- decoupled resources explorer to explore multiple accounts without jarring any other user experiences in the playground

  - icon to right of each account indicates (in 'Flow' green) whether or not their storage is selected for display. After interacting with storage via a transaction or deploying a contract, and then selecting one of the storage icons, resources for the given account display.
  ![Decoupled-1]()

  - click on any other account, transaction or script to display the content as usual (in this case a transaction), with the storage icon and corresponding resources explorer content persisting in the resources explorer. Selecting an account storage icon with no items in storage will indicate to the user that storage is empty.
  ![Decoupled-2]()

- Resources Explorer

  - secion label displays user account corresponding to the storage data displayed
  - account storage items show with badge for any given type (Resource, Capability, Struct)
  - selected storage item displays the path and object data
  ![Resources-explorer-1]()


- Account storage has been updated toast

  - after processing any transaction that updates the storage for any account, a toast will pop up messaging to the user which account(s) initiated the transaction and which account(s') storage has been updated.
  - toast disappears automatically after 5 seconds
  - each toast has a close icon-button that will collapse
  - toast will stack and fall away gracefully with successive transactions
  ![Toast-1]()


- Script/Transaction template modal
  - plus icon next to Capabilities in resources explorer pulls up modal that conditionally displays text, and conditionally renders select element options based on the capabilities present in account storage
  - 'Create' button will generate a working script template with comments to help new users
  ![Script-tx-template-1]()
  ![Script-tx-template-2]()
  ![Script-tx-template-3]()


## Instructions for viewing the new UI elements in a running app:
1. I have not changed the playground api, but I am running it locally during development. The `codegen.yml` file therefore points to the local host 8080. Please run the playground api locally.
2. make sure `.env.local` has been copied into a `.env` file
3. run `npm run start` to start to local playground app
4. open a new playground: http://localhost:3000/ and click 'Save' (note, there may be a pre-existing issue here that requires you to refresh your browswer before being able to save)
5. add contract and transactions:
    - copy the [ExampleToken.cdc](https://play.onflow.org/fc011ed8-e59c-4d2c-97be-85d941a73512?type=account&id=195880aa-d3b7-4d72-b64a-4722f3ee6719) contract into the local playground's 0x01 account
    - copy the [Create Link](https://play.onflow.org/fc011ed8-e59c-4d2c-97be-85d941a73512?type=tx&id=c40db3bc-2762-46a0-b0e1-25f35051a05f) transaction code into a new transaction in the local playground named 'Create Link'
    - copy the [Setup Account](https://play.onflow.org/fc011ed8-e59c-4d2c-97be-85d941a73512?type=tx&id=eb49ebe7-0d4e-4984-939f-8f7afea7bfad) transaction code into a new transaction in the local playgorund named 'Setup Account'
    - copy the [Mint Tokens](https://play.onflow.org/fc011ed8-e59c-4d2c-97be-85d941a73512?type=tx&id=27fd3e3c-c611-441f-871e-c256e721762c) transaction code into a new transaction in the local playgorund named 'Mint Tokens'
    - copy the [Create Test Capabilities](https://play.onflow.org/fc011ed8-e59c-4d2c-97be-85d941a73512?type=tx&id=c7253900-f595-4391-99ed-af7aadd7035c) transaction code into a new transaction in the local playgorund named 'Create Test Capabilities'
6. Deploy and exectute transactions in order to add items to account 0x01 and 0x02's storage for demonstration purposes:
    - Deploy 'ExampleToken.cdc' to 0x01 
    - Execute the 'Create Link' once with 0x01 as the signer
    - Execute the 'Setup Account' transaction with 0x02 as the signer
    - Execute the 'Mint Tokens' transaction with 0x01 as the signer
    - Execute the 'Create Test Capabilities' transaction with 0x02 as the signer
7. Explore the UI:
    - quickly explore multiple accounts and see visual cues:
        - click on the storage icon to the right of 0x02 in the sidebar. The resources explorer should render both 'MainReceiver', 'MainVault', 'BalanceOnly', and 'ReceiverOnly' with badges that represent visual cues as to what is in storage
        - click on the icon to the right of 0x01 in the sidebar. The resources explorer should render just the storage items for 0x01.
        - click on different accounts (0x03, etc.) and watch the code area change, but the resource explorer persist and correspond to the icon in the sidebar that is green (all others are grey). The heading in the resources explorer will show the account who's storage is selected currently in tandem with the green icon for that user.
    - show which user's resource has been updated and by whom:
        - click on the icon next to 0x02 to show their resources
        - click on the 'MainVault' resource in the explorer and scroll down in the window displaying the data in order to see the "balance" section
        - with the 'Mint Tokens' transaction selected and account 0x01 as the signer, hit the 'Send' button. Watch an animated toast element appear on the bottom left of the window, telling the user who has updated who's storage. Also see the balance increment in the currently selected user's MainVault storage item
    - autogenerate a transaction or script:
        - With the storage for 0x02 selected, mouse over the circle icon with a plus sign inside of it next to the 'MainReceiver' capability in the resources explorer. This will open a placeholder popup window where the user might select a template and give it a name.
        - select whether you want ot create a script or transaction and then click the 'Create' button. A new script or transaction should be created and focus moved to the code editor where the user can work on the transaction or script.

## Additional Instructions for viewing Struct and Null resources in user storage
In the same project used in the last set of instructions, do the following:
1. Add another contract and transactions:
    - copy the [Approval Voting](https://play.onflow.org/cc2f56cf-c539-42c4-8b28-b988c3c5e048?type=account&id=9f584571-83fb-477e-ac00-09939fe5e315) contracts into 0x02
    - copy [Transaction 1](https://play.onflow.org/cc2f56cf-c539-42c4-8b28-b988c3c5e048?type=tx&id=a0ff0f37-1446-45ec-952d-9f8d0fc020a8) into a new tx in the local playground with the same name
    - copy [Transaction 2](https://play.onflow.org/cc2f56cf-c539-42c4-8b28-b988c3c5e048?type=tx&id=0d512c51-0641-41b0-8178-41d2f608bd3d) into a new tx in the local playground with the same name
    - copy [Transaction 3](https://play.onflow.org/cc2f56cf-c539-42c4-8b28-b988c3c5e048?type=tx&id=0c0c88e4-9248-4af2-a515-22408b19c49b) into a new tx in the local playground with the same name
2. Deploy and exectute transactions in order to add items to account 0x02 and 0x03's storage for demonstration purposes:
    - Deploy 'ApprovalVoting' to 0x02
    - Execute 'Transaction 1' with 0x02 as the signer