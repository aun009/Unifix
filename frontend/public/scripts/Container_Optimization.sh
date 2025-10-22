#!/bin/bash
# filepath: frontend/public/scripts/Container_Optimization.sh

echo "Optimizing Docker containers..."

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Size}}"
echo "Consider restarting containers with high resource usage."
echo "Run 'docker stats' for live resource monitoring."