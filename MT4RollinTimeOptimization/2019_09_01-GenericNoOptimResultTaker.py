# -*- coding: utf-8 -*-
"""
Created on Sun Sep  1 13:16:36 2019

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
import pandas as pd



os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\MT4RollinTimeOptimization')

def getProfitAndConditionsTable():    
    soup = BeautifulSoup(open("StrategyTester.htm").read())
    ProfitAndConditionsTable = [];
    symbol = soup.find_all("tr")[0].find_all("td")[1].text[0:6]
    profit = soup.find_all("tr")[9].find_all("td")[1].text
    maxLoss = soup.find_all("tr")[18].find_all("td")[4].text
    maxLoss = maxLoss[0:maxLoss.find("(")-1]
    
    ProfitAndConditionsTable = [symbol,profit,maxLoss]
    return(ProfitAndConditionsTable)
    
    
"""
Double monitor
"""
FromDatePosition = [287,233]
ToDatePosition = [547,233]
SymbolBarPosition = [680,178]
StartPosition = [1498,317]
ResultsPosition = [120,340]
RegistroPosition = [111,325]
minimizePosition = [2511,9]
adjustedPosition = [44,346]
expertPropertiesPosition = [1522,157]


totalYearRange = 3
Year = 2016
Step = 3

profitAndConditionsTable = []

for sss in range(0,15):
    if(sss > 0):
        pyautogui.click(SymbolBarPosition[0],SymbolBarPosition[1])
        time.sleep(1)
        pyautogui.press("down")
        time.sleep(1)
        pyautogui.press("enter")
    
        
    for zzz in range(0,totalYearRange,Step): 
        ##SET DATE
        pyautogui.click(FromDatePosition[0],FromDatePosition[1])
        time.sleep(1)
        pyautogui.typewrite(str(Year+zzz)) 
        time.sleep(1)
        
        pyautogui.click(ToDatePosition[0],ToDatePosition[1])
        time.sleep(1)
        pyautogui.typewrite(str(Year+Step+zzz))     
        
    #START
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
        pyautogui.click(ResultsPosition[0]+10, ResultsPosition[1]-100)
        time.sleep(1)
        pyautogui.rightClick(ResultsPosition[0]+10, ResultsPosition[1]-100)
        time.sleep(1)
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
        
        currentProfitAndConditions = getProfitAndConditionsTable()   
        currentProfitAndConditions.append(Year+zzz)
        profitAndConditionsTable.append(currentProfitAndConditions)
        

##Save as pickle
#with open('BollingerRSIStoch-Pt1-BollingerOutToIn.data', 'wb') as filehandle:  
     #store the data as binary data stream
 #    pickle.dump(profitAndConditionsTable, filehandle)
#OPEN PICKLE
"""
with open('bearOptimizationResults.data', 'rb') as filehandle:  
    # read the data as binary data stream
    optimizationResults = pickle.load(filehandle)
"""


#Database = pd.DataFrame(profitAndConditionsTable)
#Database.to_csv("profitAndConditionsTable.csv", index = False)

#now lets do some data processing
total = 0
for i in range(len(profitAndConditionsTable)):
    total += float(profitAndConditionsTable[i][1])
    



