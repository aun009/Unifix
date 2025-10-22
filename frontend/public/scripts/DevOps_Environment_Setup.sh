#!/bin/bash
set -e
sudo apt update && sudo apt install -y docker docker-compose ansible terraform
echo "DevOps environment ready with Docker, Compose, Ansible, Terraform"
