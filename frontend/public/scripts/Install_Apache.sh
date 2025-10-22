#!/bin/bash
# Install Apache Web Server

echo "Installing Apache Web Server..."

sudo apt update
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

echo "Apache Web Server installation complete!"

