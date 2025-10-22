#!/bin/bash
# Install Slack

echo "Installing Slack..."

wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.18.0-amd64.deb
sudo apt install -y ./slack-desktop-4.18.0-amd64.deb

echo "Slack installation complete!"

