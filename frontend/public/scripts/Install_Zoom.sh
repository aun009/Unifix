#!/bin/bash
# Install Zoom

echo "Installing Zoom..."

wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install -y ./zoom_amd64.deb

echo "Zoom installation complete!"

