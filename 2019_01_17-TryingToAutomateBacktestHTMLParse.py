# -*- coding: utf-8 -*-
"""
Created on Thu Jan 17 09:11:20 2019

@author: cv
"""


from PIL import ImageGrab, ImageOps, Image
import pyautogui
import pytesseract
import os
import time
import pandas as pd
from bs4 import BeautifulSoup
import codecs

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
    UpperRightBoxCurrency = (200,585)
    LowerLeftBoxCurrency = (155, 600)
    InsideInform = (253,693)
    
    
    cordArray = ([AjustedTabCord, SymbolCoordinate, 
                  FromDateYearCord, GreenFillChord,
                  StartCord, InformTabChord,
                  UpperRightBoxCurrency,
                  LowerLeftBoxCurrency,
                  InsideInform])
    
CurrencyBoxLeftX = Cords.LowerLeftBoxCurrency[0]
CurrencyBoxTopY = Cords.UpperRightBoxCurrency[1]
CurrencyBoxRightX = Cords.UpperRightBoxCurrency[0]
CurrencyBoxBottomY = Cords.LowerLeftBoxCurrency[1]

#Extracting currency
def ExtractCurrencySymbol(left_x, top_y, right_x, bottom_y):
    
    MT4ImageBoxCurrency = ImageGrab.grab(bbox = (left_x, top_y, 
                                         right_x, bottom_y))

    CurrencyText = pytesseract.image_to_string(MT4ImageBoxCurrency)
    CurrencyText = CurrencyText[0:6]
    
    return(CurrencyText)
    
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

def ExtractProfit():
    page = codecs.open("StrategyTester.htm",'r',"ISO-8859-1")
    PageData = BeautifulSoup(page.read()).get_text() 
    ProfitText = PageData[(PageData.find('Beneficio neto total')+len('Beneficio neto total')):
        PageData.find('Beneficio bruto')]
    
    Profit = float(ProfitText)
    
    return(Profit)
    
def ExtractCurrency():
    page = codecs.open("StrategyTester.htm",'r',"ISO-8859-1")
    PageData = BeautifulSoup(page.read()).get_text() 
    Currency = PageData[(PageData.find('Símbolo')+len('Símbolo')):(PageData.find('Símbolo')+len('Símbolo'))+6]
    
    return(Currency)

#LOOP
SymbolCheck = False
for symbol in range(0, 1): #Es 15
    print("Symbolloop", symbol)
    for row in range(0,1):
        pyautogui.moveTo(Cords.SymbolCoordinate, duration = .25)
        pyautogui.click(duration = .25)
        if(SymbolCheck == True ):
            pyautogui.typewrite(['down'], .25) #Flecha para abajo.
        time.sleep(3)
        pyautogui.click(duration = .25)    
        
        time.sleep(.5)
        pyautogui.moveTo(Cords.StartCord, duration = .25)
        pyautogui.click(duration = .25)
        
        time.sleep(5)
        ScreenImage = ImageGrab.grab()
        grayImage = ImageOps.grayscale(ScreenImage)
        pixel = grayImage.getpixel(Cords.GreenFillChord)
        time.sleep(5)
        
        while pixel != 109:
            time.sleep(10)
            ScreenImage = ImageGrab.grab()
            grayImage = ImageOps.grayscale(ScreenImage)
            pixel = grayImage.getpixel(Cords.GreenFillChord)
            
        
        #DownloadingHTML
        pyautogui.moveTo(Cords.InformTabChord, duration = .25)
        pyautogui.click(duration = .25)  
        time.sleep(5)
        pyautogui.moveTo(Cords.InsideInform, duration = .25)
        pyautogui.click(button='right')
        time.sleep(.3)
        pyautogui.press('up')
        time.sleep(0.5)
        pyautogui.press('enter')
        time.sleep(0.5)
        pyautogui.press('enter')
        time.sleep(0.5)
        pyautogui.press('left')
        time.sleep(0.5)
        pyautogui.press('enter')
        time.sleep(3)
        #pyautogui.hotkey('ctrl', 'w')
        pyautogui.keyDown('ctrl')
        time.sleep(.2)
        pyautogui.keyDown('w')
        time.sleep(.2)
        pyautogui.keyUp('ctrl')  
        time.sleep(.1)
        pyautogui.keyUp('w')     
        time.sleep(.1)
        
        Profit = ExtractProfit()
        CurrencyText = ExtractCurrency()
        
        
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
