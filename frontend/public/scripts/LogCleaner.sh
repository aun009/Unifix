#!/bin/bash
# Cleans up old log files

echo "Cleaning up logs in /var/log..."

find /var/log -name "*.log" -type f -mtime +30 -exec rm -f {} \;

echo "Old log files cleaned up!"
