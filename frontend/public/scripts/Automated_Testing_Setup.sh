#!/bin/bash
set -e
sudo apt update && sudo apt install -y python3-pytest
pytest --version
