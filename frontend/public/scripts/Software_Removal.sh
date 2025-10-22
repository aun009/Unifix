#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Software_Removal.sh

echo "========== Software Removal and Cleanup =========="

read -p "Enter the name of the software to remove: " software

echo "Removing $software..."
sudo apt remove --purge -y "$software"

echo "Cleaning up unused dependencies..."
sudo apt autoremove -y
sudo apt autoclean

echo "Checking for leftover configuration files..."
dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo apt purge -y

echo "Software removal complete."