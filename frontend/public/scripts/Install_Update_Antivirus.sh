#!/bin/bash
# Install and Update Antivirus Software

echo "Installing and updating antivirus software..."

sudo apt install -y clamav
sudo freshclam

echo "Antivirus software installed and updated!"

