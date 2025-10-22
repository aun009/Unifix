#!/bin/bash
# Uninstall Docker

echo "Uninstalling Docker..."

sudo apt remove --purge -y docker.io
sudo apt autoremove -y

echo "Docker has been uninstalled successfully!"

