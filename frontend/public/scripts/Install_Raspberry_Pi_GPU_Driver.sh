#!/bin/bash
# Install Raspberry Pi GPU Driver

echo "Installing Raspberry Pi GPU driver..."

sudo apt update
sudo apt install -y raspberrypi-bootloader
echo "Raspberry Pi GPU driver installation complete!"

