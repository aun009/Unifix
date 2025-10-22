#!/bin/bash
set -e
# Ethereum Node Setup

echo "Installing dependencies for Ethereum Node..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt update
sudo apt install -y ethereum

echo "Starting Ethereum Node..."
geth --datadir /var/lib/ethereum init /etc/ethereum/genesis.json
geth --datadir /var/lib/ethereum --networkid 1 console

