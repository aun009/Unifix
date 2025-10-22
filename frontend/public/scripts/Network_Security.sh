#!/bin/bash
# filepath: frontend/public/scripts/Network_Security.sh

echo "Network security..."

sudo netstat -tulnp
echo "Check for unexpected open ports and close unnecessary services."