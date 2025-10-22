#!/bin/bash
# Install ALSA Audio Drivers

echo "Installing ALSA audio drivers..."

sudo apt update
sudo apt install -y alsa-base alsa-utils
sudo alsa force-reload
echo "ALSA audio drivers installation complete!"

