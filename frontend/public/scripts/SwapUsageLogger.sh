#!/bin/bash
# Logs swap usage over time

echo "Logging swap usage..."

while true; do
    swapon --show >> /var/log/swap_usage.log
    sleep 60
done
