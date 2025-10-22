#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Automatic_Performance_Tuning.sh

echo "========== Automatic Performance Tuning =========="

# Monitor CPU and memory usage, and tune swappiness and cache pressure adaptively

CPU_LOAD=$(awk '{print $1}' <(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1))
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
SWAPPINESS=$(cat /proc/sys/vm/swappiness)
CACHE_PRESSURE=$(cat /proc/sys/vm/vfs_cache_pressure)

echo "Current CPU Load: $CPU_LOAD"
echo "Free Memory: $MEM_FREE MB"
echo "Swappiness: $SWAPPINESS"
echo "Cache Pressure: $CACHE_PRESSURE"

# Adaptive tuning logic
if (( $(echo "$CPU_LOAD > 2.0" | bc -l) )); then
  echo "High CPU load detected. Lowering swappiness and cache pressure."
  sudo sysctl -w vm.swappiness=10
  sudo sysctl -w vm.vfs_cache_pressure=50
elif (( MEM_FREE < 500 )); then
  echo "Low memory detected. Increasing swappiness and cache pressure."
  sudo sysctl -w vm.swappiness=80
  sudo sysctl -w vm.vfs_cache_pressure=200
else
  echo "System performance is optimal. No tuning required."
fi

echo "Performance tuning complete."