# -*- coding: utf-8 -*-
"""
Created on Sun Jan 13 20:50:28 2019

@author: cv
"""

from PIL import ImageGrab, ImageOps, Image
import pyautogui
import pytesseract
import cv2
import os
import time
import pandas as pd

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"
os.chdir(r'C:\Users\cv\.spyder-py3\2018_11_17-Projects\2019_01_13-AutoBacktestImages')

pyautogui.position()

#Symbol coordinate x = 457, y = 591

class Cords:
    AjustedTabCord = (50, 819)
    SymbolCoordinate = (457, 591)
    FromDateYearCord = (290, 649)
    StartCord = (650, 797)
    InformTabChord = (257, 818)
    GreenFillChord = (624, 789)
    UpperLeftBoxProfit = (227,603)
    UpperRightBoxProfit = (278,603)
    LowerLeftBoxProfit = (227,620)
    LowerRightBoxProfit = (278,620)
    UpperRightBoxCurrency = (200,585)
    LowerLeftBoxCurrency = (155, 600)
    
    
    cordArray = ([AjustedTabCord, SymbolCoordinate, 
                  FromDateYearCord, GreenFillChord,
                  StartCord, InformTabChord,
                  UpperLeftBoxProfit,
                  UpperRightBoxProfit,
                  LowerLeftBoxProfit,
                  LowerRightBoxProfit,
                  UpperRightBoxCurrency,
                  LowerLeftBoxCurrency])
    
ScreenImage = ImageGrab.grab()
grayImage = ImageOps.grayscale(ScreenImage)
pixel =grayImage.getpixel(Cords.GreenFillChord)

ProfitBoxLeftX = Cords.LowerLeftBoxProfit[0]
ProfitBoxTopY = Cords.UpperRightBoxProfit[1]
ProfitBoxRightX = Cords.UpperRightBoxProfit[0]
ProfitBoxBottomY = Cords.LowerLeftBoxProfit[1]

CurrencyBoxLeftX = Cords.LowerLeftBoxCurrency[0]
CurrencyBoxTopY = Cords.UpperRightBoxCurrency[1]
CurrencyBoxRightX = Cords.UpperRightBoxCurrency[0]
CurrencyBoxBottomY = Cords.LowerLeftBoxCurrency[1]

#ProfitGettingFuncion
#bbox argumet order = (left_x, top_y, right_x, bottom_y)
def ExtractProfit(left_x, top_y, right_x, bottom_y):

    MT4ImageBox = ImageGrab.grab(bbox = (left_x, top_y, 
                                         right_x, bottom_y))
    
    #MT4ImageBox = MT4ImageBox.resize([49*1.3,19*1.3])
   
    ProfitText = pytesseract.image_to_string(MT4ImageBox)    
    ProfitText = ProfitText.replace('$','8')
    ProfitText = ProfitText.replace(',','')
    Profit = float(ProfitText)
    
    return(Profit)

"""####aaaaaaaaa
MT4ImageBox = ImageGrab.grab(bbox = (ProfitBoxLeftX,
                                   ProfitBoxTopY,
                                   ProfitBoxRightX,
                                   ProfitBoxBottomY))

MT4ImageBox = ImageGrab.grab(bbox = (146,
                                   398,
                                   259,
                                   434))

pyautogui.position()

#MT4ImageBox.size
MT4ImageBox = MT4ImageBox.resize([49*2,19*2])
   
ProfitText = pytesseract.image_to_string(MT4ImageBox)
if(ProfitText[len(ProfitText)-1] == ',' ):
    ProfitText = ProfitText[0:(len(ProfitText)-1)]
    
Profit = float(ProfitText)

MT4ImageBox.save("Image.png")

image = cv2.imread("Image.jpg")
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
denoise = cv2.fastNlMeansDenoising(image)
threshhold = cv2.threshold(image,127,255,cv2.THRESH_BINARY)
cv2.imwrite("edgedimage.jpg",threshhold)
ProfitText = pytesseract.image_to_string(threshhold)

MT4ImageBox = MT4ImageBox.convert()
"""####aaaaaaaaaaaa

#Solo deberia de haber definido la funcion una vez con un if
def ExtractCurrencySymbol(left_x, top_y, right_x, bottom_y):
    
    MT4ImageBoxCurrency = ImageGrab.grab(bbox = (left_x, top_y, 
                                         right_x, bottom_y))

    CurrencyText = pytesseract.image_to_string(MT4ImageBoxCurrency)
    CurrencyText = CurrencyText[0:6]
    
    return(CurrencyText)


"""
CurrencyText = ExtractCurrencySymbol(CurrencyBoxLeftX,
                       CurrencyBoxTopY,
                       CurrencyBoxRightX,
                       CurrencyBoxBottomY)

#Esto lo tengo que poner despues de haberle picado a 
    #informe tab
Profit = ExtractProfit(ProfitBoxLeftX,
                       ProfitBoxTopY,
                       ProfitBoxRightX,
                       ProfitBoxBottomY)

"""

