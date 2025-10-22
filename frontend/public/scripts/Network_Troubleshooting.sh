#!/bin/bash
# Network Troubleshooting Script
# Description: Advanced network troubleshooting and diagnostics

echo "========== Network Troubleshooting Tool =========="
echo "Running network diagnostics..."

echo -e "\n[1/7] Checking network interfaces..."
ip addr show

echo -e "\n[2/7] Checking default gateway..."
ip route | grep default

echo -e "\n[3/7] Checking DNS settings..."
cat /etc/resolv.conf

echo -e "\n[4/7] Testing internet connectivity..."
ping -c 4 8.8.8.8

echo -e "\n[5/7] Testing DNS resolution..."
nslookup google.com

echo -e "\n[6/7] Checking open ports and active connections..."
ss -tuln

echo -e "\n[7/7] Network latency test..."
mtr -n -c 5 google.com

echo -e "\n========== Network Diagnostics Complete =========="
echo "Troubleshooting suggestions:"
echo "1. If ping failed, check physical connection and router status."
echo "2. If DNS resolution failed, verify DNS server settings."
echo "3. For high latency, investigate potential network congestion or routing issues."
echo "4. For connectivity issues, verify firewall settings are not blocking necessary traffic."