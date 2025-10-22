#!/bin/bash
# Check TensorFlow Version

echo "Checking TensorFlow version..."

python -c "import tensorflow as tf; print(tf.__version__)"

echo "TensorFlow version checked!"

