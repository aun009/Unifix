#!/bin/bash
# filepath: frontend/public/scripts/Network_Optimization.sh

echo "Optimizing network performance..."

sudo sysctl -w net.core.somaxconn=4096
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=4096
echo "Network optimization applied."