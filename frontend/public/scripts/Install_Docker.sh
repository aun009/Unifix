#!/bin/bash
# Install Docker

echo "Installing Docker..."

sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker installation complete!"

