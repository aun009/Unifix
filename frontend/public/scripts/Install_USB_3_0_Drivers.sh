#!/bin/bash
# Install USB 3.0 Drivers

echo "Installing USB 3.0 drivers..."

sudo apt update
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -y xhci-hcd
echo "USB 3.0 drivers installation complete!"

