#!/bin/bash
# Save and Load a Model with Keras

echo "Saving and loading a model with Keras..."

python -c "from keras.models import Sequential; from keras.layers import Dense; model = Sequential([Dense(32, input_dim=8, activation=relu), Dense(3, activation=softmax)]); model.compile(loss=categorical_crossentropy, optimizer=adam, metrics=[accuracy]); model.save(model.h5); from keras.models import load_model; loaded_model = load_model(model.h5); print(Model saved and loaded successfully!)"

echo "Model saved and loaded successfully!"

