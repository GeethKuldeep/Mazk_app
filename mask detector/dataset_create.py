import os
import cv2
import random
import numpy as np
import pickle

directory = "dataset"
catagories = ["with_mask","without_mask"]

img_size = 100

def create_data():
    training_data = []
    count = 0
    for catagory in catagories:
        path = os.path.join(directory,catagory)
        class_num = catagories.index(catagory)
        if class_num != 0:
            count = 0
        for img in os.listdir(path):
            try:
                count += 1
                print(count," ok")
                img_array = cv2.imread(os.path.join(path,img),cv2.IMREAD_COLOR)
                new_array = cv2.resize(img_array,(img_size,img_size))
                training_data.append([new_array,class_num])
            except:
                pass
    random.shuffle(training_data)
    print(len(training_data))
    X = []
    Y = []
    for features, labels in training_data:
        X.append(features)
        Y.append(labels) 

    X=np.array(X).reshape(-1,img_size,img_size,3)

    pickle_out=open("dataset/Mask_Detection_X.pickle","wb")
    pickle.dump(X,pickle_out)
    pickle_out.close()

    pickle_out=open("dataset/Mask_Detection_Y.pickle","wb")
    pickle.dump(Y,pickle_out)
    pickle_out.close()    

create_data()