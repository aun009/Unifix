#!/bin/bash
# System Health Check Script
# Description: Comprehensive system health check and diagnostics

echo "========== System Health Check =========="
echo "Starting comprehensive system health check..."

# Basic system information
echo -e "\n[1/9] System Information:"
echo "-------------------------------"
uname -a
echo -e "\nUptime: $(uptime -p)"
echo -e "\nLast boot: $(who -b | awk '{print $3, $4}')"

# CPU check
echo -e "\n[2/9] CPU Health:"
echo "-------------------"
echo -e "CPU model: $(grep "model name" /proc/cpuinfo | head -1 | cut -d ":" -f2 | sed 's/^[ \t]*//')"
echo -e "CPU cores: $(grep -c processor /proc/cpuinfo)"
echo -e "CPU load averages: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo -e "CPU temperature:"
if command -v sensors &> /dev/null; then
    sensors | grep °C
else
    echo "Install lm-sensors for temperature info: sudo apt install lm-sensors"
fi

# Memory check
echo -e "\n[3/9] Memory Health:"
echo "----------------------"
free -h

# Disk health
echo -e "\n[4/9] Disk Health:"
echo "-------------------"
df -h
echo -e "\nSMART status:"
if command -v smartctl &> /dev/null; then
    for disk in $(lsblk -d -o name | grep -v "loop" | grep -v "NAME"); do
        echo -e "\nDisk /dev/$disk:"
        sudo smartctl -H /dev/$disk 2>/dev/null || echo "Cannot get SMART status for /dev/$disk"
    done
else
    echo "Install smartmontools for disk health info: sudo apt install smartmontools"
fi

# Network health
echo -e "\n[5/9] Network Health:"
echo "----------------------"
ip addr show | grep -E "inet |inet6 "
echo -e "\nNetwork connectivity:"
ping -c 3 8.8.8.8 || echo "No internet connection"

# Service status
echo -e "\n[6/9] Important Services Status:"
echo "--------------------------------"
for service in ssh apache2 nginx mysql postgresql docker; do
    systemctl is-active --quiet $service && echo "$service: active" || echo "$service: inactive or not installed"
done

# Security check
echo -e "\n[7/9] Security Check:"
echo "---------------------"
echo "Last 5 failed login attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5 || echo "No failed logins found or log not accessible"

echo -e "\nListening network ports:"
ss -tulpn | grep LISTEN

# Update status
echo -e "\n[8/9] Update Status:"
echo "-------------------"
if command -v apt &> /dev/null; then
    apt-get -s upgrade | grep -i upgraded | cut -d" " -f1
fi

# System logs
echo -e "\n[9/9] Recent System Errors:"
echo "---------------------------"
journalctl -p err..emerg --since "24 hours ago" | tail -n 10 || echo "No recent system errors found or journalctl not available"

echo -e "\n========== System Health Check Complete =========="
echo "Overall system health summary:"
echo "1. Check CPU load and temperatures for any overheating issues."
echo "2. Ensure disk usage is below 80% on all partitions."
echo "3. Verify all critical services are running properly."
echo "4. Address any security concerns like failed login attempts."
echo "5. Apply pending system updates to improve security and stability."