USDJPY = []
USDCAD = []
CADJPY = []
CADCHF = []
CHFJPY = []
EURCAD = []
EURCHF = []
EURGBP = []
EURUSD = []
EURJPY = []
GBPCAD = []
GBPCHF = []
GBPUSD = []
GBPJPY = []
USDCHF = []
#Lo que sigue es hacer un simple:
    #1.- click currency 
    #2.- Take currency string
    #3.- Click Start (For now, later change start date)
    #4.- If ImageGrab greyscale value = 109 (Verde), 
        #click informes
    #5.- En informes, take profit value.
    #6.- Put in db.
    #7.- back to ajusted
    #8.- Change currency (Or continue with same X times)

SymbolCheck = False
for symbol in range(0, 15):
    print("Symbolloop", symbol)
    for row in range(0,2):
        pyautogui.moveTo(Cords.SymbolCoordinate, duration = .25)
        pyautogui.click(duration = .25)
        if(SymbolCheck == True ):
            pyautogui.typewrite(['down'], .25) #Flecha para abajo.
        time.sleep(3)
        pyautogui.click(duration = .25)
        
        CurrencyText = ExtractCurrencySymbol(CurrencyBoxLeftX,
                               CurrencyBoxTopY,
                               CurrencyBoxRightX,
                               CurrencyBoxBottomY)
        
        pyautogui.moveTo(Cords.StartCord, duration = .25)
        pyautogui.click(duration = .25)
        
        time.sleep(3)
        ScreenImage = ImageGrab.grab()
        grayImage = ImageOps.grayscale(ScreenImage)
        pixel = grayImage.getpixel(Cords.GreenFillChord)
        time.sleep(10)
        
        while pixel != 109:
            time.sleep(10)
            ScreenImage = ImageGrab.grab()
            grayImage = ImageOps.grayscale(ScreenImage)
            pixel =grayImage.getpixel(Cords.GreenFillChord)
            
        
        #
        pyautogui.moveTo(Cords.InformTabChord, duration = .25)
        pyautogui.click(duration = .25)  
        
        try:
            Profit = ExtractProfit(ProfitBoxLeftX,
                                   ProfitBoxTopY,
                                   ProfitBoxRightX,
                                   ProfitBoxBottomY) 
        except:
            Profit = "Error"
            pass
        
        if(CurrencyText == 'USDJPY'): USDJPY.append(Profit)
        if(CurrencyText == 'USDCAD'): USDCAD.append(Profit)
        if(CurrencyText == 'CADJPY'): CADJPY.append(Profit)
        if(CurrencyText == 'CADCHF'): CADCHF.append(Profit)
        if(CurrencyText == 'CHFJPY'): CHFJPY.append(Profit)
        if(CurrencyText == 'EURCAD'): EURCAD.append(Profit)
        if(CurrencyText == 'EURCHF'): EURCHF.append(Profit)
        if(CurrencyText == 'EURGBP'): EURGBP.append(Profit)
        if(CurrencyText == 'EURUSD'): EURUSD.append(Profit)
        if(CurrencyText == 'EURJPY'): EURJPY.append(Profit)
        if(CurrencyText == 'GBPCAD'): GBPCAD.append(Profit)
        if(CurrencyText == 'GBPCHF'): GBPCHF.append(Profit)
        if(CurrencyText == 'GBPUSD'): GBPUSD.append(Profit)
        if(CurrencyText == 'GBPJPY'): GBPJPY.append(Profit)
        if(CurrencyText == 'USDCHF'): USDCHF.append(Profit)
        
        pyautogui.moveTo(Cords.AjustedTabCord, duration = .25)
        pyautogui.click(duration = .25)
        SymbolCheck = False
        print("InnerLoop", row)
    
    SymbolCheck = True
    
ProfitDatabase = pd.DataFrame()
ProfitDatabase['USDJPY'] = USDJPY
ProfitDatabase['USDCAD'] = USDCAD
ProfitDatabase['CADJPY'] = CADJPY
ProfitDatabase['CADCHF'] = CADCHF
ProfitDatabase['CHFJPY'] = CHFJPY
ProfitDatabase['EURCAD'] = EURCAD
ProfitDatabase['EURCHF'] = EURCHF
ProfitDatabase['EURGBP'] = EURGBP
ProfitDatabase['EURUSD'] = EURUSD
ProfitDatabase['EURJPY'] = EURJPY
ProfitDatabase['GBPCAD'] = GBPCAD
ProfitDatabase['GBPCHF'] = GBPCHF
ProfitDatabase['GBPUSD'] = GBPUSD
ProfitDatabase['GBPJPY'] = GBPJPY
ProfitDatabase['USDCHF'] = USDCHF

ProfitDatabase.to_csv('ProfitDatabaseRandomWithTrailingStopLoss.csv')

