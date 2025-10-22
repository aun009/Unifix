#!/bin/bash
# Install VirtualBox Drivers

echo "Installing VirtualBox drivers..."

sudo apt update
sudo apt install -y virtualbox
sudo apt install -y virtualbox-ext-pack
echo "VirtualBox drivers installation complete!"

