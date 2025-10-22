#!/bin/bash
set -e
# Blockchain Explorer Setup

echo "Installing blockchain explorer dependencies..."
sudo apt install -y nodejs npm

echo "Cloning and setting up block explorer..."
git clone https://github.com/ethereum/blockchain-explorer.git
cd blockchain-explorer
npm install
npm start

