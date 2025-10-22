#!/bin/bash
# Install NVIDIA Optimus Driver (for Hybrid Graphics)

echo "Installing NVIDIA Hybrid Graphics driver..."

sudo apt update
sudo apt install -y nvidia-prime
echo "NVIDIA Hybrid Graphics driver installation complete!"

