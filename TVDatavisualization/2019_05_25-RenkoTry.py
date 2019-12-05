# -*- coding: utf-8 -*-
"""
Created on Tue May 21 21:05:19 2019

@author: gvega
"""
import os
import pandas as pd
import numpy as np
import csv

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TVDatavisualization')


SymbolNameArray = ["CHFJPY240","EURCAD240","EURCHF240","EURGBP240","EURJPY240","EURUSD240",
                   "GBPCAD240","GBPCHF240","GBPJPY240","GBPUSD240","USDCAD240","USDCHF240","USDJPY240",
                   "CADCHF240","CADJPY240"]

DB = pd.read_csv(SymbolNameArray[0]+'.csv', header=None)

def determinePipSize(Price):
    DigitLength = len(str(Price))
    if( (Price / 10) < 1    ):        
        PipSize = .1**(DigitLength-2)
    
    elif( Price / 100 < 1):
        PipSize = .1**(DigitLength-3)
    elif( Price / 1000 < 1):
        PipSize = .1**(DigitLength-4)
    elif( Price / 10000 < 1):
        PipSize = .1**(DigitLength-5)
        
    return PipSize

def BuildDateArray(DB):
    DateArray = [];
    for i in range(0,len(DB[0])):
        DateArray.append(DB[0][i] +" "+ DB[1][i])
    
    return DateArray

def BuildOHLCArray(DB):
    OHLCArray = DB[[2, 3, 4, 5]];
    return OHLCArray

def BuildRenko(DateArray,OHLCArray,CandleBodySize):
    RenkoOHLCArray = []
    RenkoOHLC = [OHLCArray[2][0],OHLCArray[3][0],OHLCArray[4][0],OHLCArray[5][0]]
    LastClose = OHLCArray[5][0]
    RenkoDateOHLC = [DateArray[0], RenkoOHLC]
    RenkoOHLCArray.append(RenkoDateOHLC)
    LastClose = OHLCArray[5][0]
    OpenPrice = OHLCArray[2][0]
    
    if(determinePipSize(OHLCArray[2][0]) == determinePipSize(OHLCArray[2][10])):
        PipSize = determinePipSize(OHLCArray[2][0])
        CandleSize = PipSize * CandleBodySize
    else:
        CandleSize = determinePipSize(OHLCArray[2][20]) * CandleBodySize
        
    for i in range(0,len(DateArray)):
        n = len(RenkoOHLCArray)-1
        if(RenkoOHLCArray[n][1][0] > RenkoOHLCArray[n][1][3]):
            PreviousCandleColor = "RED"
        else: PreviousCandleColor = "GREEN"
    
        if( (PreviousCandleColor == "RED") and (LastClose < OHLCArray[5][i] )  
            and ( abs(OHLCArray[5][i] - LastClose) > CandleSize*2 )
            ):
            OpenPrice = LastClose + CandleSize
            ClosePrice = OHLCArray[5][i]
            MinPrice = OpenPrice
            MaxPrice = ClosePrice
            RenkoOHLC = [OpenPrice,MaxPrice, MinPrice, ClosePrice]
            RenkoDateOHLC = [DateArray[i],RenkoOHLC]
            RenkoOHLCArray.append(RenkoDateOHLC)
            LastClose = ClosePrice
        elif (  (PreviousCandleColor == "GREEN") and (LastClose > OHLCArray[5][i] )
                and ( abs(OHLCArray[5][i] - LastClose) > CandleSize*2 )    
            ):            
            OpenPrice = LastClose - CandleSize
            ClosePrice = OHLCArray[5][i]
            MinPrice = ClosePrice
            MaxPrice = OpenPrice
            RenkoOHLC = [OpenPrice,MaxPrice, MinPrice, ClosePrice]
            RenkoDateOHLC = [DateArray[i],RenkoOHLC]
            RenkoOHLCArray.append(RenkoDateOHLC)
            LastClose = ClosePrice    
            
        elif( abs(OHLCArray[5][i] - LastClose) > CandleSize ):
            OpenPrice = LastClose
            ClosePrice = OHLCArray[5][i]
            MinPrice = ClosePrice
            MaxPrice = OpenPrice
            RenkoOHLC = [OpenPrice,MaxPrice, MinPrice, ClosePrice]
            RenkoDateOHLC = [DateArray[i],RenkoOHLC]
            RenkoOHLCArray.append(RenkoDateOHLC)
            LastClose = ClosePrice             
            
            
            
    return RenkoOHLCArray
        



    
