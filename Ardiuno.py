import serial
from cv2 import (VideoCapture, namedWindow, imshow, waitKey, destroyWindow, imwrite)

arduinodata = serial.Serial('COM4',9600,timeout=1)


while 1:
    val = arduinodata.readline().decode("utf-8")
    if val != '':
        intval = int(val)
        print(val)
    
    # if(int(val)<10 and int(val)>0 ):
    #     cam_port = 1
    #     cam = VideoCapture(cam_port)

    #     # reading the input using the camera
    #     result, image = cam.read()

    #     # If image will detected without any error,
    #     # show result
    #     if result:

    #         # showing result, it take frame name and image
    #         # output
    #         imshow("EntrancePlace", image)

    #         # saving image in local storage
    #         imwrite("EntrancePlace.png", image)

    #         # If keyboard interrupt occurs, destroy image
    #         # window
    #         waitKey(0)
    #         destroyWindow("EntrancePlace")

    #         # If captured image is corrupted, moving to else part
    #     else:
    #         print("No image detected. Please! try again")



