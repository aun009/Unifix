#!/bin/bash
set -e
sudo apt update && sudo apt install -y gh
gh auth login
mkdir -p .github/workflows
cat <<EOT > .github/workflows/ci.yml
name: CI Pipeline
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Hello World
      run: echo Hello, world!
EOT
