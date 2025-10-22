#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Package_Management.sh

echo "========== Advanced Package Management =========="

echo "Updating package lists..."
sudo apt update

echo "Listing upgradable packages..."
apt list --upgradable

echo "Checking for broken dependencies..."
sudo apt --fix-broken install

echo "Cleaning up unused packages and cache..."
sudo apt autoremove -y
sudo apt autoclean

echo "Searching for a package (example: curl)..."
read -p "Enter package name to search: " pkg
apt-cache search "$pkg"

echo "To install a package, run: sudo apt install <package-name>"
echo "To remove a package, run: sudo apt remove <package-name>"

echo "Package management tasks complete."