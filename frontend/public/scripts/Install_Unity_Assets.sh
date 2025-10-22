#!/bin/bash
# Install Game Assets from Unity Asset Store

echo "Installing assets from Unity Asset Store..."

unity -batchmode -quit -projectPath "/path/to/your/project" -importPackage "/path/to/asset/package"

echo "Assets imported into Unity project!"

