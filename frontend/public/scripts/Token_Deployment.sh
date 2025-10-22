#!/bin/bash
set -e
# Token Deployment

echo "Deploying ERC-20 Token..."
# Assuming an ERC-20 smart contract is ready in ./contracts/ERC20Token.sol
truffle migrate --network development
