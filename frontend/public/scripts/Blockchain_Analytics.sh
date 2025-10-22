#!/bin/bash
set -e
# Blockchain Analytics

echo "Installing blockchain analytics tools..."
sudo apt install -y python3-pip
pip3 install web3 pandas matplotlib

echo "Running analytics script..."
cat <<'EOL' > blockchain_analytics.py
from web3 import Web3
import matplotlib.pyplot as plt
import pandas as pd

web3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))

def get_block_data(block_number):
    block = web3.eth.getBlock(block_number)
    return block['gasUsed'], block['gasLimit']

gas_used = []
gas_limit = []

for block_number in range(1, 100):  # Example: Get data for blocks 1 to 100
    used, limit = get_block_data(block_number)
    gas_used.append(used)
    gas_limit.append(limit)

df = pd.DataFrame({'Block': range(1, 100), 'Gas Used': gas_used, 'Gas Limit': gas_limit})

df.plot(x='Block', y=['Gas Used', 'Gas Limit'], kind='line')
plt.show()
EOL

python3 blockchain_analytics.py
