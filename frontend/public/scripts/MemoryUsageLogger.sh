#!/bin/bash
# Logs memory usage over time

echo "Logging memory usage..."

while true; do
    free -h >> /var/log/memory_usage.log
    sleep 60
done
