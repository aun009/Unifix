#!/bin/bash
# Check System Logs for Suspicious Activity

echo "Checking system logs for suspicious activity..."

sudo grep -i "failed" /var/log/auth.log

echo "System logs checked for suspicious activity!"

