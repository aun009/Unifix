#!/bin/bash
# Data Preprocessing with Pandas

echo "Performing data preprocessing with Pandas..."

python -c "import pandas as pd; data = pd.read_csv(data.csv); data.dropna(inplace=True); data = pd.get_dummies(data); print(data.head())"

echo "Data preprocessing complete!"

