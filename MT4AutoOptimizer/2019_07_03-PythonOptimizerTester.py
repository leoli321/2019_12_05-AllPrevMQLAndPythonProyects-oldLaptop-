# -*- coding: utf-8 -*-
"""
Created on Wed Jul  3 17:45:22 2019

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

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\MT4AutoOptimizer')



def GetTable(soup):
    ProfitArray = [];
    
    for i in range(6,len(soup.find_all("tr"))):
         Wick_PercentageStartString = str(soup.find_all("tr")[i]).find("Wick_Percentage=") + 16
         WickPercentageString = str(soup.find_all("tr")[i])[Wick_PercentageStartString:Wick_PercentageStartString+4]  
         WickPercentageArray.append(WickPercentageString)
         
         ###ESTO HAY QUE PONERLO DE SUS RESPECTIVOS###########
         StopLossStringStart = str(soup.find_all("tr")[i]).find("StopLoss=") + len("StopLoss=")
         StopLossStringEnd = str(soup.find_all("tr")[i])[StopLossStringStart:].find(";") + StopLossStringStart 
         StopLoss = str(soup.find_all("tr")[i])[StopLossStringStart:StopLossStringEnd]
         StopLossArray.append(StopLoss)
        
         TakeProfitStringStart = str(soup.find_all("tr")[i]).find("TakeProfit=") + len("TakeProfit=")
         TakeProfitStringEnd = str(soup.find_all("tr")[i])[TakeProfitStringStart:].find(";") + TakeProfitStringStart 
         TakeProfit = str(soup.find_all("tr")[i])[TakeProfitStringStart:TakeProfitStringEnd]
         TakeProfitArray.append(TakeProfit)
         


    for i in range(18,len(soup.find_all("td"))):    
         if(i%7 == 4):
             ProfitArray.append(soup.find_all("td")[i].text)
    
    Table = [WickPercentageArray,StopLossArray,TakeProfitArray,ProfitArray]
                  
    return Table



def OptimizeByMonth(SleepTime):
    FromDateCoordinatesYear = [287,724]
    ToDateCoordinatesYear = [551,721]
    IniciarCoordinates = [657,787]
    ResultsCoordinates = [155,820]
    RepasoCoordinates = [42,630]
    MinimizeCoordinates = [1476,6]
    AjustedCoordinates = [41,816]
    SymbolBarPosition = [424,658]
    FullTable = []

    
    for i in range(0,11):
        
        Screen = PIL.ImageGrab.grab()
        PixelValue = Screen.getpixel((SymbolBarPosition[0], SymbolBarPosition[1]))         
        if(PixelValue[0] == 204):
            pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
            time.sleep(10)
        pyautogui.click(FromDateCoordinatesYear[0], FromDateCoordinatesYear[1])
        time.sleep(1)
        pyautogui.press('right')
        time.sleep(1)
        pyautogui.typewrite(str(i+1)) 
        time.sleep(1)
        pyautogui.click(ToDateCoordinatesYear[0], ToDateCoordinatesYear[1])
        time.sleep(1)
        pyautogui.press('right')
        time.sleep(1)
        pyautogui.typewrite(str(i+2)) 
        time.sleep(1)
        pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
        time.sleep(SleepTime)
        pyautogui.click(IniciarCoordinates[0], IniciarCoordinates[1])
        time.sleep(1)
        pyautogui.click(ResultsCoordinates[0], ResultsCoordinates[1])
        time.sleep(1)
        pyautogui.click(RepasoCoordinates[0], RepasoCoordinates[1])
        time.sleep(5)
        pyautogui.rightClick(RepasoCoordinates[0], RepasoCoordinates[1])
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
        pyautogui.press('down')
        time.sleep(1)
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
        soup = BeautifulSoup(open("OptimizationReport.htm").read())
        SymbolString = soup.find_all("td")[1].text[0:6]
        LotSizeStringStart = str(soup.find_all("tr")[6]).find("lot_size=") + 9
        LotSizeStringEnd = str(soup.find_all("tr")[6])[LotSizeStringStart:].find(";") + LotSizeStringStart 
        lotSize = str(soup.find_all("tr")[6])[LotSizeStringStart:LotSizeStringEnd]
        
        currentTable = GetTable(soup)
        FullTable.append(currentTable)
        
    return(FullTable)
        

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





def GetProfitArray(FullTable,Filters):
    FilteredProfitArray = []
    for i in range(0,len(FullTable)):
        
        for n in range(0,len(FullTable[i][0])):
            if( (   float(FullTable[i][0][n]) < Filters[0]) and (float(FullTable[i][0][n]) > Filters[1]) and
               (  float(FullTable[i][1][n]) < Filters[2]) and (float(FullTable[i][1][n]) > Filters[3]) and 
                (float(FullTable[i][2][n]) < Filters[4]) and (float(FullTable[i][2][n]) > Filters[5])
                    ):
                FilteredProfitArray.append(float(FullTable[i][3][n]))

    return(FilteredProfitArray)


#####UseFunctions


###ManyYearArray
YearlyFullTable = []
for i in range(2013,2019):
    ChangeYear(i)
    FullTable = OptimizeByMonth(200)
    for n in range(0,len(FullTable)):
        YearlyFullTable.append(FullTable[n])
        
    savedPickleFileString = "Table" + str(i) + "DataLS" + str(.03)        
    with open(savedPickleFileString, 'wb') as filehandle:  
        pickle.dump(FullTable, filehandle)


#SavePickle.
    with open("YearlyFullTableGBPJPY2013to2018", 'wb') as filehandle:  
        pickle.dump(YearlyFullTable, filehandle)        
        
#PICKLE WITH Flexible String      
Year = 2018
LotSize = .03
savedPickleFileString = "Table" + str(Year) + "DataLS" + str(LotSize)

with open(savedPickleFileString, 'wb') as filehandle:  
    # store the data as binary data stream
    pickle.dump(FullTable, filehandle)
    

###PICKLE SAVE LIST
with open('FullTable2018LS03.data', 'wb') as filehandle:  
    # store the data as binary data stream
    pickle.dump(FullTable, filehandle)
    
with open('FullTable2014.data', 'rb') as filehandle:  
    # read the data as binary data stream
    FullTable = pickle.load(filehandle)
#################END PICKLE



###########################################


#ax = sns.boxplot(data=FilteredProfitArray)


def getMaxAndMinNormalizedHighSum(FullTable):
    currentMax = -1000
    currentMin = 1000
    
    for i in range(0,len(FullTable)):
        currentSum = 0
        for n in range(0, len(FullTable[i][3])):
          currentSum += float(FullTable[i][3][n])
        
        if(currentMax < currentSum):
            currentMax = currentSum
            
        if(currentMin > currentSum):
            currentMin = currentSum            
                
    return([currentMax,currentMin])

def getMaxAndMinNormalizedStDev(FullTable):
    currentMax = -1000
    currentMin = 1000
    
    
    for i in range(0,len(FullTable)):
        floatArray = []
        for n in range(0, len(FullTable[i][3])):
          floatArray.append(float(FullTable[i][3][n]))
          
        currentstdev = statistics.stdev(floatArray)
        
        if(currentMax < currentstdev):
            currentMax = currentstdev
            
        if(currentMin > currentstdev):
            currentMin = currentstdev
                
    return([currentMax,currentMin])
    
    
def getMaxAndMinNormalizedMean(FullTable):
    currentMax = -1000
    currentMin = 1000
    
    
    for i in range(0,len(FullTable)):
        floatArray = []
        for n in range(0, len(FullTable[i][3])):
          floatArray.append(float(FullTable[i][3][n]))
          
        currentMean = statistics.mean(floatArray)
        
        if(currentMax < currentMean):
            currentMax = currentMean
            
        if(currentMin > currentMean):
            currentMin = currentMean
                
    return([currentMax,currentMin])    
    

def getMaxAndMinNormalizedMedian(FullTable):
    currentMax = -1000
    currentMin = 1000
    
    
    for i in range(0,len(FullTable)):
        floatArray = []
        for n in range(0, len(FullTable[i][3])):
          floatArray.append(float(FullTable[i][3][n]))
          
        currentMedian = statistics.median(floatArray)
        
        if(currentMax < currentMedian):
            currentMax = currentMedian
            
        if(currentMin > currentMedian):
            currentMin = currentMedian
                
    return([currentMax,currentMin])    

def PlaceInScale(value,Max):
    ScaledNum = (value/Max)
    return(ScaledNum)
    

def OptimizeFilters(FullTable,randomOptimNumber):
    ProfitSumMax = getMaxAndMinNormalizedHighSum(FullTable)[0]
    ProfitStDevMin = getMaxAndMinNormalizedStDev(FullTable)[1]
    ProfitMeanMax = getMaxAndMinNormalizedMean(FullTable)[0]
    ProfitMedianMax = getMaxAndMinNormalizedMedian(FullTable)[0]
    
    MaxProfit = -100
    MaxProfitFiltersArray = [];
    for i in range(0,randomOptimNumber):
        currentWickPercentage = random.randint(1,200)/100
        currentMaxStopLoss = random.randint(1,180)*-1
        currentMinStopLoss = random.randint(-200,currentMaxStopLoss)
        currentTakeProfit = random.randint(0,200)
    
        Filters = [currentWickPercentage,0,currentMaxStopLoss,currentMinStopLoss,currentTakeProfit,0]
        
        FilteredArray = GetProfitArray(FullTable,Filters)
        
        if(len(FilteredArray) > 2):
            SumMaxNormalized = PlaceInScale(sum(FilteredArray),ProfitSumMax)
            stdevNormalized = PlaceInScale(statistics.stdev(FilteredArray),ProfitStDevMin)
            meanNormalized = PlaceInScale(statistics.mean(FilteredArray),ProfitMeanMax)
            medianNormalized = PlaceInScale(statistics.median(FilteredArray),ProfitMedianMax)
            
            ProfitFunction = SumMaxNormalized*.5 + 1/stdevNormalized*.25 + meanNormalized*.15 + medianNormalized*.1
            
            if(MaxProfit < ProfitFunction):
                MaxProfit = ProfitFunction
                MaxProfitFiltersArray = Filters
        
        if(i%300==0):
            print(i)
            
    return(MaxProfitFiltersArray)
    
    

    
        