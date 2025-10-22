#!/bin/bash
# Tests system memory for stability under load

echo "Running memory stress test..."

stress --vm 2 --vm-bytes 1G --timeout 60s

echo "Memory stress test complete."
