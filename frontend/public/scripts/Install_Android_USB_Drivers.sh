#!/bin/bash
# Install Android USB Drivers

echo "Installing Android USB drivers..."

sudo apt update
sudo apt install -y android-tools-adb android-tools-fastboot
echo "Android USB drivers installation complete!"

