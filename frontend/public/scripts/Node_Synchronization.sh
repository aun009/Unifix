#!/bin/bash
set -e
# Node Synchronization

echo "Starting Ethereum node synchronization..."
geth --datadir /var/lib/ethereum --syncmode "fast" --cache 1024 console

