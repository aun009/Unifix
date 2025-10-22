#!/bin/bash
# Install Bluetooth Drivers

echo "Installing Bluetooth drivers..."

sudo apt update
sudo apt install -y bluez bluez-tools
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
echo "Bluetooth drivers installation complete!"

