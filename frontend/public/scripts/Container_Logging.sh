#!/bin/bash
# filepath: frontend/public/scripts/Container_Logging.sh

echo "Docker container logs..."

docker ps --format '{{.Names}}' | while read name; do
  echo "Logs for $name:"
  docker logs --tail 10 $name
done