#!/bin/bash
set -e
sudo apt update && sudo apt install -y nginx
cat <<EOT > /etc/nginx/conf.d/load_balancer.conf
upstream backend {
  server 127.0.0.1:5000;
  server 127.0.0.1:5001;
}
server {
  listen 80;
  location / {
    proxy_pass http://backend;
  }
}
EOT
sudo systemctl restart nginx
