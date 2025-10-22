#!/bin/bash
set -e
docker pull aquasec/trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image alpine
