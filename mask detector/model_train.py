import random
import pickle
import numpy as np
import tensorflow as tf

gpus = tf.config.experimental.list_physical_devices('GPU')
tf.config.experimental.set_memory_growth(gpus[0], True)

X=pickle.load(open("dataset/Mask_Detection_X.pickle", "rb"))
Y=pickle.load(open("dataset/Mask_Detection_Y.pickle", "rb"))

X=np.array(X/255.0)
Y=np.array(Y)

model = tf.keras.models.Sequential([
    tf.keras.layers.Conv2D(16, (3,3), activation = 'relu', input_shape=X.shape[1:]),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Conv2D(32, (3,3), activation = 'relu'),
    tf.keras.layers.MaxPooling2D(2,2),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(512, activation = 'relu'),
    tf.keras.layers.Dense(128, activation = "relu"),
    tf.keras.layers.Dense(40, activation = "relu"),
    tf.keras.layers.Dense(1, activation = 'sigmoid')
])

model.compile(loss = "binary_crossentropy",optimizer="adam",metrics=["accuracy"])

model.fit(X, Y, epochs = 3)

model.save("model/mask_detector.h5")