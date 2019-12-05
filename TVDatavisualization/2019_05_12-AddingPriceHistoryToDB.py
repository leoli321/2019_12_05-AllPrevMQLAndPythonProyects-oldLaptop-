# -*- coding: utf-8 -*-
"""
Created on Sun May 12 21:25:01 2019

@author: gvega
"""
import pymysql.cursors
import os
import pandas as pd
import numpy as np

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TVDatavisualization')


SymbolNameArray = ["CHFJPY240","EURCAD240","EURCHF240","EURGBP240","EURJPY240","EURUSD240",
                   "GBPCAD240","GBPCHF240","GBPJPY240","GBPUSD240","USDCAD240","USDCHF240","USDJPY240",
                   "CADCHF240","CADJPY240"]

#DB = pd.read_csv(SymbolNameArray[0]+'.csv', header=None)

pymysql.converters.encoders[np.float64] = pymysql.converters.escape_float
pymysql.converters.conversions = pymysql.converters.encoders.copy()
pymysql.converters.conversions.update(pymysql.converters.decoders)

pymysql.converters.encoders[np.int64] = pymysql.converters.escape_float
pymysql.converters.conversions = pymysql.converters.encoders.copy()
pymysql.converters.conversions.update(pymysql.converters.decoders)

mydb =  pymysql.connect(host='localhost',
                              user='root',
                              port = 3306,
                              password='',
                              db='2019_05_03-analyzingtvdb')

mycursor = mydb.cursor()
#mycursor.execute("CREATE TABLE testTable(idUsers int(11) NOT NULL, emailUsers TINYTEXT NOT NULL)")

#-----------------------------------------------------------------------------------------##

def CreateTables(Symbol):
    mycursor.execute("CREATE TABLE "+Symbol+"Table(CurrentDate DATE NOT NULL, \
    	Hour TIME NOT NULL, OpenPrice DOUBLE NOT NULL, \
    	HighPrice DOUBLE NOT NULL, \
    	LowPrice DOUBLE NOT NULL,  \
    	ClosePrice DOUBLE NOT NULL,\
    	Volume DOUBLE NOT NULL)")
    mydb.commit()

def CreateAllTables():
    for i in range(0,len(SymbolNameArray)):
        CreateTables(SymbolNameArray[i])


def InsertDataIntoSql(Symbol,DataBase):
    for i in range(0, len(DataBase)):
        sql = "INSERT INTO " + Symbol+"Table(CurrentDate, Hour, OpenPrice,\
        	HighPrice, LowPrice, ClosePrice, Volume) \
             VALUES (%s, %s, %s, %s, %s, %s, %s)"
        
        val = (DataBase[0][i],DataBase[1][i],DataBase[2][i],	
               DataBase[3][i],DataBase[4][i],DataBase[5][i],DataBase[6][i]) 
	       
    
        mycursor.execute(sql,val)
        mydb.commit()

def FillingEveryDatabase():
    PercDone = 0
    for i in range(0,len(SymbolNameArray)):
        DB = pd.read_csv(SymbolNameArray[i]+'.csv', header=None)
        InsertDataIntoSql(SymbolNameArray[i],DB)
        PercDone = PercDone + (1/len(SymbolNameArray)) * 100
        print(PercDone,"%")
        
    
#Usually you have to create all tables and then fill every database.