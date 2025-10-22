#!/bin/bash
# Check and Fix USB Driver Issues

echo "Checking and fixing USB driver issues..."

sudo apt update
sudo apt install -y usbutils
sudo modprobe -r usb_storage
sudo modprobe usb_storage
echo "USB driver issues fixed!"

