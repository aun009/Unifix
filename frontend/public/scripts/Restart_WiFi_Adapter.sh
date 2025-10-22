#!/bin/bash
# Restart Network Adapter (Wi-Fi)

echo "Restarting Wi-Fi adapter..."

nmcli radio wifi off
sleep 2
nmcli radio wifi on

echo "Wi-Fi adapter restarted successfully!"

