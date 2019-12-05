# -*- coding: utf-8 -*-
"""
Created on Sat Oct 12 19:23:30 2019

@author: gvega
"""

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os
from sklearn.svm import SVC
from plotly import graph_objs as go
import datetime




os.chdir(r'C:\\Users\gvega\Google Drive\MQL4 + Python\NNetTrendClassifier')


USDCHF15 = pd.read_csv("USDCHF15.csv", header = None)

for i in range(100,len(USDCHF15)):
    for z in range(i-100,i):
        for w in range(1,8):
            if(z == i-100 and w == 1):
                xArrayCurrent = int(USDCHF15[w][i][0:2])
            else:                
                if(w == 1):
                    xArrayCurrent = np.append(xArrayCurrent,int(USDCHF15[w][z][0:2]))
                elif(w == 8):
                    xArrayCurrent = np.append(xArrayCurrent,USDCHF15[5][z-20:z].mean())
                else:
                    xArrayCurrent = np.append(xArrayCurrent,USDCHF15[w][z])
    #AGREGAR SMA
    if(i == 100):
        xArray = [xArrayCurrent]
    else:    
        xArray = np.concatenate((xArray,[xArrayCurrent]))
    
    if(i%100 == 0):
        print("Percentage: ", i/len(USDCHF15)*100)
            
    
#Build graph for identification
#BRO JUST BUILD A TRAINER LIKE THIS.
    """
    Make a proper graph, and train yourself, you say UP or DOWN and
    check yourself.
    """
for x in range(2501,len(USDCHF15)): #es de 100 a len, pero lo pongo desde donde me quede
    current = USDCHF15[x-100:x+20]
    SMA = current[5].rolling(window=20).mean()
    plt.plot([z for z in range(120)],current[5],color = "g")
    plt.plot([z for z in range(120)],SMA, color = "orange")
    plt.plot([100,100],[min(current[5]),max(current[5])], color = "blue")
    plt.show()
    print("X = :", x)
    print("Desition: ")
    a = int(input())
    if(x == 100):
        yArray = a
    yArray = np.append(yArray,a)

#NOTE: 0 = Wait 1 = Buy/Hold 2 = SELL/Hold



#CHECK PREDICTIONS
a = 6950
current = USDCHF15[a-100:a+20]
SMA = current[5].rolling(window=20).mean()
plt.plot([z for z in range(120)],current[5],color = "g")
plt.plot([z for z in range(120)],SMA, color = "orange")
plt.plot([100,100],[min(current[5]),max(current[5])], color = "blue")
plt.show()

a = 1
b = 2
appendedArray = np.append(appendedArray,a)

arr1 = np.array([[1,2]])



X = np.array([[-1, -1], [-2, -1], [1, 1], [2, 1]])
y = np.array([1, 1, 2, 2])

# np.concatenate((X,arr1))  Adds, X and arr1, you have to assign it to a value

X = xArray[0:2402]
y = yArray

clf = SVC(gamma='auto')

clf.fit(X,y)

clf.predict([xArray[6930]])


#BACKTEST
spread = .00030
win = 0
total = 0
totalInactions = 0
for b in range(0000,3000):
    prediction = clf.predict([xArray[b]])
    currentPrice = xArray[b][598]
    if(prediction == 1):
        for n in range(0,50):
            if( float(xArray[b+n][598]) > (currentPrice + spread)):
                win += abs(float(xArray[b+n][598]) - ( currentPrice + spread))
                break
            if(n == 49):
                win -=  (currentPrice + spread) - float(xArray[b+n][598])
    elif(prediction == 2):
        for n in range(0,50):
            if(float(xArray[b+n][598]) < ( currentPrice - spread)):
                win += abs(( currentPrice - spread)- float(xArray[b+n][598]))
                break
            if(n == 49):
                win -= float(xArray[b+n][598]) - (currentPrice - spread)
    elif(prediction == 0):
        totalInactions += 1
    total += 1
                
            


pandasYArray = pd.DataFrame(data = yArray)
pandasYArray.to_csv("YClassification.csv", index = False)
