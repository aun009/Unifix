#!/bin/bash
# filepath: frontend/public/scripts/Network_Configuration.sh

echo "Docker network configuration..."

docker network ls
echo "Inspecting bridge network:"
docker network inspect bridge