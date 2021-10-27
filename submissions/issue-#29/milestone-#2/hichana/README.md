# hichana submission for milestone #2, FLIP issue #20

Thank you for reviewing my submission for FLIP issue #29 milestone: "2. Implement an updated UI for resource explorer with current set of features.". Before providing instructions and a screenshot-walkthrough of the UI, some clarifications: 

- I'm submitting this PR for milestone #2 before my PR for milestone #1 has been fully accepted, tho after checking with the POC for this issue it appears that it's ok for me to complete this milestone at this point. I can update the UI if needed if changes are required.
- All new UI elements representing the interface for new funcitonality are implemented. In most cases they have partial, but not full functionality. Some UI elements, such as text to describe to the user who has updated storage and in what account, are hard-coded text for now. Full functionality will be added with Milestone 3.

## Instructions for viewing the new UI elements in a running app:
1. I have not changed the playground api, but I am running it locally during development. The `codegen.yml` file therefore points to the local host 8080. Please run the playground api locally.
2. make sure `.env.local` has been copied into a `.env` file
3. run `npm run start` to start to local playground app
4. open a new playground: http://localhost:3000/ and click 'Save'
5. add contract and transactions in order to add items to account 0x01 and 0x02's storage for demonstration purposes:
    - copy the [ExampleToken.cdc](https://play.onflow.org/3a3ae03f-a22b-4cab-9e79-63cdd7d290ce?type=account&id=0) contract into the local playground's 0x01 account
    - copy the [Create Link](https://play.onflow.org/3a3ae03f-a22b-4cab-9e79-63cdd7d290ce?type=tx&id=c8b28f67-9a3a-4bd7-90ed-cc5a0c03eb8d) transaction code into a new transaction in the local playground named 'Create Link'
    - copy the [Setup Account](https://play.onflow.org/3a3ae03f-a22b-4cab-9e79-63cdd7d290ce?type=tx&id=45c4f04f-c17e-4231-b5b4-5d6d0720ed12) transaction code into a new transaction in the local playgorund named 'Setup Account'
    - copy the [Mint Tokens](https://play.onflow.org/3a3ae03f-a22b-4cab-9e79-63cdd7d290ce?type=tx&id=47cfa1b3-4581-4984-91f2-ccb443c61a46) transaction code into a new transaction in the local playgorund named 'Mint Tokens'
6. Deploy and exectute transactions:
    - Deploy 'ExampleToken.cdc' to 0x01 (note, there seems to be a bug that requires you to reload the playground in the browswer before you can deploy, so please refresh your browser before deploying. I don't believe I introduced this bug as it happens on the master branch as well)
    - Execute the 'Create Link' once with 0x01 as the signer, and then 0x02 as the signer
    - Execute the 'Setup Account' transaction with 0x02 as the signer
    - Execute the 'Mint Tokens' transaction with 0x01 as the signer
7. Explore the UI:
    - quickly explore multiple accounts and see visual cues:
        - click on the icon to the right of 0x02 in the sidebar (appears as a database icon). The resources explorer should render both 'MainReceiver' and 'MainVault' with badges that represent visual cues as to what is in storage
        - click on the icon to the right of 0x01 in the sidebar. The resources explorer should re-render just the storage items for 0x01.
        - click on different accounts (0x03, etc.) and watch the code area change, but the resource explorer persist and correspond to the icon in the sidebar that is green (all others are grey). The heading in the resources explorer will show the account who's storage is selected currently in tandem with the green icon for that user.
    - show which user's resource has been updated and by whom:
        - click on the icon next to 0x02 to show their resources
        - click on the 'MainVault' resource in the explorer and scroll down in the window displaying the data in order to see the "balance" section
        - with the 'Mint Tokens' transaction selected, hit the 'Send' button. Watch an animated mini-toasdt appear under the Transaction Signers hover box telling the user who has updated who's storage. Also see the balance increment in the currently selected user's MainVault storage item
    - autogenerate a transaction or strict:
        - With the storage for 0x02 selected, mouse over the circle icon with a plus sign inside of it next to the 'MainReceiver' capability in the resources explorer. This will open a placeholder popup window where the user might select a template and give it a name.
        - click the 'Create' button. A new transaction should be created and focus moved to the code editor where the user can work on the transaction or script.
    