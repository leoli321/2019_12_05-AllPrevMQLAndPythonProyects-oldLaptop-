# -*- coding: utf-8 -*-
"""
Created on Thu Feb 28 08:39:16 2019

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
    
NeuronAmmount = 16 #Must be multiple of 4 for now.
PopulationSize = 200
StartingTick = 600
EndTick = 1200
profit = 0
HighestProfit = 0
OptimIterations = 2000 # 10 = 324 sec, 20 = 377
TopSpecimenNumber = 20
NeuronArray = np.array([ range(0,NeuronAmmount)], dtype = np.floating)
WeightsArray = np.array(    [[ range(0,NeuronAmmount)] , [range(0,NeuronAmmount)]], dtype = np.floating)
ResultsArray = np.array(    [ range(0,NeuronAmmount)], dtype = np.floating)
ProfitArray = np.array([range(0,OptimIterations)], dtype = np.floating)
NeuronSumArray = np.array([range(StartingTick,EndTick)], dtype = np.floating)
PopulationArray = np.empty([PopulationSize,NeuronAmmount])
PopulationProfitArray = np.empty([PopulationSize])
BestSpecimens = np.empty([TopSpecimenNumber])
BestSpecimensArray = np.empty([TopSpecimenNumber,NeuronAmmount])
BestSpecimensSonsArray = np.empty([TopSpecimenNumber,NeuronAmmount])
HighestProfit = 0
HighestProfitArray = np.empty([NeuronAmmount])


for G in range(0,OptimIterations):
    print(G, "  ", BestSpecimens[0])
    if (G == 0):
        for p in range(0,PopulationSize):       #BuildingThePopulation
            for i in range(0,NeuronAmmount):   
                WeightsArray[0][0][i] = random.uniform(.5,1.5)
            PopulationArray[p]= WeightsArray[0][0]
    
      
    for n in range(0,PopulationSize):
        profit = 0
        for tick in range(StartingTick,EndTick):       
            NeuronArray = GetInputNeurons(NeuronArray, tick,CADCHF10080, NeuronAmmount)
            NeuronArray= NormalizeArray(NeuronArray)
                    
            for i in range(0,NeuronAmmount):   
                NeuronArray[0][i] = NeuronArray[0][i] * PopulationArray[n][i]
                    
            if (    np.sum(NeuronArray) <= 6.25):
                 Decision = 1
            else: Decision = 0
                        
            if( (CADCHF10080[5][tick] < CADCHF10080[5][tick+1]  )   and (Decision == 1)    ):#AQUI CAMBIA EL SIMBOLO
                profit = profit + CADCHF10080[5][tick+1] - CADCHF10080[5][tick]
                        
            if( (CADCHF10080[5][tick] < CADCHF10080[5][tick+1]  )   and (Decision == 0)    ):
                profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])*-1
                            
            if( (CADCHF10080[5][tick] > CADCHF10080[5][tick+1]  )   and (Decision == 1)    ):
                profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])
                        
            if( (CADCHF10080[5][tick] > CADCHF10080[5][tick+1]  )   and (Decision == 0)    ):     
                profit = profit + (CADCHF10080[5][tick+1] - CADCHF10080[5][tick])*-1    
                   
            PopulationProfitArray[n] = profit
        
        
    for B in range(1,TopSpecimenNumber+1):
        BestSpecimens[B-1] = np.partition(PopulationProfitArray.flatten(), -B)[-B] #Encontrar el X más alto.
        t, = np.where(PopulationProfitArray == BestSpecimens[B-1])
        if(t.size > 1):
            t = t[0]
        BestSpecimensArray[B-1] = PopulationArray[t]
    
    
    for B in range(0,TopSpecimenNumber):
        
        if(TopSpecimenNumber < TopSpecimenNumber/2):
            SN = random.randint(0,TopSpecimenNumber/2-1)
            BestSpecimensSonsArray[B] = BestSpecimensArray[SN]
            for O in range(0,5):
                SN = random.randint(TopSpecimenNumber/2,TopSpecimenNumber-1)
                Z = random.randint(0,NeuronAmmount-1)
                BestSpecimensSonsArray[B][Z] = BestSpecimensArray[SN][Z]
                
        if(TopSpecimenNumber >= TopSpecimenNumber/2):
            SN = random.randint(TopSpecimenNumber/2,TopSpecimenNumber-1)
            BestSpecimensSonsArray[B] = BestSpecimensArray[SN]
            for O in range(0,5):
                SN = random.randint(0,TopSpecimenNumber/2-1)
                Z = random.randint(0,NeuronAmmount-1)
                BestSpecimensSonsArray[B][Z] = BestSpecimensArray[SN][Z]
        
    
    for p in range(0,TopSpecimenNumber):
        PopulationArray[p] = BestSpecimensSonsArray[p] 
    
    for p in range(TopSpecimenNumber, TopSpecimenNumber*2):    
        PopulationArray[p]= BestSpecimensArray[p-20]
        
    for p in range(TopSpecimenNumber*2, PopulationSize):
        for i in range(0,NeuronAmmount):   
                WeightsArray[0][0][i] = random.uniform(.5,1.5)      
        PopulationArray[p]= WeightsArray[0][0]
            
    if(BestSpecimens[0] > HighestProfit ):
        HighestProfit = BestSpecimens[0]
        HighestProfitArray = BestSpecimensArray[0]
        
print("--- %s seconds ---" % (time.time() - start_time))
