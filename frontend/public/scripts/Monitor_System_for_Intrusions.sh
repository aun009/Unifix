#!/bin/bash
# Monitor System for Intrusions

echo "Monitoring system for intrusions..."

sudo apt install -y auditd
sudo auditctl -w /etc/passwd -p wa

echo "System intrusion monitoring started!"

