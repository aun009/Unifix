#!/bin/bash
# Install OpenCL Drivers for AMD

echo "Installing OpenCL drivers for AMD..."

sudo apt update
sudo apt install -y opencl-headers amd-opencl-icd
echo "OpenCL drivers installation complete!"

