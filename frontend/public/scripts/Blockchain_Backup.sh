#!/bin/bash
set -e
# Blockchain Backup

echo "Backing up Ethereum blockchain data..."
tar -czvf /backup/ethereum_data_$(date +%F).tar.gz /var/lib/ethereum

