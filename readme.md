# Motif Deployment Guide

This guide provides comprehensive instructions for deploying the Motif application using Docker and Docker Compose. Motif testnet is based on Holesky(eth testnet) and signet(btc).

The Operator Node communicates with Motif core contracts deployed on holesky. [Here](https://github.com/Layr-Labs/eigenlayer-contracts/tree/testnet-holesky?tab=readme-ov-file#current-testnet-deployment) are the latest contract addresses and furthur details on these contracts.

This setup runs Bitcoin Signet node and runs it inside the container.

---

## Prerequisites

Before starting, ensure the following prerequisites are met:

- **Docker** and **Docker Compose**: Installed and configured. Please refer to [docker docs](https://docs.docker.com/get-started/).
- **Bitcoin Node**: 
  - Access to a full Bitcoin Node with transaction indexing enabled. 
  - You can run `docker compose up`, this will setup a bitcoin node in a docker container. It also creates two wallets named `motifOnline` and `motifOffline` on the bitcoin node. 
  - The names of these wallets can be changed in the [btc_entrypoint.sh](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/btc_entrypoint.sh) file.
  - You can also use your own Bitcoin node, just update the motif config file accordingly.

- **Ethereum Holesky server**:
    - Access to ethereum Holesky server. you can either deploy your own node or use infura, alchemy or anyother such service. 

---

## Step by step guide.

Please go through the below steps, after ensuring pre requisites are met.

1. Start by updating the `rpcuser` and `rpcpassword` in the [bitcoin.conf](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/data/bitcoin.conf) file.

2. If you want to change the wallet names update them in [btc_entrypoint.sh](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/btc_entrypoint.sh) file.
    ```
    WALLET_ONLINE="motifOnline"
    WALLET_OFFLINE="motifOffline"
    ```

3. Depending on your machine's physical processor architecture, comment/uncomment the appropriate section in the bitcoin [Dockerfile](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/Dockerfile#L8) file. 

4. Update the Database username, password and database name in the [docker-compose](https://github.com/motif-project/motif-node-docker/blob/btc-docker/docker-compose.yml#L30) file.
    ```
    POSTGRES_USER: user1
    POSTGRES_PASSWORD: password1
    POSTGRES_DB: databasename
    ```

5. Update the [config.json](https://github.com/motif-project/motif-node-docker/blob/btc-docker/configs/config.json) file as mentioned below.

    - update the operator details.
    - Database details. make sure the password, username and database name matches what was set in step 4.
    - Bitcoin Node connection details. Only change the `btc_node_user`, `btc_node_pass` and `wallet_name`, and make sure that it matches what was set in step 1 and 2.
    - Multisig signing wallet details. Only change `multisig_btc_user`, `multisig_btc_pass` and `multisig_signing_wallet_name`. If you are using the docker deployed btc node, username and password will be the same as step 1 and wallet name will be what you set up as `WALLET_OFFLINE` in step 2.
    - In case you are using your btc wallet update the `btc_node_host` and `multisig_btc_node`.
    - Update the password for the Ethwallet `eth_keystore_passphrase`.

6. Start the Docker containers:
   ```bash
   docker-compose up
   ```

7. If starting with a new Ethereum wallet and BTC Wallet, the system will halt with an error `insufficient funds`. follow the below steps.
   - Before the system exits it will display xpub/tpub keys from your offline signing wallets. copy the second last xpub/tup key. it will look like the key shared below, Please do not use the one provided below.

      ```
      [9f8c4e0f/84h/0h/0h]xpub6CnorznhQcJDGX47CjYLLoSouDq5ViucAUKknA2M4tDyLUXmTLNE3mzN9vgsQzrv3ZGF2dstz7KccK6oaan6UfUpeFxrEkNxY7pT7atpTpK/0/*
      ``` 

   - Before the system exits it will also display operators new ethereum address. Please use any [holesky faucet](https://cloud.google.com/application/web3/faucet/ethereum/holesky) to add funds to it.

8. update the `btc_xpublic_key` field in the [config.json](https://github.com/motif-project/motif-node-docker/blob/btc-docker/configs/config.json)) file. Make sure the value is the same as what you get in step 7.

9. Restart the system. 
    ```bash
    docker-compose up
    ```

---

## Configuration

### 1.1 BTC Offline wallet setup 

We recommend using an instance of [bitcoin-core](https://bitcoin.org/en/releases/27.0/) configured in the Offline signing wallet mode. The Bitcoin Core wallet is the preferred choice because it enables clients to utilize external signers and boasts a long-standing, rigorously tested codebase.

For ensuring wallet security, it is strongly recommended to use a separate host system with atleast 4 GB RAM and 2 GB available storage space. The system should be completely disconnected from all public networks (internet, tor, wifi etc.). The `offline` wallet host is not required to download or synchronize blockchain data.

The offline wallet should be setup as a server as part of a secured private network where, the wallet is only accessible through a designated rpc connection with `btc-oracle`. 

### 1.2 Installation

Download and install the bitcoin node according to your operating system from the official [Bitcoind Core registry](https://bitcoincore.org/bin/bitcoin-core-27.0/). All programs in this guide are compatible with version `27.0`. 

### 1.3 Configuration
`bitcoind` is a daemon installed with bitcoin node, it can be configured by using a `bitcoin.conf` file. In `Linux` based systems the file is found in `/home/<username>/.bitcoin`. In our docker setup you can make changes in this [`bitcoin.conf`](https://github.com/motif-project/motif-node-docker/blob/btc-docker/btc/data/bitcoin.conf) file and these settings will be reflected in the docker container when the docker container is build. It is suggested that you update `rpcuser` and `rpcpassword`, used for rpc connection. 

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

Update the connection parameters in the [`docker-compose.yml`](https://github.com/motif-project/motif-node-docker/blob/main/docker-compose.yml) file as needed:
```yaml
POSTGRES_USER: user1
POSTGRES_PASSWORD: password1
POSTGRES_DB: databasename
```

Ensure the same parameters are updated in the [`configs/config.json`](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file:
```json
"DB_user": "user1",
"DB_password": "password1",
"DB_name": "databasename"
```

> **Note**: If using PostgreSQL inside a Docker container, do not use `localhost` as the `db_host` in the Motif configuration file. Instead, use the container name (e.g., `postgres_container`).

---

### 3. Motif Configuration

The [`config.json`](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file contains all application settings. Refer to the [config.md](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.md) file to see details on these configurations. 

Make the changes in the [config.json](https://github.com/motif-project/motif-node-docker/blob/main/configs/config.json) file. This file will be used when we create the docker container. 

You need to update the username and password fields for the below
- DB
- Bitcoin Node (In this setup we are running both wallets on the same node. so it should be the same as what you have set in bitcoin.conf file) 
- Multisig Signing Node (In this setup we are running both wallets on the same node. so it should be the same as what you have set in bitcoin.conf file) 
- Eth wallet passphrase

Also ensure that the operator info is updated and the ethereum rpc server and websocket server links (infura, alchemy, etc) are updated.

You can find the latest Motif contract addresses [here](https://github.com/Layr-Labs/eigenlayer-contracts/tree/testnet-holesky?tab=readme-ov-file#current-testnet-deployment), update them in config file if needed.

Please ensure that the system is properly configured before running the docker. 

---

## Key Points to Consider

- **PostgreSQL Volume**: Docker mounts the PostgreSQL database volume to `./psql/data`. Do not replace or move this folder.
- **Ethereum Wallet**: 
  - If no Ethereum wallet is found, a new wallet is created and stored in `./motif/data`. Backup this folder.
  - To use an existing keystore, copy the keystore file to `./motif/data`.
  - To create a new wallet, move the existing keystore file from `./motif/data` to another folder and restart the container.
- **Accessing Localhost**:
  - To Access localhost from within the Docker Container use the following.
  - On macOS/Windows: Use `host.docker.internal` as hostname.
  - On Linux: Run `ip addr show docker0` to find the Docker-assigned IP for the local machine and use that ip as host in docker container.
= **Bitcoin Wallet**:
  - All signet data including wallets is saved in `./btc/data/signet` folder. Do not replace or move this folder, otherwise Docker will start the IBD process again and will create new btc wallets.

---

## Additional Notes

- Ensure all configurations are correctly set before starting the application.
- Backup critical data such as Ethereum keystore files and PostgreSQL volumes.

---
