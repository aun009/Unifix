#!/bin/bash
# Clears system cache

echo "Clearing page cache..."
sync; echo 3 > /proc/sys/vm/drop_caches

echo "System cache cleared!"
