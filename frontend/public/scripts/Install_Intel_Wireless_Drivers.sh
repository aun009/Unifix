#!/bin/bash
# Install Intel Wireless Drivers

echo "Installing Intel wireless drivers..."

sudo apt update
sudo apt install -y firmware-iwlwifi
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi
echo "Intel wireless drivers installation complete!"

