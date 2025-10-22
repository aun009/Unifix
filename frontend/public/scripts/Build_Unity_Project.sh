#!/bin/bash
# Build Unity project

echo "Building Unity project..."

unity -batchmode -quit -projectPath "/path/to/your/project" -buildTarget StandaloneLinux64 -executeMethod BuildScript.PerformBuild

echo "Unity project built successfully!"

