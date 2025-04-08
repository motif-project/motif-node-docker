#!/bin/bash

# Define wallet names as variables
WALLET_ONLINE="motifOnline"
WALLET_OFFLINE="motifOffline"

# Start Bitcoin daemon in the background
bitcoind --daemon

# Wait for 3 minutes (180 seconds) to allow the Bitcoin daemon to initialize
echo "Waiting for 3 minutes to allow Bitcoin daemon to initialize..."
sleep 180

# Check if the online wallet exists, and create it if it doesn't
if ! bitcoin-cli loadwallet "$WALLET_ONLINE" | grep -q "verification failed"; then
    echo "Creating wallet: $WALLET_ONLINE"
    bitcoin-cli createwallet "$WALLET_ONLINE" false false "" false true
fi

# Check if the offline wallet exists, and create it if it doesn't
if ! bitcoin-cli loadwallet "$WALLET_OFFLINE" | grep -q "verification failed"; then
    echo "Creating wallet: $WALLET_OFFLINE"
    bitcoin-cli createwallet "$WALLET_OFFLINE"
fi

# List descriptors for the online wallet
bitcoin-cli --rpcwallet="$WALLET_ONLINE" listdescriptors

# Keep the container running
tail -f /dev/null