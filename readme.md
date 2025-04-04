# Motif Deployment Guide

This guide provides comprehensive instructions for deploying the Motif application using Docker and Docker Compose. Motif testnet is based on Holesky(eth testnet) and signet(btc).

The Operator Node communicates with Motif core contracts deployed on holesky. [here](https://github.com/Layr-Labs/eigenlayer-contracts/tree/testnet-holesky?tab=readme-ov-file#current-testnet-deployment) are the latest contract addresses and furthur details on these contracts.

---

## Prerequisites

Before starting, ensure the following prerequisites are met:

- **Docker**: Installed and configured. Please refer to [docker installation guide](https://docs.docker.com/engine/install/)
- **Docker Compose**: Installed and configured. Please refer to [docker installation guide](https://docs.docker.com/engine/
- **Bitcoin Node**: 
  - Access to a full Bitcoin Node with transaction indexing enabled. (Optional: Run a Bitcoin Node using Docker. Follow the [official guide](https://hub.docker.com/r/bitcoin/bitcoin) or [install without docker.](https://bitcoin.org/en/full-node)). Ensure That the `.bitcoin.conf` file has `signet=1` and `index=1` values.
  - Access to a standalone Bitcoin Node with only the Bitcoin wallet running (not connected to the BTC chain).

- **Ethereum Holesky server**:
    - Access to ethereum Holesky server. you can either deploy your own node or use infura, alchemy or anyother such service.

---

## Configuration

### 1. BTC Offline wallet setup 

We recommend using an instance of [bitcoin-core] (https://bitcoin.org/en/releases/27.0/) configured in the Offline signing wallet mode.The Bitcoin Core wallet is the preferred choice because it enables clients to utilize external signers and boasts a long-standing, rigorously tested codebase.

For ensuring wallet security, it is strongly recommended to use a separate host system with atleast 4 GB RAM and 2 GB available storage space. The system should be completely disconnected from all public networks (internet, tor, wifi etc.). The `offline` wallet host is not required to download or synchronize blockchain data.

The offline wallet should be setup as a server as part of a secured private network where, the wallet is only accessible through a designated rpc connection with `btc-oracle`. To ensure the integrity and security of the data, only `TLS` based rpc connection should be allowed between `btc-oracle` and the offline wallet node. 

### 1.1 Installation

Download and install the bitcoin binaries according to your operating systemfrom the official [Bitcoind Core registry](https://bitcoincore.org/bin/bitcoin-core-27.0/). All programs in this guide are compatible with version `27.0`.

### 1.2 Configuration
`bitcoind` instance can be configured by using a `bitcoin.conf` file. In `Linux` based systems the file is found in `/home/<username>/.bitcoin`.

A sample configuration file with recommended settings is as follows
```shell
# Accept command line and JSON-RPC commands
server=1

# RPC server settings
rpcuser=<rpc-username>
rpcpassword=<rpc-password>
# field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>.
# rpcauth = <userpw>

# Port your bitcoin node will listen for incoming requests;
# listening for bitcoin mainnet
rpcport=8332 
# Address your bitcoin node will listen for incoming requests
# should be the address of your offline host
rpcbind=0.0.0.0
# Needed for remote node connectivity
# btc-oracle IP should only be allowed 
rpcallowip=0.0.0.0/0
# Offline Wallet server shouldn't connect to any external p2p or chain node
connect=0
```

JSON-RPC connection authentication can be configured to use `rpc-username`:`rpc-password` pair or a `username and HMAC-SHA-256 hashed password` through rpcauth option. It is not recommended to hardcode `rpc-password` in the config file. The salted hash can be created from canonical python script included in the share/rpcauth in bitcoin-core installed directory. 

---

### 2. Database Configuration

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

### 3. Application Configuration

The [`config.json`](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file contains all application settings. Refer to the [config.md](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.md) file to see details on the configurations. 

Make the changes in the [config.json](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file. This file will be used when we create the docker container. 

Please ensure that the system is properly configured before running the docker. 

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

Please ensure that the system is properly configured before running the docker. 

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

---
