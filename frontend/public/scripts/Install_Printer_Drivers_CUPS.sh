#!/bin/bash
# Install Printer Drivers using CUPS

echo "Installing printer drivers using CUPS..."

sudo apt update
sudo apt install -y cups
sudo systemctl start cups
sudo systemctl enable cups
echo "Printer drivers installation complete!"

