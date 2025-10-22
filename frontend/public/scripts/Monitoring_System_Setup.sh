#!/bin/bash
set -e
sudo apt update && sudo apt install -y docker-compose
mkdir monitoring && cd monitoring
cat <<EOT > docker-compose.yml
version: '3'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
EOT
docker-compose up -d
