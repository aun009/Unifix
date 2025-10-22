#!/bin/bash
# Train a Model with TensorFlow

echo "Training a model with TensorFlow..."

python -c "import tensorflow as tf; from tensorflow.keras.models import Sequential; from tensorflow.keras.layers import Dense; model = Sequential([Dense(64, input_dim=8, activation=relu), Dense(3, activation=softmax)]); model.compile(loss=categorical_crossentropy, optimizer=adam, metrics=[accuracy]); print(TensorFlow model created!)"

echo "Model training complete!"

