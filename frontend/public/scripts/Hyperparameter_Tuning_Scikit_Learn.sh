#!/bin/bash
# Perform Hyperparameter Tuning with Scikit-learn

echo "Performing hyperparameter tuning with Scikit-learn..."

python -c "from sklearn.datasets import load_iris; from sklearn.model_selection import train_test_split, GridSearchCV; from sklearn.ensemble import RandomForestClassifier; data = load_iris(); X_train, X_test, y_train, y_test = train_test_split(data.data, data.target, test_size=0.2, random_state=42); model = RandomForestClassifier(); param_grid = {n_estimators: [10, 50, 100]}; grid_search = GridSearchCV(model, param_grid); grid_search.fit(X_train, y_train); print(grid_search.best_params_)"

echo "Hyperparameter tuning complete!"

