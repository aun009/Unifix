#!/bin/bash
# Install AMD Graphics Driver

echo "Installing the latest AMD graphics driver..."

sudo apt update
sudo apt install -y amdgpu-pro
echo "AMD graphics driver installation complete!"

