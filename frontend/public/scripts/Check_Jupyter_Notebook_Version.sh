#!/bin/bash
# Check Jupyter Notebook Version

echo "Checking Jupyter Notebook version..."

python -c "import notebook; print(notebook.__version__)"

echo "Jupyter Notebook version checked!"

