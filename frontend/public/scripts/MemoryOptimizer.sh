#!/bin/bash
# Optimizes memory usage by adjusting system parameters

echo "Adjusting vm.swappiness..."
sysctl -w vm.swappiness=10

echo "Adjusting vm.vfs_cache_pressure..."
sysctl -w vm.vfs_cache_pressure=50

echo "Memory optimization complete!"
