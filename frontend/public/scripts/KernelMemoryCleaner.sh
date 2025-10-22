#!/bin/bash
# Cleans up unused kernel memory

echo "Clearing kernel memory..."

sync; echo 1 > /proc/sys/vm/drop_caches

echo "Kernel memory cleaned!"
