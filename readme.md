# Motif Deployment Guide

This guide provides comprehensive instructions for deploying the Motif application using Docker and Docker Compose. It also takes care of **registering the operator with Motif** automatically at the end of the deployment. Motif testnet is based on Holesky (Ethereum testnet) and Signet (Bitcoin testnet).

The Operator Node communicates with Motif core contracts deployed on Holesky. Here are the latest contract addresses and further details on these contracts.

This setup runs a Bitcoin Signet node inside a container.

---

## Prerequisites

Before starting, ensure the following prerequisites are met:

- **Docker** and **Docker Compose**: Installed and configured. Refer to [Docker docs](https://docs.docker.com/get-started/).
- **Bitcoin Node**:
  - No prior setup required. The provided Docker Compose setup includes a Bitcoin node.
  - It will automatically create two wallets: `motifOnline` and `motifOffline`. These can be renamed in the [btc_entrypoint.sh](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/btc_entrypoint.sh) file.
- **Ethereum Holesky server**:
  - Use your own node or a provider such as Infura or Alchemy.

---

## Quick Start (Recommended Path for First-Time Operators)

These steps are for operators new to Bitcoin and Motif. This helps reduce friction and lets you see the system running before diving into custom keys and wallet configs.

1. Clone the repository:
   ```bash
   git clone https://github.com/motif-project/motif-node-docker.git
   ```

2. Edit the [config.json](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json):
   - Set your `opr_name`, `opr_logo_uri`, and `opr_ip_address`
   - Set your Ethereum RPC/WebSocket endpoints:
     ```json
     "eth_rpc_host": "",
     "eth_ws_host": ""
     ```

3. Start the containers:
   ```bash
   docker compose up
   ```

   - This will spin up three services: `motif`, `postgres-container`, and `bitcoin`.
   - `postgres-container` will initialize first. Once you see `database system is ready to accept connections`, the system waits 1 minute before initializing the Bitcoin container.
   - The system will create new BTC and Ethereum wallets and attempt to register your operator.

4. From the logs:
   - Copy the second-last xpub/tpub key (`btc_xpublic_key`) and update it in [config.json](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json).
   - Copy the new Ethereum address and use a [Holesky faucet](https://cloud.google.com/application/web3/faucet/ethereum/holesky) to fund it.

   ![Reference](https://github.com/motif-project/motif-node-docker/blob/main/docs/btc_xpublic_key.png  "reference Screenshot")

5. Restart the stack:
   ```bash
   docker compose down
   docker compose up
   ```
   - You'll again see the wallet info. `motif` will register your operator after a 5-minute delay (Bitcoin Node starting).

6. Verify operator registration:
   - Visit https://motif-unlock.vercel.app/operators
   - Search for the name you set in `opr_name` in your `config.json` file to confirm that your operator has been successfully registered.

---

## Setting Up with Custom Bitcoin and Ethereum Keys (Advanced)

If you prefer to set your own Bitcoin and Ethereum keys before starting, follow these steps:

1. Update RPC credentials in [bitcoin.conf](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/data/bitcoin.conf):
   ```
   rpcuser=yourusername
   rpcpassword=yourpassword
   ```

2. Change wallet names in [btc_entrypoint.sh](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/btc_entrypoint.sh):
   ```bash
   WALLET_ONLINE="yourOnlineWallet"
   WALLET_OFFLINE="yourOfflineWallet"
   ```

3. In [btc Dockerfile](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/Dockerfile#L8), comment/uncomment the appropriate architecture section based on your CPU.

4. Update DB credentials in [docker-compose.yml](https://github.com/motif-project/motif-node-docker/blob/btc-docker/docker-compose.yml#L30):
   ```yaml
   POSTGRES_USER: user1
   POSTGRES_PASSWORD: password1
   POSTGRES_DB: databasename
   ```

5. Update [config.json](https://github.com/motif-project/motif-node-docker/blob/btc-docker/configs/config.json):
   - Set operator details.
   - Match DB credentials with docker-compose values.
   - Match Bitcoin RPC credentials (`btc_node_user`, `btc_node_pass`, `wallet_name`).
   - Match multisig wallet credentials (`multisig_btc_user`, `multisig_btc_pass`, `multisig_signing_wallet_name`).
   - Update Ethereum keystore passphrase (`eth_keystore_passphrase`).
   - If using your own node, update `btc_node_host` and `multisig_btc_node`.

6. Start the stack:
   ```bash
   docker-compose up
   ```

   - If insufficient funds, you'll get an error. Use the logs to extract Ethereum address and xpub key.
   - Fund the Ethereum wallet and update the xpub in `config.json`.
   - Restart:
     ```bash
     docker-compose up
     ```

---

## Appendix A: Manual Bitcoin Node Installation (Optional)

This appendix is intended for operators who do **not** wish to use the provided Docker-based Bitcoin node and would rather run their own Bitcoin node manually.

### A.1 Installation

Download and install the Bitcoin node according to your operating system from the official [Bitcoind Core registry](https://bitcoincore.org/bin/bitcoin-core-27.0/). All programs in this guide are compatible with version `27.0`.

### A.2 Configuration

`bitcoind` is a daemon installed with Bitcoin node. It can be configured using a `bitcoin.conf` file. On Linux systems the file is located at `/home/<username>/.bitcoin/bitcoin.conf`.

A sample configuration file with recommended settings:
```conf
server=1
rpcuser=<rpc-username>
rpcpassword=<rpc-password>
rpcport=8332
rpcbind=0.0.0.0
rpcallowip=0.0.0.0/0
connect=0
```

JSON-RPC authentication can be set using `rpcuser`/`rpcpassword` or via the `rpcauth` hashed format. Use the `share/rpcauth` script in the bitcoin-core directory to generate secure hashes.

If using a manual Bitcoin node setup, ensure you update the following fields in your `config.json`:
- `btc_node_host`
- `btc_node_user`
- `btc_node_pass`
- `wallet_name`
- `multisig_btc_node`
- `multisig_btc_user`
- `multisig_btc_pass`
- `multisig_signing_wallet_name`

This allows you to integrate your own Bitcoin node setup with the rest of the Motif stack.

---

### 2. Database Configuration

Set DB credentials in [`docker-compose.yml`](https://github.com/motif-project/motif-node-docker/blob/main/docker-compose.yml):
```yaml
POSTGRES_USER: user1
POSTGRES_PASSWORD: password1
POSTGRES_DB: databasename
```

Update [`config.json`](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json):
```json
"DB_user": "user1",
"DB_password": "password1",
"DB_name": "databasename"
```

> Note: Use `postgres_container` as `db_host` inside the Docker network, not `localhost`.

---

### 3. Motif Configuration

The [`config.json`](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file contains all application settings. Refer to [config.md](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.md) for details.

Ensure the following are updated:
- Operator info
- DB credentials
- Bitcoin node + multisig credentials (use same if running both wallets on same node)
- Ethereum wallet passphrase
- Ethereum RPC/WebSocket URLs
- `btc_xpublic_key` from logs if using auto-generated wallets
- [Motif contract addresses](https://github.com/Layr-Labs/eigenlayer-contracts/tree/testnet-holesky?tab=readme-ov-file#current-testnet-deployment)

---

## Key Considerations

- **PostgreSQL Volume**: Data is stored in `./psql/data`. Do not move or delete.
- **Ethereum Wallet**:
  - If not found, a new one is generated in `./motif/data`. Backup this.
  - To use an existing keystore, place it in `./motif/data`.
- **Bitcoin Wallet**:
  - All signet data is in `./btc/data/signet`. Don’t delete this or a fresh sync will occur.
- **Accessing Localhost from Container**:
  - macOS/Windows: Use `host.docker.internal`
  - Linux: Use the IP shown by `ip addr show docker0`

---

## Final Notes

- Double-check configurations before startup.
- Always backup keystore files and Postgres data volumes.
- This guide is optimized for ease of use for EigenLayer operators unfamiliar with Bitcoin nodes.

