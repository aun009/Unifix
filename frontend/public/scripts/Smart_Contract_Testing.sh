#!/bin/bash
set -e
# Smart Contract Testing

echo "Installing dependencies for smart contract testing..."
sudo apt install -y npm
npm install -g mocha truffle

echo "Running tests on smart contract..."
truffle test

