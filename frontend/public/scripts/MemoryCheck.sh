#!/bin/bash
# Memory usage check and report

echo "Memory usage report:"
free -h

echo "Top 10 memory-consuming processes:"
ps aux --sort=-%mem | head -n 10
