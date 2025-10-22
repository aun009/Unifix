#!/bin/bash
set -e
sudo apt update && sudo apt install -y netdata
sudo systemctl start netdata
