#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Software_Backup.sh

echo "========== Software Configuration Backup =========="

BACKUP_DIR="$HOME/software_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Saving list of installed packages..."
dpkg --get-selections > "$BACKUP_DIR/installed_packages.list"

echo "Backing up /etc directory (system-wide configs)..."
sudo tar czf "$BACKUP_DIR/etc_backup.tar.gz" /etc

echo "Backing up user config files from ~/.config..."
cp -r ~/.config "$BACKUP_DIR/"

echo "Backup complete. Files saved in $BACKUP_DIR"