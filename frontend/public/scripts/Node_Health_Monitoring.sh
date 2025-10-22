#!/bin/bash
set -e
# Node Health Monitoring

echo "Monitoring Ethereum node health..."
# Check if the Ethereum node is syncing and running smoothly
geth attach ipc:/var/lib/ethereum/geth.ipc console
