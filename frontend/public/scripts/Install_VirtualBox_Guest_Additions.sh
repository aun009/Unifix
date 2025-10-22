#!/bin/bash
# Install VirtualBox Guest Additions

echo "Installing VirtualBox Guest Additions..."

sudo apt update
sudo apt install -y virtualbox-guest-utils
echo "VirtualBox Guest Additions installation complete!"

