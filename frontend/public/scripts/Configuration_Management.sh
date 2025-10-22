#!/bin/bash
set -e
sudo apt update && sudo apt install ansible -y
echo "[local]" > hosts
echo "127.0.0.1 ansible_connection=local" >> hosts
