#!/bin/bash
# Reinstall Ethernet Drivers

echo "Reinstalling Ethernet drivers..."

sudo apt update
sudo apt remove --purge -y r8169
sudo apt install -y r8168-dkms
echo "Ethernet driver reinstallation complete!"

