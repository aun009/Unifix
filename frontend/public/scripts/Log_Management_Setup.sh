#!/bin/bash
set -e
sudo apt update && sudo apt install docker-compose -y
mkdir elk && cd elk
cat <<EOT > docker-compose.yml
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.13.4
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
  kibana:
    image: docker.elastic.co/kibana/kibana:8.13.4
    ports:
      - "5601:5601"
EOT
docker-compose up -d
