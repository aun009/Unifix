#!/bin/bash
# Install Flutter

echo "Installing Flutter..."

git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter installation complete!"

