#!/bin/bash
# Visualize Data with Seaborn

echo "Visualizing data with Seaborn..."

python -c "import seaborn as sns; import matplotlib.pyplot as plt; data = sns.load_dataset(iris); sns.pairplot(data); plt.show()"

echo "Data visualization complete!"

