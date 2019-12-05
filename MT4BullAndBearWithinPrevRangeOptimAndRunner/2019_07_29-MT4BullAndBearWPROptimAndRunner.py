# -*- coding: utf-8 -*-
"""
Created on Mon Jul 29 10:20:06 2019

@author: gvega
"""

import pyautogui
from datetime import date
import os
from bs4 import BeautifulSoup
import PIL
import PIL.ImageGrab
import time
import pickle

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\MT4BullAndBearWithinPrevRangeOptimAndRunner')


TodayDay = date.today().day
TodayMonth = date.today().month
TodayYear = date.today().year

FromDatePosition = [287,233]
ToDatePosition = [547,233]
SymbolBarPosition = [680,178]
StartPosition = [1498,317]
ResultsPosition = [120,340]
RepasoPosition = [67,141]
minimizePosition = [2511,9]
adjustedPosition = [44,346]


def getProfitAndConditionsTable():    
    soup = BeautifulSoup(open("OptimizationReport.htm").read())
    ProfitAndConditionsTable = [];
    
    for i in range(6,len(soup.find_all("tr"))):
        ##TP
        currentTPStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("TakeProfit=") + 11
        currentTPEnd = str(soup.find_all("tr")[i].find_all("td")[0])[currentTPStart:].find(";") + currentTPStart
        currentTakeProfit = str(soup.find_all("tr")[i].find_all("td")[0])[currentTPStart:currentTPEnd]
        currentTakeProfit = float(currentTakeProfit)
        
        ##StopLossMultiplier
        currentSLStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("StopLossMultiplier=") + 19
        currentSLEnd = str(soup.find_all("tr")[i].find_all("td")[0])[currentSLStart:].find(";") + currentSLStart
        currentStopLossMultiplier = str(soup.find_all("tr")[i].find_all("td")[0])[currentSLStart:currentSLEnd]
        currentStopLossMultiplier = float(currentStopLossMultiplier)        
        
        currentProfit = float(soup.find_all("tr")[i].find_all("td")[1].text)
        
        currentTable = [currentProfit,currentTakeProfit,currentStopLossMultiplier]
        
        ProfitAndConditionsTable.append(currentTable)
    
    return(ProfitAndConditionsTable)
    


#######START OPTIMIZATION:
pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
for x in range(0,16):
    pyautogui.press('up')    
pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])

optimizationResults = []
##SET DATE
pyautogui.click(FromDatePosition[0],FromDatePosition[1])
time.sleep(1)
pyautogui.typewrite(str(TodayYear-1)) 
time.sleep(1)
pyautogui.press('right')
time.sleep(1)
pyautogui.typewrite(str(TodayMonth))
time.sleep(1)
pyautogui.press('right')
time.sleep(1)
pyautogui.typewrite(str(TodayDay))
time.sleep(1)

pyautogui.click(ToDatePosition[0],ToDatePosition[1])
time.sleep(1)
pyautogui.typewrite(str(TodayYear)) 
time.sleep(1)
pyautogui.press('right')
time.sleep(1)
pyautogui.typewrite(str(TodayMonth))
time.sleep(1)
pyautogui.press('right')
time.sleep(1)
pyautogui.typewrite(str(TodayDay))
time.sleep(1)
for zzz in range(5,16):
    if( zzz > 0):
        pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
        pyautogui.press('enter') 
        time.sleep(1)
    
    
    
    pyautogui.click(StartPosition[0], StartPosition[1])
    time.sleep(5)
    Screen = PIL.ImageGrab.grab()
    PixelValue = Screen.getpixel((SymbolBarPosition[0], SymbolBarPosition[1]))         
    while(PixelValue[0] == 204):
        Screen = PIL.ImageGrab.grab()
        PixelValue = Screen.getpixel((SymbolBarPosition[0], SymbolBarPosition[1]))             
        time.sleep(10)
    
    pyautogui.click(ResultsPosition[0], ResultsPosition[1])
    time.sleep(1)
    pyautogui.click(RepasoPosition[0], RepasoPosition[1])
    time.sleep(1)
    pyautogui.rightClick(RepasoPosition[0], RepasoPosition[1])
    time.sleep(1)
    pyautogui.press("down")
    pyautogui.press("down")
    pyautogui.press("down")
    pyautogui.press("down")
    time.sleep(1)
    pyautogui.press("enter")
    time.sleep(1)
    pyautogui.press("enter")
    time.sleep(1)
    pyautogui.press("left")
    time.sleep(1)
    pyautogui.press("enter")
    time.sleep(3)
    pyautogui.click(adjustedPosition[0], adjustedPosition[1])
    time.sleep(1)
    pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
    time.sleep(1)
    
    
    currentProfitAndConditionsTable = getProfitAndConditionsTable();
    
    currentProfitAndConditionsTable.sort()
    currentProfitAndConditionsTableLen = len(currentProfitAndConditionsTable)
    firstThreeCurrentProfitAndConditionsTable = [
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-1],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-2],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-3]
         ]
    
    currentSymbolProfitAndConditionsTable = [zzz,firstThreeCurrentProfitAndConditionsTable]
    
    optimizationResults.append(currentSymbolProfitAndConditionsTable)


##Save as pickle
with open('bearOptimizationResults.data', 'wb') as filehandle:  
    # store the data as binary data stream
    pickle.dump(optimizationResults, filehandle)
#OPEN PICKLE
with open('bearOptimizationResults.data', 'rb') as filehandle:  
    # read the data as binary data stream
    optimizationResults = pickle.load(filehandle)