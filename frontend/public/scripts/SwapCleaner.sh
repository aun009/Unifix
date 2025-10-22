#!/bin/bash
# Clears swap memory

echo "Turning off swap..."
swapoff -a

echo "Turning swap back on..."
swapon -a

echo "Swap cleared and re-enabled!"
