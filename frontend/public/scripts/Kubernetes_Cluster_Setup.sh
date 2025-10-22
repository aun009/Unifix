#!/bin/bash
set -e
curl -sfL https://get.k3s.io | sh -
sudo k3s kubectl get nodes
