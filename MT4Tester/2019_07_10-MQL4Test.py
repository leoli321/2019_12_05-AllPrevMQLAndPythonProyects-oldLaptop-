# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 21:43:59 2019

@author: gvega
"""

import pyautogui
import time
from bs4 import BeautifulSoup
import codecs
import os
import pandas as pd
import pickle
import statistics
import seaborn as sns
import random
import PIL
import PIL.ImageGrab


os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\MT4Tester')
soup = BeautifulSoup(open("StrategyTester.htm").read())

Profit = soup.find_all("tr")[7].find_all("td")[3].text


def ChangeYear(Year):
    FromDateCoordinatesYear = [287,724]
    ToDateCoordinatesYear = [551,721]
    pyautogui.click(FromDateCoordinatesYear[0], FromDateCoordinatesYear[1])
    time.sleep(1)
    pyautogui.typewrite(str(Year)) 
    time.sleep(1)
    pyautogui.click(ToDateCoordinatesYear[0], ToDateCoordinatesYear[1])
    time.sleep(1)
    pyautogui.typewrite(str(Year)) 
    
    
def CheckIfItsRunning():
    SymbolBarPosition = [424,658]
    Screen = PIL.ImageGrab.grab()
    PixelValue = Screen.getpixel((SymbolBarPosition[0], SymbolBarPosition[1]))         
    if(PixelValue[0] == 204):
        StillRunning = True
    else: StillRunning = False
    
    return(StillRunning)


def Optimizer():
    
    ProfitArray = []
    IniciarCoordinates = [657,787]
    InformeCoordinates = [247,821]   
    MiddleInformeCoordinates = [233,750] 
    FromDateCoordinatesYear = [287,724]
    ToDateCoordinatesYear = [551,721]
    MinimizeCoordinates = [1476,6]
    AjustedCoordinates = [41,816]
    
    for i in range(2017,2019):
        ChangeYear(i)
        for n in range(0,12):   
            pyautogui.click(FromDateCoordinatesYear[0], FromDateCoordinatesYear[1])
            time.sleep(1)
            pyautogui.press('right')
            time.sleep(1)
            pyautogui.typewrite(str(n+1)) 
            time.sleep(1)
            pyautogui.click(ToDateCoordinatesYear[0], ToDateCoordinatesYear[1])
            time.sleep(1)
            pyautogui.press('right')
            time.sleep(1)
            pyautogui.typewrite(str(n+2)) 
            time.sleep(1)        
            pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
            time.sleep(10)
            while(CheckIfItsRunning() == True):
                time.sleep(10)
                
            pyautogui.click(InformeCoordinates[0], InformeCoordinates[1])
            time.sleep(1)
            pyautogui.rightClick(MiddleInformeCoordinates[0], MiddleInformeCoordinates[1])
            time.sleep(1)
            pyautogui.press('down')
            time.sleep(1)
            pyautogui.press('down')
            pyautogui.press('enter')
            time.sleep(1)
            pyautogui.press('enter')
            time.sleep(1)
            pyautogui.press('left')
            time.sleep(1)
            pyautogui.press('enter')        
            time.sleep(3)
            pyautogui.click(MinimizeCoordinates[0], MinimizeCoordinates[1])             
            time.sleep(3)  
            pyautogui.click(AjustedCoordinates[0], AjustedCoordinates[1])          
            soup = BeautifulSoup(open("StrategyTester.htm").read())
            ProfitArray.append(float(soup.find_all("tr")[7].find_all("td")[1].text))
            
    return (ProfitArray)


def OptimizerYearly():
    
    ProfitArray = []
    IniciarCoordinates = [657,787]
    InformeCoordinates = [247,821]   
    MiddleInformeCoordinates = [233,750] 
    MinimizeCoordinates = [1476,6]
    AjustedCoordinates = [41,816]
    ToDateCoordinatesYear = [551,721]
    
    for i in range(2010,2019):
        ChangeYear(i)
        time.sleep(2)
        pyautogui.click(ToDateCoordinatesYear[0], ToDateCoordinatesYear[1])
        time.sleep(1)
        pyautogui.typewrite(str(i+1))         
        pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
        time.sleep(10)
        while(CheckIfItsRunning() == True):
            time.sleep(10)
            
        pyautogui.click(InformeCoordinates[0], InformeCoordinates[1])
        time.sleep(1)
        pyautogui.rightClick(MiddleInformeCoordinates[0], MiddleInformeCoordinates[1])
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
        pyautogui.press('down')
        pyautogui.press('enter')
        time.sleep(1)
        pyautogui.press('enter')
        time.sleep(1)
        pyautogui.press('left')
        time.sleep(1)
        pyautogui.press('enter')        
        time.sleep(3)
        pyautogui.click(MinimizeCoordinates[0], MinimizeCoordinates[1])             
        time.sleep(3)  
        pyautogui.click(AjustedCoordinates[0], AjustedCoordinates[1])          
        soup = BeautifulSoup(open("StrategyTester.htm").read())
        ProfitArray.append(float(soup.find_all("tr")[7].find_all("td")[1].text))
        
    return (ProfitArray)

def NextSymbol():
    SymbolBarPosition = [424,658]
    pyautogui.click(SymbolBarPosition[0], SymbolBarPosition[1])
    time.sleep(1)
    pyautogui.press('down')        
    time.sleep(1)
    pyautogui.press('enter')    


def SavePickle(PickleStringName,Table):
    with open(PickleStringName, 'wb') as filehandle:  
        # store the data as binary data stream
        pickle.dump(Table, filehandle)
    

def OptimizerYearlyAcrossSymbols():
    ProfitArray = []
    IniciarCoordinates = [657,787]
    InformeCoordinates = [247,821]   
    MiddleInformeCoordinates = [233,750] 
    MinimizeCoordinates = [1476,6]
    AjustedCoordinates = [41,816]
    ToDateCoordinatesYear = [551,721]
    
    for n in range(0,11):
        if (n > 0):
            NextSymbol()
        PerSymbolProfitArray = []
        for i in range(2016,2019):
            ChangeYear(i)
            time.sleep(2)
            pyautogui.click(ToDateCoordinatesYear[0], ToDateCoordinatesYear[1])
            time.sleep(1)
            pyautogui.typewrite(str(i+1))         
            pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
            time.sleep(10)
            while(CheckIfItsRunning() == True):
                time.sleep(10)
                
            pyautogui.click(InformeCoordinates[0], InformeCoordinates[1])
            time.sleep(1)
            pyautogui.rightClick(MiddleInformeCoordinates[0], MiddleInformeCoordinates[1])
            time.sleep(1)
            pyautogui.press('down')
            time.sleep(1)
            pyautogui.press('down')
            pyautogui.press('enter')
            time.sleep(1)
            pyautogui.press('enter')
            time.sleep(1)
            pyautogui.press('left')
            time.sleep(1)
            pyautogui.press('enter')        
            time.sleep(3)
            pyautogui.click(MinimizeCoordinates[0], MinimizeCoordinates[1])             
            time.sleep(3)  
            pyautogui.click(AjustedCoordinates[0], AjustedCoordinates[1])          
            soup = BeautifulSoup(open("StrategyTester.htm").read())
            ProfitArray.append(float(soup.find_all("tr")[7].find_all("td")[1].text))
            PerSymbolProfitArray.append(float(soup.find_all("tr")[7].find_all("td")[1].text))
            
        stringForPickle = "CurrentSymbolNumber " +str(n)
        SavePickle(stringForPickle,PerSymbolProfitArray)
            
    return (ProfitArray)    
