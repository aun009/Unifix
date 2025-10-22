#!/bin/bash
# Flush DNS Cache

echo "Flushing DNS cache..."

sudo systemctl restart systemd-resolved
sudo resolvectl flush-caches

echo "DNS cache flushed successfully!"

