#!/bin/bash
# filepath: frontend/public/scripts/Network_Monitoring.sh

echo "Network monitoring..."

if command -v iftop &> /dev/null; then
  sudo iftop
else
  echo "Install iftop for live network monitoring: sudo apt install iftop"
fi