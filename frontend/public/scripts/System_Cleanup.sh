#!/bin/bash
# System Cleanup Script
# Description: Automated system cleanup and optimization

echo "========== System Cleanup Tool =========="
echo "Starting system cleanup process..."

# Calculate initial disk usage
echo -e "\n[1/7] Initial disk usage:"
df -h /

# Clean apt cache
echo -e "\n[2/7] Cleaning package manager cache..."
if command -v apt &> /dev/null; then
    sudo apt clean
    sudo apt autoremove -y
fi

# Clean user cache
echo -e "\n[3/7] Cleaning user cache..."
rm -rf ~/.cache/* 2>/dev/null

# Clean temporary files
echo -e "\n[4/7] Cleaning temporary files..."
sudo rm -rf /tmp/* 2>/dev/null

# Clean thumbnail cache
echo -e "\n[5/7] Cleaning thumbnail cache..."
rm -rf ~/.thumbnails/* 2>/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null

# Clean old log files
echo -e "\n[6/7] Cleaning old log files..."
sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null
sudo find /var/log -type f -name "*.old" -delete 2>/dev/null
sudo find /var/log -type f -name "*.1" -delete 2>/dev/null

# Calculate final disk usage
echo -e "\n[7/7] Final disk usage:"
df -h /

echo -e "\n========== System Cleanup Complete =========="
echo -e "\nAdditional cleanup options:"
echo "1. Use 'journalctl --vacuum-time=1d' to clean up systemd logs."
echo "2. Use 'docker system prune' to clean up unused Docker resources."
echo "3. Use 'flatpak uninstall --unused' to remove unused Flatpak runtimes."