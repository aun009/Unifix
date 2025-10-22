#!/bin/bash
# Run iOS Emulator (macOS only)

echo "Running iOS Emulator..."

xcrun simctl boot "iPhone 12"
xcrun simctl openurl booted "http://localhost:8081"

echo "iOS Emulator running!"

