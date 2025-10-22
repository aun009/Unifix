#!/bin/bash
# Run Android Emulator

echo "Available Emulators:"
emulator -list-avds

echo "Enter the name of the emulator to start:"
read emulator_name

# Start the emulator
emulator -avd $emulator_name
