# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 11:04:40 2019

@author: gvega
"""

##MAXIMUM Possible value

import pandas as pd
import os
import numpy as np
import time
start_time = time.time()

os.chdir(r"C:\\Users\gvega\OneDrive\Documentos\PythonCodes\FxManualNNet")


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



def NormalizeArray(Array):
    Max = np.amax(Array)
    Min = np.amin(Array)
    Slope = (.9 - .1) / (Max - Min)
    Intercept = .9 - (Max*Slope)
    
    for i in range(0,Array.size):
        Array[0][i] = Array[0][i]*Slope + Intercept
    
    return(Array)
    
    
def GetInputNeurons(Array,tick, TICKET,NeuronAmmount):
    TickSubstraction = (NeuronAmmount / 4 -1)     
    for i in range(1,NeuronAmmount+1):
        if i%4 == 1:
            Array[0][i-1] = TICKET[2][tick- (NeuronAmmount/4 - TickSubstraction )]  #OPEN
        if i%4 == 2:
            Array[0][i-1] = TICKET[3][tick- (NeuronAmmount/4 - TickSubstraction )] #MAX
        if i%4 == 3:
            Array[0][i-1] = TICKET[4][tick- (NeuronAmmount/4 - TickSubstraction )]    #MIN
        if i%4 == 0:
            Array[0][i-1] = TICKET[5][tick- (NeuronAmmount/4 - TickSubstraction )]        #CLOSE    
            TickSubstraction = TickSubstraction - 1
        
    return(Array)
    
NeuronAmmount = 12 #Must be multiple of 4 for now.
StartingTick = 600
EndTick = 1200
profit = 0
    
for tick in range(StartingTick,EndTick):       
        if(CADCHF10080[5][tick+1] > CADCHF10080[5][tick]):
                profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])
        if(CADCHF10080[5][tick+1] < CADCHF10080[5][tick]):
                profit = profit + (CADCHF10080[5][tick] - CADCHF10080[5][tick+1])                