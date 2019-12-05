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


SymbolNameArray = ["CHFJPY5","EURCAD5","EURCHF5","EURGBP5","EURJPY5","EURUSD5",
                   "GBPCAD5","GBPCHF5","GBPJPY5","GBPUSD5","USDCAD5","USDCHF5","USDJPY5",
                   "CADCHF5","CADJPY5"]

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
    LastClose = OHLCArray[2][0]
    
    if(determinePipSize(OHLCArray[2][0]) == determinePipSize(OHLCArray[2][10])):
        PipSize = determinePipSize(OHLCArray[2][0])
        CandleSize = PipSize * CandleBodySize
    else:
        CandleSize = determinePipSize(OHLCArray[2][20]) * CandleBodySize
    
    for i in range(0,len(DateArray)):
        if(abs(LastClose - OHLCArray[2][i]) > CandleSize):
            OpenPrice = LastClose
            ClosePrice = OHLCArray[2][i]
            
            if( (LastClose - OHLCArray[2][i]) > 0 ):
                MaxPrice = OpenPrice
                MinPrice = ClosePrice
            elif( (LastClose - OHLCArray[2][i]) < 0 ):
                MaxPrice = ClosePrice
                MinPrice = OpenPrice
            
            RenkoOHLC = [OpenPrice, MaxPrice, MinPrice, ClosePrice]
            
            RenkoDateOHLC = [DateArray[i],RenkoOHLC]
            
            LastClose = OHLCArray[2][i]
            
            RenkoOHLCArray.append(RenkoDateOHLC)
    
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
    
    average = sum(AverageArray)/len(AverageArray)
    return average
        