# -*- coding: utf-8 -*-
"""
Created on Tue Apr 16 10:58:54 2019

@author: gvega
"""

import os

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper\DatabaseIfChange')

from i2019_04_14_ScrapingTradingView import GetTVData
from i2019_04_14_Analyzing_DB_DATA import AnalyzingDBData
from i2019_04_16_DeltaTimeCheckAndResultButOnlyIfItChangedDirection import CheckTimeStatusChangeDir
from i2019_04_15_AccuracyAndProfit import Accuracy

SymbolDB = ["EURCHF","GBPJPY","USDMXN","EURGBP","EURUSD","GBPCAD","CADJPY","CHFJPY","USDCHF",
                "USDJPY","EURJPY","CADCHF","EURCAD","GBPUSD","USDCAD"]

for i in range(0, len(SymbolDB)):
    GetTVData('TradingViewDataBaseIfChange.csv',SymbolDB[i])
    AnalyzingDBData('TradingViewDataBaseIfChange.csv')
    CheckTimeStatusChangeDir('TradingViewDataBaseIfChange.csv',SymbolDB[i])
    Accuracy('TradingViewDataBaseIfChange.csv')
    print(SymbolDB[i])