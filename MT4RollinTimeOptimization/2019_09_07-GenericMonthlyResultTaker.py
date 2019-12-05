# -*- coding: utf-8 -*-
"""
Created on Sat Sep  7 15:08:49 2019

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
    soup = BeautifulSoup(open("StrategyTester.htm").read())
    ProfitAndConditionsTable = [];
    symbol = soup.find_all("tr")[0].find_all("td")[1].text[0:6]
    profit = soup.find_all("tr")[9].find_all("td")[1].text
    maxLoss = soup.find_all("tr")[18].find_all("td")[4].text
    maxLoss = maxLoss[0:maxLoss.find("(")-1]
    
    ProfitAndConditionsTable = [symbol,profit,maxLoss]
    return(ProfitAndConditionsTable)
    
    
profitAndConditionsTable = []
totalMonthRange = 12
Year = 2017
Step = 1
for zzz in range(0,totalMonthRange,1): 
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
        profitAndConditionsTable.append(currentProfitAndConditionsTable)
        