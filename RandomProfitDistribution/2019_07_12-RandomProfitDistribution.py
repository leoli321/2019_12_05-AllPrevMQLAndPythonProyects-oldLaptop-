# -*- coding: utf-8 -*-
"""
Created on Fri Jul 12 09:35:07 2019

@author: gvega
"""

import os
import pandas as pd
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from datetime import datetime
import random

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\RandomProfitDistribution')



DB = pd.read_csv("USDJPY240"+'.csv', header=None)

FromTimeFrame = datetime.strptime('2018.01.01', '%Y.%m.%d')
MaxPipsProfitArray = []

USDJPYPipSize = .001

Spread = USDJPYPipSize * 5

for i in range(0,len(DB)):
    if(FromTimeFrame < datetime.strptime(DB[0][i], '%Y.%m.%d')):
        RandomBuyOrSell = random.random()
        if(RandomBuyOrSell < .5):
            #BUY
            OpenPrice = DB[2][i];
            HighPrice = DB[3][i];
            MaxPipsProfitArray.append(HighPrice - OpenPrice - Spread)
        if(RandomBuyOrSell > .5):
            #SELL
            OpenPrice = DB[2][i];
            LowPrice = DB[4][i];
            MaxPipsProfitArray.append(OpenPrice - LowPrice - Spread)
            
    
FilteredMaxPipsProfitArray = []       
for i in range(0,len(MaxPipsProfitArray)):
    if( (MaxPipsProfitArray[i] < .3) and ((MaxPipsProfitArray[i] > 0))   ):
        FilteredMaxPipsProfitArray.append(MaxPipsProfitArray[i])


plt.hist(MaxPipsProfitArray, bins = "auto", facecolor='blue', alpha=0.9)
plt.hist(FilteredMaxPipsProfitArray, bins = 2, facecolor='blue', alpha=0.9)

def ProfitDeciding(DB,FromTimeFrame,USDJPYPipSize,SpreadPipSize, TakeProfit, StopLoss):
    MaxPipsProfitArray = []
    Spread = USDJPYPipSize * SpreadPipSize
    AccountProfit = 0
    n = 0
    for i in range(0,len(DB)):
        if(FromTimeFrame < datetime.strptime(DB[0][i], '%Y.%m.%d')):
            RandomBuyOrSell = random.random()
            if(RandomBuyOrSell < .5):
                #BUY
                OrderType = 0
                OpenPrice = DB[2][i]
                HighPrice = DB[3][i]
                MaxPipsProfitArray.append(HighPrice - OpenPrice - Spread)
            if(RandomBuyOrSell > .5):
                #SELL
                OrderType = 1
                OpenPrice = DB[2][i]
                LowPrice = DB[4][i]
                MaxPipsProfitArray.append(OpenPrice - LowPrice - Spread)
            
            #StopLoss
            if( (MaxPipsProfitArray[n] < 0) and (OrderType == 0)   ):
                CandlePipLoss = DB[2][i] - DB[4][i]
                if( CandlePipLoss > StopLoss):
                    LostPips = StopLoss
                else: LostPips = CandlePipLoss
                AccountProfit -= LostPips
            
            if( (MaxPipsProfitArray[n] < 0) and (OrderType == 1)   ):
                CandlePipLoss = DB[3][i] - DB[2][i]
                if( CandlePipLoss > StopLoss):
                    LostPips = StopLoss
                else: LostPips = CandlePipLoss
                AccountProfit -= LostPips
            #TAKEPROFIT
            if( (MaxPipsProfitArray[n] > 0) and (OrderType == 0)   ):
                if( MaxPipsProfitArray[n] > TakeProfit):
                    WonPips = TakeProfit
                else: WonPips = DB[5][i] - DB[2][i] #AQUI DICE WON PIPS PERO REALMENTE SON LAS QUE HUBIERAN Ganado/Perdido
                AccountProfit += WonPips
            
            if( (MaxPipsProfitArray[n] > 0) and (OrderType == 1)   ):
                if( MaxPipsProfitArray[n] > TakeProfit):
                    WonPips = TakeProfit
                else: WonPips = (DB[5][i] - DB[2][i])*-1 #AQUI DICE WON PIPS PERO REALMENTE SON LAS QUE HUBIERAN Ganado/Perdido
                AccountProfit += WonPips
            
            n +=1
                
                
    return(AccountProfit)
                

def OptimizeProfitSLAndTP(DB,FromTimeFrame,USDJPYPipSize,SpreadPipSize,OptimLength):
    AccountProfitArray = []
    TPArray = []
    SLArray = []
    OptimizeArray = []
    
    for i in range(0,OptimLength):
        TP = random.randint(1,1000)/1000
        SL = random.randint(SpreadPipSize,1000)/1000
        currentProfit = ProfitDeciding(DB,FromTimeFrame,USDJPYPipSize,SpreadPipSize, TP, SL)
        AccountProfitArray.append(currentProfit)
        TPArray.append(TP)
        SLArray.append(SL)
        
    
    OptimizeArray.append(AccountProfitArray,TPArray,SLArray)
    
    return(OptimizeArray)
    
            
            
                
