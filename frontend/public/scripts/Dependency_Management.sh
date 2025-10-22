#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Dependency_Management.sh

echo "========== Dependency Management =========="

echo "Checking for broken dependencies..."
sudo apt --fix-broken install

echo "Listing manually installed packages:"
apt-mark showmanual

echo "Checking for missing dependencies in a package (example: python3)..."
read -p "Enter package name to check dependencies: " pkg
apt-cache depends "$pkg"

echo "To install missing dependencies, run: sudo apt install -f"
echo "Dependency management tasks complete."