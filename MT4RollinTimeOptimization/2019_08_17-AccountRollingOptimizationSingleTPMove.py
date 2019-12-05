# -*- coding: utf-8 -*-
"""
Created on Fri Aug 16 16:41:42 2019

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



os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\MT4RollinTimeOptimization')

def getProfitAndConditionsTable():    
    soup = BeautifulSoup(open("OptimizationReport.htm").read())
    ProfitAndConditionsTable = [];
    
    for i in range(6,len(soup.find_all("tr"))):
        ##TP
        currentTPStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("TakeProfit=") + 11
        currentTPEnd = str(soup.find_all("tr")[i].find_all("td")[0])[currentTPStart:].find(";") + currentTPStart
        currentTakeProfit = str(soup.find_all("tr")[i].find_all("td")[0])[currentTPStart:currentTPEnd]
        currentTakeProfit = float(currentTakeProfit)
        
        currentProfit = float(soup.find_all("tr")[i].find_all("td")[1].text)
        
        currentTable = [currentProfit,currentTakeProfit]
        
        ProfitAndConditionsTable.append(currentTable)
    
    return(ProfitAndConditionsTable)


"""
Double monitor
"""
FromDatePosition = [287,233]
ToDatePosition = [547,233]
SymbolBarPosition = [680,178]
StartPosition = [1498,317]
ResultsPosition = [120,340]
RepasoPosition = [67,141]
minimizePosition = [2511,9]
adjustedPosition = [44,346]
expertPropertiesPosition = [1522,157]



#######START OPTIMIZATION: #Por ahora la primera sera manual
totalMonthRange = 6
Year = 2008
Step = 1
OriginalAccountBalance = 1000 #Coordinar esta con el MQ4 code.
newAccountBalance = OriginalAccountBalance
for zzz in range(0,totalMonthRange,Step): 
    
    ####Seccion De PropiedadesDelExperto
    if zzz == 1:
        soup = BeautifulSoup(open("OptimizationReport.htm").read())
        PrevAccountBalance = soup.find_all("tr")[3].find_all("td")[1].text
        currentProfitAndConditions = getProfitAndConditionsTable()
        currentProfitAndConditions.sort()
        prevBestOptimizedValue = currentProfitAndConditions[len(currentProfitAndConditions)-1][1]
        newAccountBalance = OriginalAccountBalance
    elif zzz > 1:
        soup = BeautifulSoup(open("OptimizationReport.htm").read())
        PrevAccountBalance = soup.find_all("tr")[3].find_all("td")[1].text
        currentProfitAndConditions = getProfitAndConditionsTable()
        for ab in range(0,len(currentProfitAndConditions)):
            if(prevBestOptimizedValue == currentProfitAndConditions[ab][1]):
                prevBestOptimizedIndex = ab
        benefits = float(currentProfitAndConditions[prevBestOptimizedIndex][0])
        newAccountBalance = float(PrevAccountBalance) + benefits
        currentProfitAndConditions.sort()
        prevBestOptimizedValue = currentProfitAndConditions[len(currentProfitAndConditions)-1][1]
                
        
    
    if(newAccountBalance < 100):
        Bankrupt = str(Year) + "/" +str(ToMonth)
        print(Bankrupt)
        break
    pyautogui.click(expertPropertiesPosition[0],expertPropertiesPosition[1])
    time.sleep(1)
    pyautogui.typewrite(str(newAccountBalance))
    time.sleep(1)
    pyautogui.press('enter')    
    
    
    ##SET DATE
    pyautogui.click(FromDatePosition[0],FromDatePosition[1])
    time.sleep(1)
    pyautogui.typewrite(str(Year)) 
    time.sleep(1)
    pyautogui.press('right')
    time.sleep(1)
    month = (1+zzz)%13
    if(month == 0): 
        month = 1
    pyautogui.typewrite(str(month))
    time.sleep(1)
    
    
    pyautogui.click(ToDatePosition[0],ToDatePosition[1])
    time.sleep(1)
    if(month+Step > 12):
        Year +=1
        ToMonth = (month+Step)%12
    else:
        ToMonth = month + Step
    pyautogui.typewrite(str(Year)) 
    time.sleep(1)
    pyautogui.press('right')
    time.sleep(1)
    pyautogui.typewrite(str(ToMonth))
    time.sleep(1)
        
    
    #Esta seccion es picarle start 
    pyautogui.click(StartPosition[0], StartPosition[1])
    time.sleep(5)
    Screen = PIL.ImageGrab.grab()
    PixelValue = Screen.getpixel((SymbolBarPosition[0], SymbolBarPosition[1]))         
    while(PixelValue[0] != 225):
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

