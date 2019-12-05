# -*- coding: utf-8 -*-
"""
Created on Fri Apr 26 08:55:55 2019

@author: gvega
"""
# Standard plotly imports
import plotly.plotly as py
import plotly.graph_objs as go
from plotly.offline import iplot, init_notebook_mode
from plotly.graph_objs import Scatter, Layout
import plotly.offline
# Using plotly + cufflinks in offline mode
import cufflinks
import pandas as pd
import os
import datetime

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TVDatavisualization')

DB = pd.read_csv('TradingViewDataBase.csv')

def Functions(Database,CurrentSymbol):#ALGO.
    IndividualSymbolDB = DB.loc[DB['Symbol'] == CurrentSymbol]
    
    resettedIndexDB = IndividualSymbolDB.reset_index()
    
    def GetDateToDatetime(Database):
        Dates = pd.DataFrame()
        for i in range(0, (len(Database))):
            Dates = Dates.append([datetime.datetime.strptime(Database['Date'][i], '%Y/%m/%d %H:%M:%S')])
        Dates = Dates.reset_index(drop = True)
        Database['Date'] = Dates[0].values
        return (Database)
    
    try:
        resettedIndexDB = GetDateToDatetime(Database)
    except:
        pass
        
    def PlotLineGraph(X,Y):
       plotly.offline.plot({
        "data": [
            Scatter(x= X, y= Y)
        ],
        "layout": Layout(
            title=Symbol
        )
        }) 
    
    #PlotLineGraph(resettedIndexDB['Date'],resettedIndexDB['Price'])
    
    def TestAccuracy(Database,Predictor):
        CurrentDate = Database['Date'][0]
        CurrentPrediction = Database[Predictor][0]
        CurrentPrice = Database['Price'][0]
        Accuracy = pd.DataFrame()
        for i in range(0, len(Database)):        
            if( (Database['Date'][i] - CurrentDate) > datetime.timedelta(0,3600) ):    
    
                if(CurrentPrediction == "Buy" and (CurrentPrice < Database['Price'][i]) ):
                    #Que subió de precio y la pred fue buy
                    Accuracy = Accuracy.append([1])
                elif (CurrentPrediction == "Sell" and (CurrentPrice > Database['Price'][i])):
                    Accuracy = Accuracy.append([1])
                elif (CurrentPrediction == "Neutral"):
                    Accuracy = Accuracy.append([.5])
                else:
                    Accuracy = Accuracy.append([0])
    
                CurrentDate = Database['Date'][i]
                CurrentPrediction = Database[Predictor][i]
                CurrentPrice = Database['Price'][i]
        return Accuracy
        
    #AccuracyMom1hr = TestAccuracy(resettedIndexDB, 'Hour1MomPrediction')
    
    def PlotLineGraphWithText(X,Y,PredText):
       plotly.offline.plot({
        "data": [
            Scatter(x= X, y= Y, text = PredText, mode = 'markers+text+lines')
        ],
        "layout": Layout(
            title=Symbol
        )
        }) 
    
    #PlotLineGraphWithText(resettedIndexDB['Date'], resettedIndexDB['Price'], resettedIndexDB['Hour1MomPrediction'])
    
    
    def TestingCloseEverySpot(Price,PredText):
        Balance = 0
        CurrentPrice = Price[0]
        CurrentPrediction = PredText[0]
        for i in range(0, len(Price)):
            if( CurrentPrediction == "Buy" and (CurrentPrice < Price[i]) ):
                Balance = Balance + ( (Price[i] - CurrentPrice)/Price[i] )
            elif( CurrentPrediction == "Sell" and (CurrentPrice > Price[i]) ):
                Balance = Balance + ( (CurrentPrice - Price[i])/Price[i] )
            elif( CurrentPrediction == "Neutral"):
                Balance = Balance
            elif( CurrentPrediction == "Buy" and (CurrentPrice > Price[i]) ):
                Balance = Balance + ( (Price[i] - CurrentPrice)/Price[i] )
            elif( CurrentPrediction == "Sell" and (CurrentPrice < Price[i]) ):
                Balance = Balance - ( (Price[i] - CurrentPrice)/Price[i] )  
            
            CurrentPrediction = PredText[i]
            CurrentPrice = Price[i]
        
        return(Balance)
                
    TestBalance = TestingCloseEverySpot(resettedIndexDB['Price'], resettedIndexDB['Hour1MomPrediction'])
