#!/bin/bash
# Configures HugePages for better memory management

echo "Setting up HugePages..."

sysctl -w vm.nr_hugepages=1024

echo "HugePages configuration complete!"
