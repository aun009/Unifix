#!/bin/bash
# Reinstall Docker

echo "Reinstalling Docker..."

sudo apt remove --purge -y docker.io
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker reinstallation complete!"

