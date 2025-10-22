#!/bin/bash
# Displays detailed memory information

echo "Memory info:"
free -h
echo "Top memory-consuming processes:"
ps aux --sort=-%mem | head -n 10
