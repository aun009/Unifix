#!/bin/bash
# Install Nginx Web Server

echo "Installing Nginx Web Server..."

sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Nginx installation complete!"

