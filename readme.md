# Motif Deployment Guide

This guide provides instructions on how to deploy the Motif application using Docker and Docker Compose.

## Prerequisites

Before you begin, ensure you have the following tasks are done:

- Install Docker
- Install Docker Compose
- Access to full bitcoin Node with tx indexing enabled
- Access to a stand alone (not connected to the BTC chain) BTC Node with only the BTC wallet running

## Configuration

1. ### Database Configuration

   Update the connection parameters in the Docker-compose.yml as needed.
    ```yaml
        POSTGRES_USER: user1
        POSTGRES_PASSWORD: password1
        POSTGRES_DB: databasename
    ```

    Also ensure that you update the configs/config.json file with the same parameters.

    ```json
        "DB_user": "user1",
        "DB_password" : "password1",
        "DB_name" : "databasename",
    ``` 


2. ### Application Configuration

   The `config.json` file contains the configuration settings for the application. Ensure that the database connection details and other settings are correctly specified. 

   #### General Configuration

    - **env**: Specifies the environment in which the application is running. acceptable values are `dev`, `prod`.

    #### Database Configuration

    - **DB_port**: The port number on which the PostgreSQL database is running.
    - **DB_host**: The hostname or IP address of the PostgreSQL database. In this case, it is set to `postgres_container`, which is the name of the PostgreSQL service in the Docker Compose setup.
    - **DB_user**: The username for connecting to the PostgreSQL database.
    - **DB_password**: The password for the PostgreSQL user.
    - **DB_name**: The name of the PostgreSQL database.

    #### Bitcoin Node Configuration

    - **btc_node_host**: The hostname or IP address and port of the Bitcoin node.
    - **btc_node_user**: The username for authenticating with the Bitcoin node.
    - **btc_node_pass**: The password for the Bitcoin node user.
    - **btc_node_protocol**: The protocol used to connect to the Bitcoin node. Here, it is `http://`.
    - **fee_rate_adjustment**: A parameter to adjust the fee rate for Bitcoin transactions, Incase we want to prioritize tx.
    - **wallet_name**: The name of the Bitcoin online wallet used by the application. which is connected to the Btc Chain
    - **btc_xpublic_key**: The extended public key for the Bitcoin wallet. This key is used to derive addresses for receiving Bitcoin.

    #### Multisig Wallet Configuration

    - **multisig_signing_wallet_name**: The name of the multisig offline signing wallet. 
    - **multisig_btc_node**: The hostname or IP address and port of the Bitcoin node used for multisig offline transaction signing. 
    - **multisig_btc_user**: The username for authenticating with the Bitcoin node used for multisig offline transaction signing. 
    - **multisig_btc_pass**: The password for the Bitcoin node user used for  multisig offline transaction signing. 
    - **multisig_btc_protocol**: The protocol used to connect to the Bitcoin node for  multisig offline transaction signing. Here, it is `http://`.

    #### Ethereum Configuration

    - **eth_rpc_host**: The RPC endpoint for connecting to the Ethereum network.
    - **eth_ws_host**: The WebSocket endpoint for connecting to the Ethereum network. 
    - **eth_keystore_dir**: The directory where the Ethereum keystore files are stored. 
    - **eth_keystore_passphrase**: The passphrase for the Ethereum keystore.

    #### Smart Contract Addresses

    - **opr_metadata_uri**: The URI for operator metadata.
    - **eigen_delegation_manager_address**: The Ethereum address of the Eigen Delegation Manager contract.
    - **motif_registry_address**: The Ethereum address of the Motif Registry contract. 
    - **service_manager_address**: The Ethereum address of the Service Manager contract. 
    - **eigen_avs_directory_address**: The Ethereum address of the Eigen AVS Directory 
    - **pod_manager_address**: The Ethereum address of the Pod Manager contract.

## KeyPoints to Consider

- When Docker is initialized it mounts postgres db volume to `./psql/data` folder on your local machine. This folder should not be replaced or moved. 

- When Docker is initialized it look for an Eth wallet. If not found, a new  Eth Wallet is created and is stored at `.motif/data` folder on the local machine. Please keep a backup of this folder. If you already have a keystore you want to use, copy the keystore file at the same location `./motif/data`

- In case you want to create a new wallet, simply move the keystore file from `./motif/data`on local machine to another folder. this will create a new wallet upon restarting the docker container.

## Running

- Run the below command to start the docker

```shell
    docker-compose up
```

- In case you are starting the system with a new Eth wallet. You will see an Eth Account printed on the terminal and the system will halt with an error stating `insufficient funds`. simply add some funds in the shared address and run the above command again.


