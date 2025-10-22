#!/bin/bash
# Run Unity project

echo "Running Unity project..."

unity -batchmode -quit -projectPath "/path/to/your/project" -executeMethod BuildScript.RunProject

echo "Unity project running!"

