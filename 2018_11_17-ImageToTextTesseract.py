# -*- coding: utf-8 -*-
"""
Editor de Spyder

Este es un archivo temporal.
"""

from PIL import Image
import pytesseract
import argparse
import cv2
import os

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"
os.chdir(r'C:\Users\cv\Documents\ImagesOCRTest')


ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required=True,
	help="path to input image to be OCR'd")
ap.add_argument("-p", "--preprocess", type=str, default="thresh",
	help="type of preprocessing to be done")
args = vars(ap.parse_args())

#Load the image and convert to greyscale
image = cv2.imread(args["image"])
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)

if args["preprocess"] == "thresh":
    gray = cv2.threshhold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    
elif args["preprocess"] == "blur":
    gray = cv2.medianBlur(gray,3)

#Lo anterior no jala y era para limpiar la imagen, esto es el puro modulo
filename = "2018_11_11-LabDeMicroSubirBlackBoard.png".format(os.getpid())
cv2.imwrite(filename, gray)

text = pytesseract.image_to_string(Image.open(filename))
os.remove(filename)
print(text)

#show the output images
cv2.imshow("Image", image)
cv2.imshow("Output", gray)
cv2.waitKey(0)

