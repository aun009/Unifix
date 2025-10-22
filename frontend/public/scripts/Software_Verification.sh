#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Software_Verification.sh

echo "========== Software Integrity Verification =========="

read -p "Enter package name to verify: " pkg

echo "Checking installed files for $pkg..."
dpkg -L "$pkg"

echo "Verifying package integrity..."
sudo debsums "$pkg" 2>/dev/null || echo "debsums not available or package not found."

echo "Checking for known vulnerabilities..."
if command -v apt-get &>/dev/null; then
  sudo apt update
  sudo apt list --upgradable | grep "$pkg"
fi

echo "Software verification complete."