#!/bin/bash
# Analyzes OOM killer logs

echo "Searching for OOM killer logs..."
grep -i 'killed process' /var/log/syslog

echo "OOM killer log analysis complete."
