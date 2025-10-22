#!/bin/bash
# Enables and configures swap memory

echo "Creating swap file..."
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "Swap enabled and configured!"
