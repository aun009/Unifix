#!/bin/bash
# Clears page cache to free up memory

echo "Clearing page cache..."
sync; echo 3 > /proc/sys/vm/drop_caches

echo "Page cache cleared!"
