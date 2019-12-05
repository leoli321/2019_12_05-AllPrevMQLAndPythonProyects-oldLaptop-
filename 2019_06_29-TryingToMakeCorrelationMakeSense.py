# -*- coding: utf-8 -*-
"""
Created on Sat Jun 29 20:11:20 2019

@author: gvega
"""

import os
import pandas as pd
import numpy as np
from random import randint
import random
from statistics import mode

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TVDatavisualization')


SymbolNameArray = ["GBPJPY240","GBPUSD240","USDJPY240"];
LotSizeOneCashArray = [1000,100000,1000]

DB = []
for i in range(0, len(SymbolNameArray)):
	DB.append(pd.read_csv(SymbolNameArray[i]+'.csv', header=None))


def GetCorrelationCoefficient(Array1,Array2,DatapointNum):
    sumX = 0
    sumY = 0
    sumXX = 0
    sumYY = 0
    sumXY = 0

    numberOfDatapoints = len(Array1) - DatapointNum

    for i in range(numberOfDatapoints,len(Array1)):
        sumXY += Array1[i]*Array2[i]
        
    for i in range(numberOfDatapoints,len(Array1)):
        sumX += Array1[i]
        
    for i in range(numberOfDatapoints,len(Array1)):
        sumY += Array2[i]
        
    for i in range(numberOfDatapoints,len(Array1)):
        sumXX += Array1[i]*Array1[i]
    
    for i in range(numberOfDatapoints,len(Array1)):
        sumYY += Array2[i]*Array2[i]      
        
    denominator = ((numberOfDatapoints+1)*sumXX - sumX*sumX) * ((numberOfDatapoints+1)*sumYY - sumY*sumY)
    
    corr = (((numberOfDatapoints+1) * sumXY) - sumX*sumY)/(denominator**.5)
    
    return corr


    

def getPipSizeRegression(Array1,Array2,WeightedCandleNum): #Based on the first DB of DB
    WeightsArray = []
    for i in range(len(Array1),0,-1):
        if( (   (i)  > (len(Array1)-WeightedCandleNum)) and (sum(WeightsArray) < 1)    ):
            CurrentWeight = (WeightedCandleNum-i)/len(Array1)
            WeightsArray.append(CurrentWeight)
        else: 
            WeightsArray.append(0)
    
    PipChangeDifferenceArray1 = []
    for i in range(1,len(Array1)):
        currentDifference = abs(Array1[i] - Array1[i-1])/Array1[i] * WeightsArray[i]             
        PipChangeDifferenceArray1.append(currentDifference)
    
    WeightedAverageDifferenceArray1 = sum(PipChangeDifferenceArray1)
    
        
    WeightsArray = []
    for i in range(len(Array2),0,-1):
        if( (   (i)  > (len(Array2)-WeightedCandleNum)) and (sum(WeightsArray) < 1)    ):
            CurrentWeight = (WeightedCandleNum-i)/len(Array2)
            WeightsArray.append(CurrentWeight)
        else: 
            WeightsArray.append(0)
    
    PipChangeDifferenceArray2 = []
    for i in range(1,len(Array2)):
        currentDifference = abs(Array2[i] - Array2[i-1])/Array2[i] * WeightsArray[i]             
        PipChangeDifferenceArray2.append(currentDifference)
    
    WeightedAverageDifferenceArray2 = sum(PipChangeDifferenceArray2)
    
    Relation = WeightedAverageDifferenceArray1 / WeightedAverageDifferenceArray2
    
    return Relation


            
def DeterminingBuySellLotSize(DB,OptimWeightArray):
    LotSizeArray = []
    LotSizeArray.append(1)
    for i in range(1,len(DB)):
        currentCorrelationCoefficient = GetCorrelationCoefficient(DB[0][5],DB[i][5],10000)
        currentRelation = getPipSizeRegression(DB[0][5],DB[i][5],1000) 
        
        currentLotSize = LotSizeArray[0]*abs(currentCorrelationCoefficient)*currentRelation*OptimWeightArray[i]
        
        LotSizeArray.append(currentLotSize)
        
    return(LotSizeArray)
        


def GetCorrelationCoefficientArray(DB):
    CorrelationCoefficientArray = []
    for i in range(0,len(DB)):
        CorrelationCoefficientArray.append(GetCorrelationCoefficient(DB[0][5],DB[i][5],10000))

    return(CorrelationCoefficientArray)
    

def GetRandomLotSizeArrayArray(DB,ArrayNumber):
    LotSizeArrayArray = [];
    currentWeightArray = [];
    
    for n in range(0, ArrayNumber):
        currentWeightArray.append(1)
        for i in range(0,len(DB)-1):
            currentWeightArray.append(random.uniform(0, 2));
        print(n)    
        
        LotSizeArrayArray.append( DeterminingBuySellLotSize(DB,currentWeightArray)   ) 
        currentWeightArray = [];
    
    return(LotSizeArrayArray)    




def TradeSimulation(DB,LotSizeArray,period,Past ,CorrelationCoefficientArray,LotSizeOneCashArray):
    ArrayLength = len(DB[0][5]) - 1
    TotalProfit = 0
    currentProfit = 0
    for i in range( (ArrayLength - period - Past),ArrayLength - Past):
        for n in range(0,len(DB)):
            currentCorrelationCoefficient = CorrelationCoefficientArray[n]
            if( currentCorrelationCoefficient >= 0     ):
                Direction = -1
            else : Direction = 1
            
            currentCashChangeLotSizeOne = LotSizeOneCashArray[n]
            spread = 3 ##Spread esta ligado a lot size, por ahora le pondre ese valor
            currentProfit += (DB[n][5][i+1] - DB[n][5][i])*Direction * currentCashChangeLotSizeOne * LotSizeArray[n] / 10 - spread #(El lotSize se hace .1)
            
            TotalProfit += currentProfit
            currentProfit = 0

        
        #print(TotalProfit)
        
    return(TotalProfit)
        

    
    

#WeightOptim
LotSizeArrayArray = GetRandomLotSizeArrayArray(DB,5000)

bestZsArray = []
FullTradeSimResultsArray = []
BestLotSizeArrayArray = []
for n in range(0,200):
    Past = int(random.uniform(0,3000))
    BestResult = 0
    for z in range(0,len(LotSizeArrayArray)):
        TradeSim = TradeSimulation(DB,LotSizeArrayArray[z],10,Past, GetCorrelationCoefficientArray(DB),LotSizeOneCashArray)
        if (TradeSim > BestResult):
            BestResult = TradeSim
            BestLotSizeArray = LotSizeArrayArray[z]
            BestZ= z    
        FullTradeSimResultsArray.append(TradeSim)
        
    BestLotSizeArrayArray.append(BestLotSizeArray)
    bestZsArray.append(BestZ)
    print(n)
        


mode(bestZsArray)
        
import csv

with open('LotSizeArrayArray.csv', 'wb') as myfile:
    wr = csv.writer(LotSizeArrayArray, quoting=csv.QUOTE_ALL)
    wr.writerow(mylist)
    
df.to_csv("./file.csv", sep=',',index=False)    