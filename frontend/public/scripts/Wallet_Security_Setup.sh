#!/bin/bash
set -e
# Wallet Security Setup

echo "Setting up secure wallet management..."
sudo apt install -y gnupg2

echo "Creating and securing wallet keys..."
gpg --gen-key
gpg --armor --export-secret-keys > wallet_private_keys.asc
gpg --armor --export public-keys > wallet_public_keys.asc

echo "Backup your keys securely."
