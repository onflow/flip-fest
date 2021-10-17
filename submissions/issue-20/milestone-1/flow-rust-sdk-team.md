##  Flow-Rust-SDK - Milestone 1

This PR is for issue #20.


### Milestone 1 Completion:
- 1 [x] Implement the gRPC layer of the SDK, allowing communication with the Flow blockchain

Inside the [lib.rs](https://github.com/MarshallBelles/flow-rust-sdk/blob/release/src/lib.rs) a gRPC client has been defined as a struct on line 38: `FlowConnection` which accepts a network transport layer of type `<T>`. A default implementation for type `tonic::transport::Channel` is implemented starting on line 43, using the [Tonic gRPC library](https://crates.io/crates/tonic) to facilitate communications.

You can test this connection by instantiating the struct with the helper function `FlowConnection::new("grpc://address");`.

A more full example of usage:
```rs
use flow_rust_sdk::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // instantiate a new connection:
    let mut connection = FlowConnection::new("grpc://localhost:3569").await?;
        // Substitute emulator service account address as the payer, and keys if needed.
        let payer = "f8d6e0586b0a20c7";
        let payer_private_key = "324db577a741a9b7a2eb6cef4e37e72ff01a554bdbe4bd77ef9afe1cb00d3cec";
        let public_keys = vec!["ef100c2a8d04de602cd59897e08001cf57ca153cb6f9083918cde1ec7de77418a2c236f7899b3f786d08a1b4592735e3a7461c3e933f420cf9babe350abe0c5a".to_owned()];

        // Use the connection defined above to send a transaction to the blockchain, created and signed within the helper function `create_account`
        let acct = connection.create_account(
            public_keys.to_vec(),
            &payer.to_owned(),
            &payer_private_key.to_owned(),
            0,
        )
        .await
        .expect("Could not create account");
        println!("new account address: {:?}", hex::encode(acct.address));
    Ok(())
}
```

Authors include:

    @marshallbelles
    @bluesign
