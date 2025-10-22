#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Software_Updates.sh

echo "========== Automated Software Updates =========="

echo "Updating package lists..."
sudo apt update

echo "Upgrading all installed packages..."
sudo apt upgrade -y

echo "Performing distribution upgrade (if needed)..."
sudo apt dist-upgrade -y

echo "Cleaning up unused packages..."
sudo apt autoremove -y
sudo apt autoclean

echo "Software update complete."