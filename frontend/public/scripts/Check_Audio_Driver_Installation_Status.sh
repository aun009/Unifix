#!/bin/bash
# Check Audio Driver Installation Status

echo "Checking audio driver status..."

if lsmod | grep -i snd_hda_intel > /dev/null; then
    echo "Audio drivers are installed and active."
else
    echo "Audio drivers are not active. Installing or troubleshooting may be required."
fi

