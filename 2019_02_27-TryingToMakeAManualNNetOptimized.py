# -*- coding: utf-8 -*-
"""
Created on Wed Feb 27 10:27:39 2019

@author: gvega
"""

#IMMA TRY MAKE A NNET.

import pandas as pd
import os
import numpy as np
import random
import time
start_time = time.time()

os.chdir(r"C:\\Users\gvega\OneDrive\Documentos\PythonCodes\FxManualNNet")

CADCHF5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADCHF5.csv", header = None)
CADJPY5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADJPY5.csv", header = None)
CHFJPY5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CHFJPY5.csv", header = None)
EURCAD5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCAD5.csv", header = None)
EURCHF5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCHF5.csv", header = None)
EURGBP5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURGBP5.csv", header = None)
EURJPY5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURJPY5.csv", header = None)
EURUSD5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURUSD5.csv", header = None)
GBPCAD5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCAD5.csv", header = None)
GBPCHF5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCHF5.csv", header = None)
GBPJPY5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPJPY5.csv", header = None)
GBPUSD5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPUSD5.csv", header = None)
USDCAD5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCAD5.csv", header = None)
USDCHF5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCHF5.csv", header = None)
USDJPY5 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDJPY5.csv", header = None)


CADCHF1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADCHF1440.csv", header = None)
CADJPY1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADJPY1440.csv", header = None)
CHFJPY1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CHFJPY1440.csv", header = None)
EURCAD1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCAD1440.csv", header = None)
EURCHF1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCHF1440.csv", header = None)
EURGBP1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURGBP1440.csv", header = None)
EURJPY1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURJPY1440.csv", header = None)
EURUSD1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURUSD1440.csv", header = None)
GBPCAD1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCAD1440.csv", header = None)
GBPCHF1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCHF1440.csv", header = None)
GBPJPY1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPJPY1440.csv", header = None)
GBPUSD1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPUSD1440.csv", header = None)
USDCAD1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCAD1440.csv", header = None)
USDCHF1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCHF1440.csv", header = None)
USDJPY1440 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDJPY1440.csv", header = None)

CADCHF10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADCHF10080.csv", header = None)
CADJPY10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CADJPY10080.csv", header = None)
CHFJPY10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\CHFJPY10080.csv", header = None)
EURCAD10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCAD10080.csv", header = None)
EURCHF10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURCHF10080.csv", header = None)
EURGBP10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURGBP10080.csv", header = None)
EURJPY10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURJPY10080.csv", header = None)
EURUSD10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\EURUSD10080.csv", header = None)
GBPCAD10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCAD10080.csv", header = None)
GBPCHF10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPCHF10080.csv", header = None)
GBPJPY10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPJPY10080.csv", header = None)
GBPUSD10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\GBPUSD10080.csv", header = None)
USDCAD10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCAD10080.csv", header = None)
USDCHF10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDCHF10080.csv", header = None)
USDJPY10080 = pd.read_csv(r"C:\\Users\gvega\OneDrive\Documentos\MT4QuoteHistory\USDJPY10080.csv", header = None)

CADCHF5Tick = CADCHF5[5]
CADJPY5Tick = CADJPY5[5]
CHFJPY5Tick = CHFJPY5[5]
EURCAD5Tick = EURCAD5[5]
EURCHF5Tick = EURCHF5[5]
EURGBP5Tick = EURGBP5[5]
EURJPY5Tick = EURJPY5[5]
EURUSD5Tick = EURUSD5[5]
GBPCAD5Tick = GBPCAD5[5]
GBPCHF5Tick = GBPCHF5[5]
GBPJPY5Tick = GBPJPY5[5]
GBPUSD5Tick = GBPUSD5[5]
USDCAD5Tick = USDCAD5[5]
USDCHF5Tick = USDCHF5[5]
USDJPY5Tick = USDJPY5[5]

TickNumber5 = len(USDJPY5)
TickNumber1440 = len(USDJPY1440)
NeuronArray = np.array([ range(0,12)], dtype = np.floating)
WeightsArray = np.array(    [[ range(0,12)] , [range(0,12)]], dtype = np.floating)
ResultsArray = np.array(    [ range(0,12)], dtype = np.floating)
NeuronAmmount = 12 #Must be multiple of 4 for now.





def NormalizeArray(Array):
    Max = np.amax(Array)
    Min = np.amin(Array)
    Slope = (.9 - .1) / (Max - Min)
    Intercept = .9 - (Max*Slope)
    
    for i in range(0,Array.size):
        Array[0][i] = Array[0][i]*Slope + Intercept
    
    return(Array)
    
NeuronSumArray = np.array([range(3000,6000)], dtype = np.floating)


profit = 0
HighestProfit = 0
OptimIterations = 1000 # 1000 = 219 sec
ProfitArray = np.array([range(0,OptimIterations)], dtype = np.floating)

for OptimCicle in range(0,OptimIterations):
    profit = 0
    if(OptimCicle%100 == 0):
        print(OptimCicle)
    for tick in range(600,1200):   
        TickSubstraction = (NeuronAmmount / 4 -1)     
        for i in range(1,NeuronAmmount+1):
            if i%4 == 1:
                NeuronArray[0][i-1] = CADCHF10080[2][tick- (NeuronAmmount/4 - TickSubstraction )]  #OPEN
            if i%4 == 2:
                NeuronArray[0][i-1] = CADCHF10080[3][tick- (NeuronAmmount/4 - TickSubstraction )] #MAX
            if i%4 == 3:
                NeuronArray[0][i-1] = CADCHF10080[4][tick- (NeuronAmmount/4 - TickSubstraction )]    #MIN
            if i%4 == 0:
                NeuronArray[0][i-1] = CADCHF10080[5][tick- (NeuronAmmount/4 - TickSubstraction )]        #CLOSE    
                TickSubstraction = TickSubstraction - 1
        
        NeuronArray= NormalizeArray(NeuronArray)
        
        #NeuronSumArray[0][tick-3000] = np.sum(NeuronArray)
        
        for i in range(0,NeuronAmmount):   
            WeightsArray[0][0][i] = random.randint(5,15)/10
            NeuronArray[0][i] = NeuronArray[0][i] * WeightsArray[0][0][i]
        
        if (    np.sum(NeuronArray) <= 6.25):
            Decision = 1
        else: Decision = 0
            
        if( (CADCHF10080[5][tick] < CADCHF10080[5][tick+1]  )   and (Decision == 1)    ):
            profit = profit + CADCHF10080[5][tick+1] - CADCHF10080[5][tick]
            
        if( (CADCHF10080[5][tick] < CADCHF10080[5][tick+1]  )   and (Decision == 0)    ):
            profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])*-1
                
        if( (CADCHF10080[5][tick] > CADCHF10080[5][tick+1]  )   and (Decision == 1)    ):
            profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])
            
        if( (CADCHF10080[5][tick] > CADCHF10080[5][tick+1]  )   and (Decision == 0)    ):     
            profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])*-1    
        
        
    if(profit > HighestProfit):
        HighestProfit = profit
        HighestProfitArray = WeightsArray
        
    ProfitArray[0][OptimCicle] = profit
    
print("--- %s seconds ---" % (time.time() - start_time))
