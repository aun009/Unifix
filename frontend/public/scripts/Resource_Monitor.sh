#!/bin/bash
# Resource Monitor Script
# Description: Advanced system resource monitoring and management

echo "========== Resource Monitor =========="
echo "Running system resource analysis..."

# Function to display formatted section headers
section() {
    echo -e "\n[$1] $2"
    echo "$(printf '=%.0s' {1..40})"
}

# CPU monitoring
section "1/7" "CPU Information and Usage"
echo -e "CPU Model: $(grep "model name" /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^[ \t]*//')"
echo -e "CPU Cores: $(grep -c processor /proc/cpuinfo)"
echo -e "\nCPU Load Averages (1, 5, 15 min):"
uptime | awk '{print $10, $11, $12}'
echo -e "\nCPU Usage by Core:"
mpstat -P ALL 1 1 | awk '/^[0-9]/ {print "Core", $2, ":", 100-$13, "% used"}'

# Memory monitoring
section "2/7" "Memory Information and Usage"
free -h
echo -e "\nTop 5 Memory-Using Processes:"
ps aux --sort=-%mem | head -6 | awk '{print $2, $4 "% memory", $11}'

# Disk monitoring
section "3/7" "Disk Information and Usage"
df -h | grep -v tmp
echo -e "\nDisk I/O Statistics:"
iostat -d -h | grep -v "^$" | tail -n +3

# Network monitoring
section "4/7" "Network Information and Usage"
echo "Network Interfaces:"
ip -br addr show
echo -e "\nCurrent Network Connections:"
ss -tunp | head -10
echo -e "\nNetwork Traffic Summary:"
if command -v vnstat &> /dev/null; then
    vnstat --oneline | sed 's/;/\n/g'
else
    echo "Install vnstat for network traffic statistics: sudo apt install vnstat"
fi

# Process monitoring
section "5/7" "Process Information"
echo "Total number of processes: $(ps aux | wc -l)"
echo -e "\nTop 5 CPU-intensive processes:"
ps aux --sort=-%cpu | head -6 | awk '{print $2, $3 "% CPU", $11}'

# System load
section "6/7" "System Load"
echo "Load average (1, 5, 15 min): $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo "Number of users logged in: $(who | wc -l)"
echo "System uptime: $(uptime -p)"

# Temperature monitoring
section "7/7" "Temperature Monitoring"
if command -v sensors &> /dev/null; then
    sensors | grep °C
else
    echo "Install lm-sensors for temperature info: sudo apt install lm-sensors"
fi

echo -e "\n========== Resource Monitoring Complete =========="
echo "Resource Management Tips:"
echo "1. For high CPU usage: Identify and limit resource-intensive processes."
echo "2. For memory issues: Consider adding more RAM or using swap more efficiently."
echo "3. For disk space issues: Clean up unnecessary files or add more storage."
echo "4. For network bottlenecks: Limit bandwidth-intensive applications."
echo "5. For continuous monitoring: Consider tools like htop, iotop, and nethogs."
echo -e "\nTo get a real-time interactive view, run: htop"