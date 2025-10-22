#!/bin/bash
# Update Kernel to Resolve Driver Issues

echo "Updating kernel to resolve driver issues..."

sudo apt update
sudo apt install -y linux-generic
sudo reboot

