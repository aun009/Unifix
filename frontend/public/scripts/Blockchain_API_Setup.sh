#!/bin/bash
set -e
# Blockchain API Setup

echo "Setting up API to interact with Ethereum..."
npm install -g express web3

echo "Creating API to fetch blockchain data..."
cat <<'EOL' > blockchain_api.js
const express = require('express');
const Web3 = require('web3');
const app = express();
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');

app.get('/block/:blockNumber', async (req, res) => {
  const block = await web3.eth.getBlock(req.params.blockNumber);
  res.json(block);
});

app.listen(3000, () => {
  console.log('Blockchain API server running on port 3000');
});
EOL

echo "Run the API with Node.js..."
node blockchain_api.js

