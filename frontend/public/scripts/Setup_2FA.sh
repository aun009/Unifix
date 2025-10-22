#!/bin/bash
# Set Up Two-Factor Authentication (2FA)

echo "Setting up Two-Factor Authentication (2FA)..."

# Example: For Google Authenticator
sudo apt install -y libpam-google-authenticator
google-authenticator

echo "Two-Factor Authentication set up successfully!"

