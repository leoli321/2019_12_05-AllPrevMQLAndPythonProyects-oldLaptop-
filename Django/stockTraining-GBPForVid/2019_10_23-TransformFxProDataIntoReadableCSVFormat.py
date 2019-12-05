# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 09:17:00 2019

@author: gvega
"""

import pandas as pd
import os
import datetime




os.chdir(r'C:\\Users\gvega\Google Drive\MQL4 + Python\Django\stockTraining')

CADCHF240 = pd.read_csv("CADCHF240.csv", header = None)

MergedDate = []

start = 16200
for i in range(len(CADCHF240[0])):
    CurrentDate = CADCHF240[0][i] + " " + CADCHF240[1][i]
    CurrentDate = CurrentDate.replace(".","-")
    MergedDate.append(CurrentDate)



CADCHF240Cleaned = pd.DataFrame()
CADCHF240Cleaned["id"] = [] * len(MergedDate)
CADCHF240Cleaned["Symbol"] = ["USDCHF"] * len(MergedDate)
CADCHF240Cleaned["date"] = MergedDate
CADCHF240Cleaned["Open"] = CADCHF240[2][start:]
CADCHF240Cleaned["High"] = CADCHF240[3][start:]
CADCHF240Cleaned["Low"] = CADCHF240[4][start:]
CADCHF240Cleaned["Close"] = CADCHF240[5][start:]
CADCHF240Cleaned["Volume"] = CADCHF240[6][start:]



CADCHF240Cleaned.to_csv("CADCHF240Cleaned.csv", index = False)
