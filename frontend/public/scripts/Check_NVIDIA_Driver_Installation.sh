#!/bin/bash
# Check if NVIDIA Driver is installed

echo "Checking for NVIDIA driver..."

if lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA driver is installed."
else
    echo "NVIDIA driver is not installed. Installing..."
    sudo apt update
    sudo apt install nvidia-driver-460
    echo "NVIDIA driver installation complete!"
fi

