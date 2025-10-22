#!/bin/bash
# Create a Basic Neural Network with Keras

echo "Creating a basic neural network with Keras..."

python -c "from keras.models import Sequential; from keras.layers import Dense; model = Sequential([Dense(32, input_dim=8, activation=relu), Dense(3, activation=softmax)]); model.compile(loss=categorical_crossentropy, optimizer=adam, metrics=[accuracy]); print(Neural network model created!)"

echo "Neural network created successfully!"

