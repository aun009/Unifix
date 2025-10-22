#!/bin/bash
# Install PostgreSQL

echo "Installing PostgreSQL..."

sudo apt update
sudo apt install -y postgresql postgresql-contrib

echo "PostgreSQL installation complete!"

