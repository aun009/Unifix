#!/bin/bash
# Reset Network Settings

echo "Resetting network settings..."

sudo systemctl stop NetworkManager
sudo rm -rf /etc/NetworkManager/system-connections/*
sudo systemctl start NetworkManager

echo "Network settings have been reset!"

