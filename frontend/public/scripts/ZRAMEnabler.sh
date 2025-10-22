#!/bin/bash
# Enables ZRAM for better memory compression

echo "Setting up ZRAM..."

modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo 4G > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0

echo "ZRAM enabled!"
