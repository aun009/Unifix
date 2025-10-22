#!/bin/bash
# filepath: frontend/public/scripts/Volume_Management.sh

echo "Docker volume management..."

docker volume ls
echo "Pruning unused volumes..."
docker volume prune -f