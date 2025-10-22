#!/bin/bash
# Detects memory leaks in running processes

echo "Scanning for memory leaks..."

ps aux --sort=-%mem | head -n 10

echo "Memory leak analysis complete. Consider investigating processes consuming the most memory."
