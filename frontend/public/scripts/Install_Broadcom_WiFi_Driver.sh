#!/bin/bash
# Install Broadcom Wi-Fi Driver

echo "Installing Broadcom Wi-Fi drivers..."

sudo apt update
sudo apt install -y bcmwl-kernel-source
echo "Broadcom Wi-Fi driver installation complete!"

