#### General Configuration
- **env**: Specifies the environment (`dev` or `prod`).

#### Database Configuration
- **DB_port**: Port number for the PostgreSQL database.
- **DB_host**: Hostname or container name (e.g., `postgres_container`).
- **DB_user**: Database username.
- **DB_password**: Database password.
- **DB_name**: Database name.

#### Bitcoin Node Configuration
- **btc_node_host**: Hostname and port of the Bitcoin node.
- **btc_node_user**: Username for Bitcoin node authentication.
- **btc_node_pass**: Password for Bitcoin node authentication.
- **btc_node_protocol**: Protocol (e.g., `http://`).
- **fee_rate_adjustment**: Adjusts Bitcoin transaction fee rates.
- **wallet_name**: Name of the Bitcoin online wallet.
- **btc_xpublic_key**: Extended public key for deriving Bitcoin addresses.

#### Multisig Wallet Configuration
- **multisig_signing_wallet_name**: Name of the multisig offline signing wallet.
- **multisig_btc_node**: Hostname and port of the Bitcoin node for multisig signing.
- **multisig_btc_user**: Username for multisig Bitcoin node authentication.
- **multisig_btc_pass**: Password for multisig Bitcoin node authentication.
- **multisig_btc_protocol**: Protocol (e.g., `http://`).

#### Ethereum Configuration
- **eth_rpc_host**: RPC endpoint for Ethereum network.
- **eth_ws_host**: WebSocket endpoint for Ethereum network.
- **eth_keystore_dir**: Directory for Ethereum keystore files.
- **eth_keystore_passphrase**: Passphrase for the Ethereum keystore.

#### Smart Contract Addresses
- **opr_metadata_uri**: URI for operator metadata.
- **eigen_delegation_manager_address**: Address of the Eigen Delegation Manager contract.
- **motif_registry_address**: Address of the Motif Registry contract.
- **service_manager_address**: Address of the Service Manager contract.
- **eigen_avs_directory_address**: Address of the Eigen AVS Directory.
- **pod_manager_address**: Address of the Pod Manager contract.