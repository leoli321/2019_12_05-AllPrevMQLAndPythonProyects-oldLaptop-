# -*- coding: utf-8 -*-
"""
Created on Tue Aug 27 10:02:37 2019

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
        currentTPStart = str(soup.find_all("tr")[i].find_all("td")[0]).find("bullOrBearBias=") + 15
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
expertAdvisorPosition = [693,147]


totalMonthRange = 150
Year = 2006
Step = 1
OriginalAccountBalance = 1000 #Coordinar esta con el MQ4 code.
newAccountBalance = OriginalAccountBalance
savedBalance = 0
for zzz in range(0,totalMonthRange,Step): 
    
    if(newAccountBalance < 100):
        Bankrupt = str(Year) + "/" +str(ToMonth)
        print(Bankrupt)
        print(savedBalance)
        if(savedBalance > OriginalAccountBalance):
            newAccountBalance = OriginalAccountBalance
            savedBalance -= newAccountBalance
        else:    
            break
    
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
    
    #SET ACCOUNT BALANCE
    pyautogui.click(expertPropertiesPosition[0],expertPropertiesPosition[1])
    time.sleep(1)
    pyautogui.typewrite(str(newAccountBalance))
    time.sleep(1)
    pyautogui.press('enter')   
    
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
    
    currentProfitAndConditions = getProfitAndConditionsTable() 

    #Add to account
    if(zzz == 0):
        currentProfitAndConditions.sort()
        BestOptim = currentProfitAndConditions[len(currentProfitAndConditions)-1][1]
    else:
        currentProfitAndConditions.sort()
        for i in range(len(currentProfitAndConditions)):
            if(currentProfitAndConditions[i][1] == BestOptim):
                AccountProfit = currentProfitAndConditions[i][0]
        BestOptim = currentProfitAndConditions[len(currentProfitAndConditions)-1][1]
        newAccountBalance += (AccountProfit)
        
    ####AGREGAR QUE SI LLEGAS A X DINERO. PONER EN FONDO DE RESERVA.
    if(newAccountBalance > OriginalAccountBalance * 2):
        savedBalance += (newAccountBalance * .2)*2 #realmente es *2 porque le quitas a los dos.
        #Pero lo dejo así para margen de error.
        newAccountBalance = newAccountBalance * .8    