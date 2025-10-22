#!/bin/bash
# Check Graphics Driver Installation

echo "Checking graphics driver..."

if lspci | grep -i vga > /dev/null; then
    echo "Graphics driver is installed."
else
    echo "Graphics driver is not installed. Installing..."
    sudo apt install -y xserver-xorg-video-intel
    echo "Graphics driver installation complete!"
fi

