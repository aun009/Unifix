#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/LabCleanup.sh

echo "========== Lab Cleanup Script =========="

# 1. Delete files not accessed in the last 1 year in user home directories
echo "Cleaning up files not accessed in the last 1 year in /home..."
find /home -type f -atime +365 -print -delete

# 2. Clean up /tmp and /var/tmp
echo "Cleaning up files not accessed in the last 1 year in /tmp and /var/tmp..."
find /tmp /var/tmp -type f -atime +365 -print -delete

# 3. Clean up old log files in /var/log
echo "Cleaning up log files not modified in the last 1 year in /var/log..."
find /var/log -type f -name "*.log" -mtime +365 -print -delete

# 4. Remove unused Docker images, containers, and volumes
if command -v docker &>/dev/null; then
  echo "Cleaning up unused Docker resources..."
  docker system prune -af --volumes
else
  echo "Docker not found, skipping Docker cleanup."
fi

echo "Cleanup complete!"