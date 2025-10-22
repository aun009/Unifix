#!/bin/bash
set -e
sudo apt update && sudo apt install ufw fail2ban -y
sudo ufw allow OpenSSH
sudo ufw enable
sudo systemctl enable fail2ban
echo "Security hardening applied (UFW + Fail2Ban)"
