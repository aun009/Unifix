#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/Version_Control.sh

echo "========== Version Control Management =========="

echo "Checking for git installation..."
if ! command -v git &>/dev/null; then
  echo "Git not found. Installing git..."
  sudo apt update && sudo apt install -y git
fi

echo "Git version:"
git --version

read -p "Enter directory to initialize git repo (or leave blank for current): " dir
dir=${dir:-$(pwd)}

cd "$dir" || exit 1

if [ ! -d .git ]; then
  echo "Initializing new git repository in $dir"
  git init
else
  echo "Git repository already initialized."
fi

echo "Configuring user (global)..."
read -p "Enter your git user.name: " username
read -p "Enter your git user.email: " useremail
git config --global user.name "$username"
git config --global user.email "$useremail"

echo "Version control setup complete."