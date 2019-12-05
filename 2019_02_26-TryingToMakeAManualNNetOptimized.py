# -*- coding: utf-8 -*-
"""
Created on Tue Feb 26 13:28:51 2019

@author: gvega
"""

#IMMA TRY MAKE A NNET.

import pandas as pd
import os
import numpy as np
import random
import math

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


Candies = 0
HighestCandies = 0
profit = 0
HighestProfit = 0
OptimIterations = 2500
SigmoidX = 0
SigmoidCount = 1
AverageSigmoid = 0
for i in range(0,NeuronAmmount):
    WeightsArray[0][0][i] = random.randint(1,9)/10
    WeightsArray[1][0][i] = random.uniform(-2, 2)  
            
Weight = .05
Better = False
for OptimCicle in range(1,OptimIterations):
    
    if(Better == False):
        Weight = Weight * -1
    
    for i in range(0,NeuronAmmount):    
        #WeightsArray[0][0][i] = WeightsArray[0][0][i] + Weight * random.randint(-1,1)
        #WeightsArray[1][0][i] = WeightsArray[1][0][i] + Weight/10 * random.randint(-1,1)
        
        #if (OptimCicle == OptimIterations/2):
            WeightsArray[0][0][i] = random.randint(1,9)/10
            WeightsArray[1][0][i] = random.uniform(-2, 2)    
                
            
        
        
        
    print(OptimCicle, "  Profit: ", profit, " Sigmoid: ", AverageSigmoid)
    profit = 0
    Candies = 0        

    for tick in range(3000,6000):
        
        TickSubstraction = (NeuronAmmount / 4 -1)
        
        for i in range(1,NeuronAmmount+1):
            if i%4 == 1:
                NeuronArray[0][i-1] = CADCHF1440[2][tick- (NeuronAmmount/4 - TickSubstraction )]  #OPEN
            if i%4 == 2:
                NeuronArray[0][i-1] = CADCHF1440[3][tick- (NeuronAmmount/4 - TickSubstraction )] #MAX
            if i%4 == 3:
                NeuronArray[0][i-1] = CADCHF1440[4][tick- (NeuronAmmount/4 - TickSubstraction )]    #MIN
            if i%4 == 0:
                NeuronArray[0][i-1] = CADCHF1440[5][tick- (NeuronAmmount/4 - TickSubstraction )]        #CLOSE    
                TickSubstraction = TickSubstraction - 1
        
        NeuronArray = NormalizeArray(NeuronArray)
        
        for i in range(0,NeuronAmmount):
            ResultsArray[0][i] = NeuronArray[0][i] ** WeightsArray[0][0][i] * WeightsArray[1][0][i]        
        
        XValue = np.sum(ResultsArray) / 6
        SigmoidX =  1/(1+math.exp(-XValue))
        AverageSigmoid = (AverageSigmoid*SigmoidCount + SigmoidX)/(SigmoidCount+1)
        SigmoidCount = SigmoidCount + 1
        
        if (    (SigmoidX <= ( .5 ) )):
            Decision = 1
        else: Decision = 0
        
        if( (CADCHF1440[5][tick] < CADCHF1440[5][tick+1]  )   and (Decision == 1)    ):
            Candies = Candies + 1
            profit = profit + CADCHF1440[5][tick+1] - CADCHF1440[5][tick]
        
        if( (CADCHF1440[5][tick] < CADCHF1440[5][tick+1]  )   and (Decision == 0)    ):
            Candies = Candies - 1
            profit = profit + (CADCHF1440[5][tick+1] - CADCHF1440[5][tick])*-1
            
        if( (CADCHF1440[5][tick] > CADCHF1440[5][tick+1]  )   and (Decision == 1)    ):
            Candies = Candies - 1
            profit = profit + (CADCHF1440[5][tick+1] - CADCHF1440[5][tick])
        
        if( (CADCHF1440[5][tick] > CADCHF1440[5][tick+1]  )   and (Decision == 0)    ):
            Candies = Candies + 1     
            profit = profit + (CADCHF1440[5][tick+1] - CADCHF1440[5][tick])*-1
        
        Better = False
        
    
    if(HighestCandies < Candies):
        BestArray = WeightsArray        
        HighestCandies = Candies
        HighestAccuracyProfit = profit
        
    if(HighestProfit < profit):
        BestProfitArray = WeightsArray        
        HighestProfitCandies = Candies
        HighestProfit = profit
        Better = True
    
    
SaveArray = BestArray
    
    
            
    
                 
    

