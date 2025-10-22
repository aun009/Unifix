#!/bin/bash
# Install NVIDIA Driver (for Optimus laptops)

echo "Installing NVIDIA Optimus driver..."

sudo apt update
sudo apt install -y nvidia-prime
echo "NVIDIA Optimus driver installation complete!"

