#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Secure_Boot_Integration.sh

echo "========== Secure Boot Integration =========="

# Check Secure Boot status
if mokutil --sb-state 2>/dev/null | grep -q enabled; then
  echo "Secure Boot is enabled."
else
  echo "Secure Boot is not enabled."
fi

# List unsigned kernel modules (requires root)
echo "Checking for unsigned kernel modules..."
if command -v kmodsign &>/dev/null; then
  for mod in $(lsmod | awk 'NR>1 {print $1}'); do
    modinfo $mod 2>/dev/null | grep -q 'signer:' || echo "Unsigned module: $mod"
  done
else
  echo "kmodsign not found. Skipping module signature check."
fi

echo "Secure Boot integration check complete."