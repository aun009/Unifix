#!/bin/bash
# filepath: frontend/public/scripts/Firewall_Management.sh

echo "Managing firewall..."

sudo ufw status
echo "To enable: sudo ufw enable"
echo "To allow port: sudo ufw allow <port>"