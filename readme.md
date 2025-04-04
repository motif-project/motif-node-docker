# Motif Deployment Guide

This guide provides comprehensive instructions for deploying the Motif application using Docker and Docker Compose.

---

## Prerequisites

Before starting, ensure the following prerequisites are met:

- **Docker**: Installed and configured.
- **Docker Compose**: Installed and configured.
- **Bitcoin Node**: 
  - Access to a full Bitcoin Node with transaction indexing enabled. (Optional: Run a Bitcoin Node using Docker. Follow the [official guide](https://hub.docker.com/r/bitcoin/bitcoin).)
  - Access to a standalone Bitcoin Node with only the Bitcoin wallet running (not connected to the BTC chain).

---

## Configuration

### 1. Database Configuration

Update the connection parameters in the `docker-compose.yml` file as needed:
```yaml
POSTGRES_USER: user1
POSTGRES_PASSWORD: password1
POSTGRES_DB: databasename
```

Ensure the same parameters are updated in the `configs/config.json` file:
```json
"DB_user": "user1",
"DB_password": "password1",
"DB_name": "databasename"
```

> **Note**: If using PostgreSQL inside a Docker container, do not use `localhost` as the `db_host` in the Motif configuration file. Instead, use the container name (e.g., `postgres_container`).

---

### 2. Application Configuration

The `config.json` file contains all application settings. Ensure the following configurations are correctly specified:

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

---

## Key Points to Consider

- **PostgreSQL Volume**: Docker mounts the PostgreSQL database volume to `./psql/data`. Do not replace or move this folder.
- **Ethereum Wallet**: 
  - If no Ethereum wallet is found, a new wallet is created and stored in `./motif/data`. Backup this folder.
  - To use an existing keystore, copy the keystore file to `./motif/data`.
  - To create a new wallet, move the existing keystore file from `./motif/data` to another folder and restart the container.
- **Accessing Localhost**:
  - On macOS/Windows: Use `host.docker.internal` as the host.
  - On Linux: Run `ip addr show docker0` to find the Docker-assigned IP for the local machine.

---

## Running the Application

1. Start the Docker containers:
   ```bash
   docker-compose up
   ```

2. If starting with a new Ethereum wallet, the system will halt with an error (`insufficient funds`). Add funds to the printed Ethereum address and restart:
   ```bash
   docker-compose up
   ```

---

## Additional Notes

- Ensure all configurations are correctly set before starting the application.
- Backup critical data such as Ethereum keystore files and PostgreSQL volumes.
