# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 09:17:00 2019

@author: gvega
"""

import pandas as pd
import os



os.chdir(r'C:\\Users\gvega\Documents\django\FxTrainMain\ScenariosData\EURCHF\2019_11_11-EURCHF-DowntrendMaySep2019')

data = pd.read_csv("EURCHF1440.csv", header = None)

MergedDate = []

start = 0
for i in range(len(data[0])):
    CurrentDate = data[0][i] + " " + data[1][i]
    CurrentDate = CurrentDate.replace(".","-")
    MergedDate.append(CurrentDate)



dataCleaned = pd.DataFrame()
dataCleaned["id"] = [] * len(MergedDate)
dataCleaned["Symbol"] = ["EURCHF1440"] * len(MergedDate)
dataCleaned["date"] = MergedDate
dataCleaned["Open"] = data[2][start:]
dataCleaned["High"] = data[3][start:]
dataCleaned["Low"] = data[4][start:]
dataCleaned["Close"] = data[5][start:]
dataCleaned["Volume"] = data[6][start:]



dataCleaned.to_csv("EURCHF1440Cleaned.csv", index = False)
