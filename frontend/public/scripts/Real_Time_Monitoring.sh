#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Real_Time_Monitoring.sh

echo "========== Real-time System Monitoring =========="

# Simple real-time monitoring loop with alerting

THRESHOLD_CPU=80
THRESHOLD_MEM=90

while true; do
  CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
  MEM=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100.0}')

  echo "CPU Usage: $CPU% | Memory Usage: $MEM%"

  if (( $(echo "$CPU > $THRESHOLD_CPU" | bc -l) )); then
    echo "ALERT: High CPU usage detected!"
  fi

  if (( MEM > THRESHOLD_MEM )); then
    echo "ALERT: High memory usage detected!"
  fi

  sleep 5
done