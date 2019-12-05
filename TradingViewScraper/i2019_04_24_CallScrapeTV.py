# -*- coding: utf-8 -*-
"""
Created on Wed Apr 24 14:09:34 2019

@author: gvega
"""
import os
os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')

from i2019_04_23_ScrapingTradingViewFuller import GetTVData



SymbolDB = ["EURCHF","GBPJPY","USDMXN","EURGBP","EURUSD","GBPCAD","CADJPY","CHFJPY","USDCHF",
                "USDJPY","EURJPY","CADCHF","EURCAD","GBPUSD","USDCAD"]

for i in range(0, len(SymbolDB)):
    GetTVData('TradingViewDataBase.csv',SymbolDB[i])

