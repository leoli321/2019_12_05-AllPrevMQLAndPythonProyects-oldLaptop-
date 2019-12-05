# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 20:58:11 2019

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
        if(savedBalance > OriginalAccountBalance*2):
            newAccountBalance = OriginalAccountBalance
            savedBalance -= newAccountBalance*2
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


    #BEAR
    pyautogui.click(expertPropertiesPosition[0],expertPropertiesPosition[1])
    time.sleep(1)
    pyautogui.typewrite(str(newAccountBalance))
    time.sleep(1)
    pyautogui.press('enter')   

    
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
    
    currentBearProfitAndConditions = getProfitAndConditionsTable()
    
    #BULL ----------------------------------------------------------------------
    ##Pass to bull
    pyautogui.click(expertAdvisorPosition[0],expertAdvisorPosition[1])
    time.sleep(1)
    pyautogui.press("down")
    
    pyautogui.click(expertPropertiesPosition[0],expertPropertiesPosition[1])
    time.sleep(1)
    pyautogui.typewrite(str(newAccountBalance))
    time.sleep(1)
    pyautogui.press('enter')   

    
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
    
    currentBullProfitAndConditions = getProfitAndConditionsTable()
        
    
    
    pyautogui.click(expertAdvisorPosition[0],expertAdvisorPosition[1])
    time.sleep(1)
    pyautogui.press("up")
    
    if(zzz == 0):
        currentBullProfitAndConditions.sort()
        currentBearProfitAndConditions.sort()
        BestBearOptim = currentBearProfitAndConditions[len(currentBearProfitAndConditions)-1][1]
        BestBullOptim = currentBullProfitAndConditions[len(currentBullProfitAndConditions)-1][1]
    else:
        currentBullProfitAndConditions.sort()
        currentBearProfitAndConditions.sort()
        for i in range(len(currentBullProfitAndConditions)):
            if(currentBullProfitAndConditions[i][1] == BestBullOptim):
                BullAccountProfit = currentBullProfitAndConditions[i][0]
            if(currentBearProfitAndConditions[i][1] == BestBearOptim):
                BearAccountProfit = currentBearProfitAndConditions[i][0]
        BestBearOptim = currentBearProfitAndConditions[len(currentBearProfitAndConditions)-1][1]
        BestBullOptim = currentBullProfitAndConditions[len(currentBullProfitAndConditions)-1][1]
        newAccountBalance += (BearAccountProfit+BullAccountProfit)/2
        
    ####AGREGAR QUE SI LLEGAS A X DINERO. PONER EN FONDO DE RESERVA.
    if(newAccountBalance > OriginalAccountBalance * 2):
        savedBalance += (newAccountBalance * .2)*2 #realmente es *2 porque le quitas a los dos.
        #Pero lo dejo así para margen de error.
        newAccountBalance = newAccountBalance * .8