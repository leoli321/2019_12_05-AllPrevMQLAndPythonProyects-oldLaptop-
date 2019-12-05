# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 15:32:32 2019

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

"""
Single Monitor
FromDatePosition = [291,242]
ToDatePosition = [549,243]
SymbolBarPosition = [345,187]
StartPosition = [693,318]
ResultsPosition = [192,353]
RepasoPosition = [39,149]
adjustedPosition = [48,349]
"""

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
        
        ##CounterTradeMultiplier
        currentCTMStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("CounterTradeMultiplier=") + 23
        currentCTMEnd = str(soup.find_all("tr")[i].find_all("td")[0])[currentCTMStart:].find(";") + currentCTMStart
        currentCounterTradeMultiplier = str(soup.find_all("tr")[i].find_all("td")[0])[currentCTMStart:currentCTMEnd]
        currentCounterTradeMultiplier = float(currentCounterTradeMultiplier)             
        
        ##PreviousCandlesRange
        currentPCRStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("PreviousCandlesRange=") + 21
        currentPCREnd = str(soup.find_all("tr")[i].find_all("td")[0])[currentPCRStart:].find(";") + currentPCRStart
        currentPreviousCandlesRange = str(soup.find_all("tr")[i].find_all("td")[0])[currentPCRStart:currentPCREnd]
        currentPreviousCandlesRange = float(currentPreviousCandlesRange)            
                
        
        currentProfit = float(soup.find_all("tr")[i].find_all("td")[1].text)
        
        currentTable = [currentProfit,currentTakeProfit,currentStopLossMultiplier,currentCounterTradeMultiplier,currentPreviousCandlesRange]
        
        ProfitAndConditionsTable.append(currentTable)
    
    return(ProfitAndConditionsTable)
    


#######START OPTIMIZATION:
pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
for x in range(1,16):
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
for zzz in range(0,15):
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
    pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
    time.sleep(1)
    
    
    currentProfitAndConditionsTable = getProfitAndConditionsTable();
    
    currentProfitAndConditionsTable.sort()
    currentProfitAndConditionsTableLen = len(currentProfitAndConditionsTable)
    firstThreeCurrentProfitAndConditionsTable = [
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-1],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-2],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-3],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-4],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-5],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-6],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-7],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-8],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-9],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-10],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-11],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-12],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-13],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-14],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-15],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-16],
         currentProfitAndConditionsTable[currentProfitAndConditionsTableLen-17]
         ]
    
    currentSymbolProfitAndConditionsTable = [BeautifulSoup(open("OptimizationReport.htm").read()).find_all("tr")[0].text[7:13],firstThreeCurrentProfitAndConditionsTable]
    
    optimizationResults.append(currentSymbolProfitAndConditionsTable)


##Save as pickle
"""
with open('bearWithCandleRangeOptimizationResults.data', 'wb') as filehandle:  
    # store the data as binary data stream
    pickle.dump(optimizationResults, filehandle)

with open('bearWithCandleRangeOptimizationResults.data', 'rb') as filehandle:  
    # read the data as binary data stream
    optimizationResults = pickle.load(filehandle)    
"""
    
###See results:
##BullSum:

bullSymbolSumArray = [] 
for i in range(len(bullOptimizationResults)):
    currentSum = 0
    for x in range(len(bullOptimizationResults[0][1])):
        currentSum += bullOptimizationResults[i][1][x][0]
    currentSymbolSum = [bullOptimizationResults[i][0],int(currentSum)]
    bullSymbolSumArray.append(currentSymbolSum)
            
    
##bearSum:

bearSymbolSumArray = [] 
for i in range(len(bearOptimizationResults)):
    currentSum = 0
    for x in range(len(bearOptimizationResults[0][1])):
        currentSum += bearOptimizationResults[i][1][x][0]
    currentSymbolSum = [bearOptimizationResults[i][0],int(currentSum)]
    bearSymbolSumArray.append(currentSymbolSum)    
    
#BothSum
bothSumArray = []
for i in range(len(bullSymbolSumArray)):
    currentSum = bearSymbolSumArray[i][1] + bullSymbolSumArray[i][1]
    currentValue = [bearSymbolSumArray[i][0],currentSum]
    bothSumArray.append(currentValue)
    
#2019_08_13-GBPUSD IS THE WINNER.
