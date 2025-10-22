#!/bin/bash
# filepath: frontend/public/scripts/Image_Management.sh

echo "Managing Docker images..."

docker images
echo "Removing dangling images..."
docker image prune -f
echo "Image management complete."