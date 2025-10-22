#!/bin/bash
set -e
sudo apt update && sudo apt install awscli -y
aws configure
echo "Example: aws autoscaling create-auto-scaling-group --cli help"
