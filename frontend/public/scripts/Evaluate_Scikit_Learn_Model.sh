#!/bin/bash
# Evaluate Model with Scikit-learn

echo "Evaluating a model with Scikit-learn..."

python -c "from sklearn.datasets import load_iris; from sklearn.model_selection import train_test_split; from sklearn.ensemble import RandomForestClassifier; data = load_iris(); X_train, X_test, y_train, y_test = train_test_split(data.data, data.target, test_size=0.2, random_state=42); model = RandomForestClassifier(); model.fit(X_train, y_train); print(model.score(X_test, y_test))"

echo "Model evaluation complete!"

