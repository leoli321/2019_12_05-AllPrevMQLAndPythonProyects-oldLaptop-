# -*- coding: utf-8 -*-
"""
Created on Sun Apr 14 12:10:12 2019

@author: gvega
"""
import os
os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')

from i2019_04_14_ScrapingTradingView import GetTVData
from i2019_04_22_Analyzing_DB_DATA import AnalyzingDBData
from i2019_04_14_DeltaTimeCheckAndResult import CheckTimeStatus
from i2019_04_15_AccuracyAndProfit import Accuracy

"""
import i2019_04_12_ScrapingTradingview
import i2019_04_13_Analyzing_DB_DATA
import i2019_04_13_DeltaTimeCheckAndResult
"""
SymbolDB = ["EURCHF","GBPJPY","USDMXN","EURGBP","EURUSD","GBPCAD","CADJPY","CHFJPY","USDCHF",
                "USDJPY","EURJPY","CADCHF","EURCAD","GBPUSD","USDCAD"]

for i in range(0, len(SymbolDB)-13):
    GetTVData('TradingViewDataBase.csv',SymbolDB[i])
    AnalyzingDBData('TradingViewDataBase.csv')
    CheckTimeStatus('TradingViewDataBase.csv',SymbolDB[i])
    Accuracy('TradingViewDataBase.csv')