RenkoArray = BuildRenko(BuildDateArray(DB),BuildOHLCArray(DB),200)

RenkoArrayPandas = pd.DataFrame(RenkoArray)  

def NextCandleSameColorProbability(RenkoArray):
    AccuracyArray = []
    for i in range(1,len(RenkoArray)):
        if( ((RenkoArray[i-1][1][0]) < (RenkoArray[i-1][1][3])) and ((RenkoArray[i][1][0]) < (RenkoArray[i][1][3]))   ):
            AccuracyArray.append(1)
        elif( ((RenkoArray[i-1][1][0]) > (RenkoArray[i-1][1][3])) and ((RenkoArray[i][1][0]) > (RenkoArray[i][1][3]))   ):
            AccuracyArray.append(1)
        else:
            AccuracyArray.append(0)
        
    Average = sum(AccuracyArray) / len(AccuracyArray)
    
    return Average
  
def GetRenkoOpenPrices(RenkoArray):
    RenkoOpen = []
    for i in range(0,len(RenkoArray)):
        RenkoOpen.append(RenkoArray[i][1][0])
        
    return RenkoOpen

  
def GetRenkoClosePrices(RenkoArray):
    RenkoClose = []
    for i in range(0,len(RenkoArray)):
        RenkoClose.append(RenkoArray[i][1][3])
        
    return RenkoClose

def exportRenkoOpenAndCloseCsv(RenkoOpen,RenkoClose):
    RenkoOpenPandas = pd.DataFrame(RenkoOpen)
    RenkoClosePandas = pd.DataFrame(RenkoClose)
    RenkoOpenPandas.to_csv('RenkoOpen.csv',index = False)
    RenkoClosePandas.to_csv('RenkoClose.csv',index = False)
    

def AllSymbolProbabilityAverage(SymbolNameArray,CandleBodySize):
    AverageArray = []
    for i in range(0,len(SymbolNameArray)):        
        print(  (1/len(SymbolNameArray))*i , "%" )
        
        DB = pd.read_csv(SymbolNameArray[i]+'.csv', header=None)
        OHLCArray = BuildOHLCArray(DB)
        DateArray = BuildDateArray(DB)
        RenkoArray = BuildRenko(DateArray,OHLCArray,CandleBodySize)
        CurrentAverage = NextCandleSameColorProbability(RenkoArray)
        AverageArray.append(CurrentAverage)
        print(SymbolNameArray[i], " ",CurrentAverage)
    average = sum(AverageArray)/len(AverageArray)
    return average
        

def RenkoArrayToCSV(RenkoArray):
    RenkoOpen = []
    for i in range(0,len(RenkoArray)):
        RenkoOpen.append(RenkoArray[i][1][0])
    RenkoClose = []
    for i in range(0,len(RenkoArray)):
        RenkoClose.append(RenkoArray[i][1][3])
    RenkoMax = []
    for i in range(0,len(RenkoArray)):
        RenkoMax.append(RenkoArray[i][1][1])
    RenkoMin = []
    for i in range(0,len(RenkoArray)):
        RenkoMin.append(RenkoArray[i][1][2])
    RenkoDate = []
    for i in range(0,len(RenkoArray)):
        RenkoDate.append(RenkoArray[i][0])    
    
    RenkoDatePandas = pd.DataFrame(RenkoDate)
    RenkoOpenPandas = pd.DataFrame(RenkoOpen)
    RenkoClosePandas = pd.DataFrame(RenkoClose)
    RenkoMaxPandas = pd.DataFrame(RenkoMax)
    RenkoMinPandas = pd.DataFrame(RenkoMin)    
    
    RenkoDatePandas.to_csv('RenkoDate.csv',index = False)
    RenkoMaxPandas.to_csv('RenkoMax.csv',index = False)
    RenkoMinPandas.to_csv('RenkoMin.csv',index = False)
    RenkoOpenPandas.to_csv('RenkoOpen.csv',index = False)
    RenkoClosePandas.to_csv('RenkoClose.csv',index = False)
    