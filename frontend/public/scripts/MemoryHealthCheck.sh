#!/bin/bash
# Performs a health check on system memory

echo "Memory health check in progress..."

memtest86+ > /var/log/memtest.log

echo "Memory health check complete. See /var/log/memtest.log for details."
