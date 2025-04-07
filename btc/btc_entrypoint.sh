#!/bin/bash
bitcoind --daemon
echo "Waiting for 3 minutes to allow Bitcoin daemon to initialize..."
sleep 60
if ! bitcoin-cli loadwallet motifOnline | grep -q "verification failed"; then
    echo "Creating wallet: motifOnline"
    bitcoin-cli createwallet motifOnline false false "" false true
fi

# Check if the 'motifOffline' wallet exists, and create it if it doesn't
if ! bitcoin-cli loadwallet motifOffline | grep -q "verification failed"; then
    echo "Creating wallet: motifOffline"
    bitcoin-cli createwallet motifOffline
fi

bitcoin-cli --rpcwallet=motifOnline listdescriptors
tail -f /dev/null