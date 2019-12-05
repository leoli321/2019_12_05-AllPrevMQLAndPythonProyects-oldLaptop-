# -*- coding: utf-8 -*-
"""
Created on Thu Aug 15 09:10:15 2019

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
        
        currentProfit = float(soup.find_all("tr")[i].find_all("td")[1].text)
        
        currentTable = [currentProfit,currentTakeProfit]
        
        ProfitAndConditionsTable.append(currentTable)
    
    return(ProfitAndConditionsTable)
    


#######START OPTIMIZATION:

optimizationResults = []
totalMonthRange = 120
##############Create a step optimization:
for sss in range(1,6):
    if(sss == 5):
        Step = 6
    else:
        Step = sss
        
    Year = 2008
    for zzz in range(0,totalMonthRange,Step): 
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
             ]
        
        currentSymbolProfitAndConditionsTable = [Step,BeautifulSoup(open("OptimizationReport.htm").read()).find_all("tr")[0].text[7:13],firstThreeCurrentProfitAndConditionsTable]
        
        optimizationResults.append(currentSymbolProfitAndConditionsTable)
    

with open('TPBullOptimizationResults.data', 'rb') as filehandle:  
    # read the data as binary data stream
    TPBullOptimizationResults = pickle.load(filehandle)
    

#Bear BUILD place # of months in ==
TPBearOptimizationResultsOneMonth = []
for i in range(len(TPBearOptimizationResults)):
    if(TPBearOptimizationResults[i][0] == 1):
        TPBearOptimizationResultsOneMonth.append(TPBearOptimizationResults[i])
        
#Check if first of each applies to the others
TPBearOptimizationResultsOneMonthFirstSum = 0
Total = 0
TotalPositive = 0
totalTotalLosses = 0
for i in range(len(TPBearOptimizationResultsOneMonth)-1):
    currentBest = TPBearOptimizationResultsOneMonth[i][2][0][1]
    for x in range(len(TPBearOptimizationResultsOneMonth[i][2])):
        if(TPBearOptimizationResultsOneMonth[i+1][2][x][1] == currentBest):
            TPBearOptimizationResultsOneMonthFirstSum  += TPBearOptimizationResultsOneMonth[i+1][2][x][0]
            Total +=1
            if(TPBearOptimizationResultsOneMonth[i+1][2][x][0] > 0):
                TotalPositive += 1
            if(TPBearOptimizationResultsOneMonth[i+1][2][x][0] < -400):
                totalTotalLosses += 1                
    
print(TPBearOptimizationResultsOneMonthFirstSum)

#BULLL BUILD place # of months in == 
TPBullOptimizationResultsOneMonth = []
for i in range(len(TPBullOptimizationResults)):
    if(TPBullOptimizationResults[i][0] == 1):
        TPBullOptimizationResultsOneMonth.append(TPBullOptimizationResults[i])
        
#Check if first of each applies to the others
TPBullOptimizationResultsOneMonthFirstSum = 0
Total = 0
TotalPositive = 0
for i in range(len(TPBullOptimizationResultsOneMonth)-1):
    currentBest = TPBullOptimizationResultsOneMonth[i][2][0][1]
    for x in range(len(TPBullOptimizationResultsOneMonth[i][2])):
        if(TPBullOptimizationResultsOneMonth[i+1][2][x][1] == currentBest):
            TPBullOptimizationResultsOneMonthFirstSum  += TPBullOptimizationResultsOneMonth[i+1][2][x][0]
            Total += 1
            if(TPBullOptimizationResultsOneMonth[i+1][2][x][0] > 0):
                TotalPositive += 1
    
print(TPBullOptimizationResultsOneMonthFirstSum)