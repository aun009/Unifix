#!/bin/bash
set -e
docker system prune -af --volumes
export DOCKER_BUILDKIT=1
echo "Docker optimized. BuildKit enabled."
