#!/bin/bash
# filepath: frontend/public/scripts/Container_Security.sh

echo "Checking Docker container security..."

docker scan $(docker images --format '{{.Repository}}:{{.Tag}}')
echo "Consider using Docker Bench for Security: https://github.com/docker/docker-bench-security"