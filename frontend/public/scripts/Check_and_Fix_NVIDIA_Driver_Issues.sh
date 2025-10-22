#!/bin/bash
# Check and Fix NVIDIA Driver Issues

echo "Checking for NVIDIA driver issues..."

if nvidia-smi > /dev/null; then
    echo "NVIDIA driver is working correctly."
else
    echo "NVIDIA driver issue detected. Attempting to reinstall..."
    sudo apt update
    sudo apt install --reinstall nvidia-driver-460
    echo "NVIDIA driver reinstallation complete!"
fi

