#!/bin/bash
set -e
sudo apt update && sudo apt install apache2-utils -y
ab -n 100 -c 10 http://localhost/
