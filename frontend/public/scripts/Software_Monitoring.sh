#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Software_Monitoring.sh

echo "========== Software Performance Monitoring =========="

echo "Listing top resource-consuming processes:"
ps aux --sort=-%mem | head -n 10

echo "Monitoring disk usage:"
df -h

echo "Monitoring running services:"
systemctl list-units --type=service --state=running

echo "Monitoring software logs (example: syslog):"
sudo tail -n 20 /var/log/syslog

echo "To monitor a specific process, use: top -p <PID> or htop"
echo "Software monitoring tasks complete."