#!/bin/bash
# Perform Linear Regression with Scikit-learn

echo "Performing linear regression with Scikit-learn..."

python -c "from sklearn.datasets import make_regression; from sklearn.linear_model import LinearRegression; X, y = make_regression(n_samples=100, n_features=1, noise=0.1, random_state=42); model = LinearRegression(); model.fit(X, y); print(Model coefficients:, model.coef_)"

echo "Linear regression complete!"

