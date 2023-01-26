import cv2
import imutils
import pytesseract
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import firestore
import datetime

from PIL import Image
from pytesseract import pytesseract

import matplotlib.pyplot as plt

import serial
from cv2 import (VideoCapture, namedWindow, imshow, waitKey, destroyWindow, imwrite)


cred = credentials.Certificate("easyhighwaypay-c3d14144b849.json")
firebase_admin.initialize_app(cred)

db = firestore.client()


arduinodata = serial.Serial('COM6',9600,timeout=1)

isGetShot = True
vahicalDistance = 20

while 1:
    val = arduinodata.readline().decode("ascii")
    # print(val);
    
    
    
    if val != '':
        intval = int(val)
        print("Waiting for Vehical.....")
        
        
    
        if(intval<vahicalDistance and intval>0 and isGetShot):
            cam_port = 1
            cam = VideoCapture(cam_port)
            isGetShot = False

            # reading the input using the camera
            result, image = cam.read()

            # If image will detected without any error,
            # show result
            if result:

                # showing result, it take frame name and image
                # output
                # imshow("EntrancePlace", image)

                # saving image in local storage
                imwrite("EntrancePlace.jpg", image)
                                                
                
                Entrance = "Maho"
                current_date_time = datetime.datetime.now();
                day = str(current_date_time.year) +"-"+ str(current_date_time.month) +"-"+ str(current_date_time.day)
                time = str(current_date_time.hour) + ":" + str(current_date_time.minute) + ":" + str(current_date_time.second)

                def DataBaseCommunication(VehicalNumber):
                    #save data
                    data = {
                        'entrance':Entrance,
                        'endate' : day,
                        'entime' : time ,
                        
                        }
                    db.collection('Vehical').document(VehicalNumber).set(data)
                    
 
                def ImgToText():
                        # Up-sample
                    # img = cv2.resize(img, (0, 0), fx=2, fy=2)

                    # # Convert to HSV color-space
                    # hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

                    # # Get the binary mask
                    # msk = cv2.inRange(hsv, np.array([0, 0, 123]), np.array([179, 255, 255]))

                    # # OCR
                    # txt = pytesseract.image_to_string(msk,lang='eng')
                    path = r'C:/Program Files (x86)/Tesseract-OCR/tesseract.exe'

                    pathimg = '7.png'


                    pytesseract.tesseract_cmd = path

                    img = Image.open(pathimg)

                    text = pytesseract.image_to_string(img)

                    # print(text)
                    # Display
                    # cv2.imshow("msk", msk)
                    return text
                
 
                def ScaneImage():
                    pytesseract.tesseract_cmd = 'C:/Program Files (x86)/Tesseract-OCR/tesseract.exe'

                    image = cv2.imread('EntrancePlace.jpg')
                    image = imutils.resize(image, width=300 )
                    # cv2.imshow("original image", image)
                    # cv2.waitKey(0)

                    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                    # cv2.imshow("greyed image", gray_image)
                    # cv2.waitKey(0)

                    gray_image = cv2.bilateralFilter(gray_image, 11, 17, 17)
                    # cv2.imshow("smoothened image", gray_image)
                    # cv2.waitKey(0)

                    edged = cv2.Canny(gray_image, 30, 200)
                    # cv2.imshow("edged image", edged)
                    # cv2.waitKey(0)

                    cnts,new = cv2.findContours(edged.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
                    image1=image.copy()
                    cv2.drawContours(image1,cnts,-1,(0,255,0),3)
                    # cv2.imshow("contours",image1)
                    # cv2.waitKey(0)

                    cnts = sorted(cnts, key = cv2.contourArea, reverse = True) [:30]
                    screenCnt = None
                    image2 = image.copy()
                    cv2.drawContours(image2,cnts,-1,(0,255,0),3)
                    # cv2.imshow("Top 30 contours",image2)
                    # cv2.waitKey(0)

                    i=7
                    for c in cnts:
                        perimeter = cv2.arcLength(c, True)
                        approx = cv2.approxPolyDP(c, 0.018 * perimeter, True)
                        if len(approx) == 4:
                            screenCnt = approx
                            x,y,w,h = cv2.boundingRect(c)
                            new_img=image[y:y+h,x:x+w]
                            cv2.imwrite('./'+str(i)+'.png',new_img)
                            i+=1
                            break


                    # cv2.drawContours(image, [screenCnt], -1, (0, 255, 0), 3)
                    # cv2.imshow("image with detected license plate", image)
                    # cv2.waitKey(0)

                    # Cropped_loc = './7.png'
                    # cv2.imshow("cropped", cv2.imread(Cropped_loc))
                    # plate = pytesseract.image_to_string(Cropped_loc, lang='eng')
                    # print("Number plate is:", plate)
                    # VNumber = ImgToText(cv2.imread(Cropped_loc))
                    # print(VehicalNumber)
                    VNumber = ImgToText()
                    # cv2.waitKey(0)
                    # cv2.destroyAllWindows()
                    return VNumber

                
                
                VNumber = ScaneImage()
                NumberPlate = VNumber.strip()
                
                print("\n\nEntrance Place Vehical found : "+NumberPlate+"\n\n")
            
                DataBaseCommunication(NumberPlate)
                
                
                
                

                # If keyboard interrupt occurs, destroy image
                # window
                # waitKey(0)
                # destroyWindow("EntrancePlace")

                # If captured image is corrupted, moving to else part
            else:
                print("No image detected. Please! try again")
        
        if(intval>vahicalDistance):
            isGetShot = True
            
