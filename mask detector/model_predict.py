import tensorflow as tf
import cv2
import numpy as np

gpus = tf.config.experimental.list_physical_devices('GPU')
tf.config.experimental.set_memory_growth(gpus[0], True)

model = tf.keras.models.load_model("model/mask_detector.h5")

imgMask = "dataset/examples/mask_1.jpg"
imgNomask = "dataset/examples/nomask_1.jpg"

def resize(path):
    img_size = 100
    img = cv2.imread(path, cv2.IMREAD_COLOR)
    resize = cv2.resize(img, (img_size, img_size))
    resize = np.array(resize).reshape(-1, img_size, img_size, 3)
    return resize

def prediction(img):
    print(int(model.predict(img)))


prediction(resize(imgMask))
prediction(resize(imgNomask))