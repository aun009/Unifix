#!/bin/bash
# filepath: frontend/public/scripts/Container_Backup.sh

echo "Backing up Docker containers..."

echo "Saving list of containers:"
docker ps -a > docker_containers_backup.txt
echo "Backup complete. For full data backup, use 'docker commit' and 'docker save'."