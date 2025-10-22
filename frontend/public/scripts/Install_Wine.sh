#!/bin/bash
# Install Wine

echo "Installing Wine..."

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32

echo "Wine installation complete!"

