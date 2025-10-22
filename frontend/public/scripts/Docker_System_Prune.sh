#!/bin/bash
# Docker System Prune

echo "Pruning unused Docker data..."

docker system prune -f

echo "Unused Docker data cleaned up!"

