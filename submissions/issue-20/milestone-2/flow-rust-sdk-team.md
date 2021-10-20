##  Flow-Rust-SDK - Milestone 2

This PR is for issue #20.


### Milestone 2 Completion:
- 2: Accomplish transaction signing in a way that handles the complex algorithm / hashing / encoding for the user.

Transactional signing and RLP encoding turned out to be the most difficult and time-consuming task of this project.
@bluesign provided a significant amount of help by sharing knowledge gained while working on his Swift SDK.

Transaction signing is implemented in the Flow-Rust-SDK lib.rs [starting on line 466](https://github.com/MarshallBelles/flow-rust-sdk/blob/344d7d8f7aa2aa67c47455e54bedf4723138a981/src/lib.rs#L466). 

The transaction payload RLP encoding takes place [on line 414](https://github.com/MarshallBelles/flow-rust-sdk/blob/344d7d8f7aa2aa67c47455e54bedf4723138a981/src/lib.rs#L414) and the transaction envelope is encoded [on line 370](https://github.com/MarshallBelles/flow-rust-sdk/blob/344d7d8f7aa2aa67c47455e54bedf4723138a981/src/lib.rs#L370).


Before signing a transaction, you must first define and build one. This is demonstrated in the `create_account` function starting [on line 176](https://github.com/MarshallBelles/flow-rust-sdk/blob/344d7d8f7aa2aa67c47455e54bedf4723138a981/src/lib.rs#L176):
```rs
// The following is copied from the library.
// To execute the code shown below, copy the example at: https://github.com/MarshallBelles/flow-rust-sdk-example/blob/main/src/main.rs
// our default values passed into the transaction
let payer = "f8d6e0586b0a20c7";
let payer_private_key = "324db577a741a9b7a2eb6cef4e37e72ff01a554bdbe4bd77ef9afe1cb00d3cec";
let public_keys = vec!["ef100c2a8d04de602cd59897e08001cf57ca153cb6f9083918cde1ec7de77418a2c236f7899b3f786d08a1b4592735e3a7461c3e933f420cf9babe350abe0c5a".to_owned()];

// Define the transaction to be executed.
// Here we are using AuthAccount to create a new account and assign keys
let create_account_template = b"
    transaction(publicKeys: [String], contracts: {String: String}) {
        prepare(signer: AuthAccount) {
            let acct = AuthAccount(payer: signer)
    
            for key in publicKeys {
                acct.addPublicKey(key.decodeHex())
            }
    
            for contract in contracts.keys {
                acct.contracts.add(name: contract, code: contracts[contract]!.decodeHex())
            }
        }
    }";

// we get the latest block for the transaction
let latest_block: BlockResponse = self.get_block(None, None, Some(false)).await?;
// and then we need to get the authorizer account
let account: flow::Account = self.get_account(payer.clone())
    .await?
    .account
    .unwrap();
// because then we need the proposal key details
let proposer = TransactionProposalKey {
    address: hex::decode(payer).unwrap(),
    key_id,
    sequence_number: account.keys[key_id as usize].sequence_number as u64,
};
// here we process the key arguments
let keys_arg = process_keys_args(account_keys);
// empty contracts for this example
let contracts_arg = Argument::dictionary(vec![]);
// the following two lines handles the arguments and turns them into JSON strings for the transaction.
let keys_arg = json!(keys_arg);
let contracts_arg = json!(contracts_arg);
// build the transaction
let transaction: Transaction = build_transaction(
    create_account_template.to_vec(),
    vec![
        serde_json::to_vec(&keys_arg)?,
        serde_json::to_vec(&contracts_arg)?,
    ],
    latest_block.block.unwrap().id,
    1000,
    proposer,
    vec![payer.clone()],
    payer.clone(),
)
.await?;

// After building the transaction, we need to sign the transaction.
// Here we define the signature
let signature = Sign {
    address: payer.clone(),
    key_id,
    private_key: payer_private_key.clone(),
};

// now we can sign the transaction
let transaction: Option<Transaction> = sign_transaction(transaction, vec![], vec![&signature]).await?;

// and send it to the blockchain
let transaction: SendTransactionResponse = self.send_transaction(transaction).await?;

// from here the library polls the blockchain for the transaction result
```

The part above where we `sign_transaction` looks like this:
```rs
pub async fn sign_transaction(
    built_transaction: Transaction,
    payload_signatures: Vec<&Sign>,
    envelope_signatures: Vec<&Sign>,
) -> Result<Option<Transaction>, Box<dyn error::Error>> {
    let mut payload: Vec<TransactionSignature> = vec![];
    let mut envelope: Vec<TransactionSignature> = vec![];
    // for each of the payload private keys, sign the transaction
    for signer in payload_signatures {
        let encoded_payload: &[u8] = &payload_from_transaction(built_transaction.clone());
        let mut domain_tag: Vec<u8> = b"FLOW-V0.0-transaction".to_vec();
        // we need to pad 0s at the end of the domain_tag
        padding(&mut domain_tag, 32);

        let fully_encoded: Vec<u8> = [&domain_tag, encoded_payload].concat();
        let mut addr = hex::decode(signer.address.clone()).unwrap();
        padding(&mut addr, 8);

        payload.push(TransactionSignature {
            address: addr,
            key_id: signer.key_id,
            signature: sign(fully_encoded, signer.private_key.clone())?,
        });
    }
    // for each of the envelope private keys, sign the transaction
    for signer in envelope_signatures {
        let encoded_payload: &[u8] =
            &envelope_from_transaction(built_transaction.clone(), &payload);
        let mut domain_tag: Vec<u8> = b"FLOW-V0.0-transaction".to_vec();
        // we need to pad 0s at the end of the domain_tag
        padding(&mut domain_tag, 32);

        let fully_encoded: Vec<u8> = [&domain_tag, encoded_payload].concat();
        let mut addr = hex::decode(signer.address.clone()).unwrap();
        padding(&mut addr, 8);

        envelope.push(TransactionSignature {
            address: addr,
            key_id: signer.key_id,
            signature: sign(fully_encoded, signer.private_key.clone())?,
        });
    }
    let signed_transaction = Some(Transaction {
        script: built_transaction.script,
        arguments: built_transaction.arguments,
        reference_block_id: built_transaction.reference_block_id,
        gas_limit: built_transaction.gas_limit,
        proposal_key: built_transaction.proposal_key,
        authorizers: built_transaction.authorizers,
        payload_signatures: payload,
        envelope_signatures: envelope,
        payer: built_transaction.payer,
    });
    Ok(signed_transaction)
}
```

You can see in the snippet above that both payload and envelope signatures are handled for the user in a manner that reduces the complexity and does not require an advanced understanding of RLP encoding.

Authors include:

    @marshallbelles
    @bluesign
