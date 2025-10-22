#!/bin/bash
# Create a Game Build in Unity

echo "Creating a game build in Unity..."

unity -batchmode -quit -projectPath "/path/to/your/project" -buildTarget StandaloneLinux64 -executeMethod BuildScript.PerformBuild

echo "Game build created in Unity!"

