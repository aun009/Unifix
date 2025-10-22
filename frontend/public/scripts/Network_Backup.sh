#!/bin/bash
# filepath: frontend/public/scripts/Network_Backup.sh

echo "Backing up network configuration..."

sudo cp /etc/network/interfaces ./interfaces.backup 2>/dev/null
sudo cp /etc/netplan/*.yaml ./netplan_backup/ 2>/dev/null
echo "Backup complete."