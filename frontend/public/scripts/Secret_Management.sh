#!/bin/bash
set -e
docker run -d --cap-add=IPC_LOCK -p 8200:8200 --name=dev-vault vault
echo "Use Vault CLI for secret management: vault kv put secret/foo value=bar"
