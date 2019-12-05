# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 08:50:25 2019

@author: gvega
"""

#ProvingTheSolverConvergence SI CONVERGE!!!!
import random
import numpy as np


VariableAmmount = 5
PopulationSize = 50
OptimIterations = 100
TopSpecimenNumber = 16 #Debe ser multiplo de 2
HighestProfit = 0

PopulationArray = np.empty([PopulationSize,VariableAmmount])
VariablesArray = np.array(    [ range(0,VariableAmmount)], dtype = np.floating)
ProfitArray = np.array([range(0,PopulationSize)], dtype = np.floating)
BestSpecimens = np.empty([TopSpecimenNumber])
BestSpecimensArray = np.empty([TopSpecimenNumber,VariableAmmount])
BestSpecimensSonsArray = np.empty([TopSpecimenNumber,VariableAmmount])

for G in range(0,OptimIterations):
    print(G, "  ",BestSpecimens[0])
    if (G == 0):
         for p in range(0,PopulationSize):       #BuildingThePopulation
             for i in range(0,VariableAmmount):   
                 VariablesArray[0][i] = random.randint(1,5)
             PopulationArray[p]=VariablesArray[0]
     
    for B in range(0,PopulationSize):
         ProfitArray[0][B] = PopulationArray[B][0] * PopulationArray[B][1] ** PopulationArray[B][2] / PopulationArray[B][3] + PopulationArray[B][4] - PopulationArray[B][0] ** PopulationArray[B][1] * PopulationArray[B][2]
    
    for B in range(1,TopSpecimenNumber+1):
        BestSpecimens[B-1] = np.partition(ProfitArray.flatten(), -B)[-B] #Encontrar el X más alto.
        t = np.where(ProfitArray == BestSpecimens[B-1])
        t = t[1][0]
        BestSpecimensArray[B-1] = PopulationArray[t] 
        

    for B in range(0,TopSpecimenNumber):
        
        if(TopSpecimenNumber < TopSpecimenNumber/2):
            SN = random.randint(0,TopSpecimenNumber/2-1)
            BestSpecimensSonsArray[B] = BestSpecimensArray[SN]
            for O in range(0,5):
                SN = random.randint(TopSpecimenNumber/2,TopSpecimenNumber-1)
                Z = random.randint(0,VariableAmmount-1)
                BestSpecimensSonsArray[B][Z] = BestSpecimensArray[SN][Z]
                
        if(TopSpecimenNumber >= TopSpecimenNumber/2):
            SN = random.randint(TopSpecimenNumber/2,TopSpecimenNumber-1)
            BestSpecimensSonsArray[B] = BestSpecimensArray[SN]
            for O in range(0,5):
                SN = random.randint(0,TopSpecimenNumber/2-1)
                Z = random.randint(0,VariableAmmount-1)
                BestSpecimensSonsArray[B][Z] = BestSpecimensArray[SN][Z]      
                
    for p in range(0,TopSpecimenNumber):
        PopulationArray[p] = BestSpecimensSonsArray[p] 
    
    for p in range(TopSpecimenNumber, TopSpecimenNumber*2):    
        PopulationArray[p]= BestSpecimensArray[p-20]
        
    for p in range(TopSpecimenNumber*2, PopulationSize):
        for i in range(0,VariableAmmount):   
                VariablesArray[0][i] = random.randint(1,5)      
        PopulationArray[p]=VariablesArray[0]
            
    if(BestSpecimens[0] > HighestProfit ):
        HighestProfit = BestSpecimens[0]
        HighestProfitArray = BestSpecimensArray[0]                
        
     