#!/bin/bash
# Visualize Data with Matplotlib

echo "Visualizing data with Matplotlib..."

python -c "import matplotlib.pyplot as plt; import numpy as np; x = np.linspace(0, 10, 100); y = np.sin(x); plt.plot(x, y); plt.show()"

echo "Data visualization complete!"

