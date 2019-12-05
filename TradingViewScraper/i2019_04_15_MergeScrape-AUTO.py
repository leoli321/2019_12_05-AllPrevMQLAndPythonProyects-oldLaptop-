# -*- coding: utf-8 -*-
"""
Created on Mon Apr 15 19:37:54 2019

@author: gvega
"""

import os
import time
os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')
from i2019_04_14_ScrapingTradingView import GetTVData
from i2019_04_14_Analyzing_DB_DATA import AnalyzingDBData
from i2019_04_14_DeltaTimeCheckAndResult import CheckTimeStatus
from i2019_04_15_AccuracyAndProfit import Accuracy
from i2019_04_16_DeltaTimeCheckAndResultButOnlyIfItChangedDirection import CheckTimeStatusChangeDir

SymbolDB = ["EURCHF","GBPJPY","USDMXN","EURGBP","EURUSD","GBPCAD","CADJPY","CHFJPY","USDCHF",
                    "USDJPY","EURJPY","CADCHF","EURCAD","GBPUSD","USDCAD"]

time.sleep(520)

for i in range(0,3):
    for i in range(0, len(SymbolDB)):
        GetTVData('TradingViewDataBase.csv',SymbolDB[i])
        AnalyzingDBData('TradingViewDataBase.csv')
        CheckTimeStatus('TradingViewDataBase.csv',SymbolDB[i])
        Accuracy('TradingViewDataBase.csv')

    time.sleep(30)
    
    for i in range(0, len(SymbolDB)):
        GetTVData('TradingViewDataBaseIfChange.csv',SymbolDB[i])
        AnalyzingDBData('TradingViewDataBaseIfChange.csv')
        CheckTimeStatusChangeDir('TradingViewDataBaseIfChange.csv',SymbolDB[i])
        Accuracy('TradingViewDataBaseIfChange.csv')

        time.sleep(3610)