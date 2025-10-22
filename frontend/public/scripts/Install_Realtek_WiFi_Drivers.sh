#!/bin/bash
# Install Realtek Wi-Fi Drivers

echo "Installing Realtek Wi-Fi drivers..."

sudo apt update
sudo apt install -y rtl8812au-dkms
echo "Realtek Wi-Fi driver installation complete!"

