#!/bin/bash
set -e
# Smart Contract Deployment

echo "Installing dependencies for Smart Contract Deployment..."
sudo apt update
sudo apt install -y npm solc

echo "Installing Truffle framework..."
npm install -g truffle

echo "Deploying smart contract..."
truffle init
# Write your contract in ./contracts/MyContract.sol
truffle migrate --network development

