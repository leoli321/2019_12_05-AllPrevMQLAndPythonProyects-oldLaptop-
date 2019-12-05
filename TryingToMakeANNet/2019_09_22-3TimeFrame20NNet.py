# -*- coding: utf-8 -*-
"""
Created on Sun Sep 22 18:58:37 2019

@author: gvega
"""

import os
import pandas as pd
import random
import datetime

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TryingToMakeANNet')



database4H = pd.read_csv("CHFJPY240.csv", header = None)
database1D = pd.read_csv("CHFJPY1440.csv", header = None)
database1W = pd.read_csv("CHFJPY10080.csv", header = None)

def passToTimeMode(database):
    for i in range(0,len(database)):
        database[0][i] = datetime.datetime.strptime((database[0][i]+" "+database[1][i]),'%Y.%m.%d %H:%M')
        if i%2000 == 0:
            print(i/len(database),"%")
    return(database)

database4H = passToTimeMode(database4H)
database1D = passToTimeMode(database1D)
database1W = passToTimeMode(database1W)

def nnetDesition(arr4H,arr1D,arr1W,nnetWeights,orderOpen):
    nnetIndex = 0
    layer1MultiplicationResults = []
    for i in range(len(arr4H)):
        layer1MultiplicationResults.append(arr4H[i] * nnetWeights[nnetIndex])
        nnetIndex += 1
    for i in range(len(arr1D)):
        layer1MultiplicationResults.append(arr1D[i] * nnetWeights[nnetIndex])
        nnetIndex += 1
    for i in range(len(arr1W)):
        layer1MultiplicationResults.append(arr1W[i] * nnetWeights[nnetIndex])
        nnetIndex += 1
    
    desition = sum(layer1MultiplicationResults) + nnetWeights[nnetIndex]*orderOpen
    if(desition > 1):
        nnetDesition = 1
    elif(desition < -1):
        nnetDesition = -1
    else:
        nnetDesition = 0
    return(nnetDesition)
    
def retrainNNet(nnetWeights,result):
    if(result == 0):
        for i in range(len(nnetWeights)):
            if(nnetWeights[i] > 10):
                nnetWeights[i] = random.uniform(-1,1)
            elif(nnetWeights[i] < -10):
                nnetWeights[i] = random.uniform(-1,1)
            nnetWeights[i] += random.uniform(-1,1)
    
    return(nnetWeights)


nnetWeights = [0]*61


globalProfitArray = []
orderOpen = 0
counter = 0
trades = 0
globalProfit = 0
profit = 0
#Train in each hour. we gotta loop this
#First day is 2016_12_10
prevH4Index = 200
h4Index = 0
prevWeekIndex = 0
weekIndex = 0
for massive in range(0,1000000):
    print("GLOBALPROFIT: ",globalProfit)
    print(massive/1000000 * 100,"%")
    globalProfitArray.append(globalProfit)
    
    prevH4Index = 200
    h4Index = 0
    prevWeekIndex = 0
    weekIndex = 0
    orderOpen = 0
    counter = 0
    trades = 0
    globalProfit = 0
    profit = 0
    
    
    rangeStart = random.uniform(1,2000)
    rangeEnd = rangeStart + random.uniform(1000,2000)
    if(rangeEnd > 3200):
        rangeEnd = 3200
    
    for zzz in range(int(rangeStart),int(rangeEnd)):
        dayIndex = zzz
    
        day = database1D[0][dayIndex]
        for i in range(len(database4H)):
            if(database4H[0][prevH4Index+i] == day):
                h4Index = prevH4Index+i
                prevH4Index = h4Index
                break
            elif(database4H[0][prevH4Index+i] > day):
                h4Index = prevH4Index+i
                prevH4Index = h4Index
                break
            
        for ww in range(0,len(database1W)-1):
            if(database1W[0][prevWeekIndex+ww] < day):
                weekIndex = prevWeekIndex+ww
            if(database1W[0][prevWeekIndex+ww] > day):
                prevWeekIndex = weekIndex
                break
            
        
        array4H = database4H[5][h4Index-20:h4Index]
        array1D = database1D[5][dayIndex-21:dayIndex-1]
        array1W = database1W[5][weekIndex-19:weekIndex+1]
        
        arr4H = []
        arr1D = []
        arr1W = []
                
        for i in array4H:
            arr4H.append(i)
        for i in array1D:
            arr1D.append(i)
        for i in array1W:
            arr1W.append(i)
        
        desition = nnetDesition(arr4H,arr1D,arr1W,nnetWeights,orderOpen)
        if(orderOpen == 0):
            if(desition==1):
                buyPrice = arr4H[len(arr4H)-1]
                orderOpen = 1
                trades = 0
                #print("buy, ",day)  AGREGAR ESTO A ARRAY
            if(desition==-1):
                sellPrice = arr4H[len(arr4H)-1]
                orderOpen = -1
                trades = 0
                #print("buy, ",day)
        elif(orderOpen == 1):
            if(desition==-1):
                profit = arr4H[len(arr4H)-1] - buyPrice
                globalProfit += profit
                trades +=1
                #print("CloseBuy, ",day, "Profit: ", profit)
                orderOpen = 0
                if(profit < 0):
                    nnetWeights = retrainNNet(nnetWeights,0)
        elif(orderOpen == -1):
            if(desition == 1):
                profit = sellPrice - arr4H[len(arr4H)-1]
                globalProfit += profit
                trades +=1
                #print("CloseSell, ",day, "Profit: ", profit)
                orderOpen = 0
                if(profit < 0):
                    nnetWeights = retrainNNet(nnetWeights,0)
                
        
        counter += 1
        if(counter > 80 and trades == 0):
            nnetWeights = retrainNNet(nnetWeights,0)
        
        if(zzz == int(rangeEnd)-1):
            if(orderOpen == 1):
                profit = arr4H[len(arr4H)-1] - buyPrice
                globalProfit += profit
                trades +=1
                #print("CloseBuy, ",day, "Profit: ", profit)
                orderOpen = 0
                if(profit < 0):
                    nnetWeights = retrainNNet(nnetWeights,0)
            elif(orderOpen == -1):
                profit = sellPrice - arr4H[len(arr4H)-1]
                globalProfit += profit
                trades +=1
                #print("CloseSell, ",day, "Profit: ", profit)
                orderOpen = 0
                if(profit < 0):
                    nnetWeights = retrainNNet(nnetWeights,0)
                
        
        
    
    

        