# -*- coding: utf-8 -*-
"""
Created on Fri May  3 10:55:07 2019

@author: gvega
"""
import pymysql.cursors
import os
import pandas as pd
import numpy as np

os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TVDatavisualization')

DB = pd.read_csv('TradingViewDataBase.csv')

SymbolNameArray = ["CHFJPY5","EURCAD5","EURCHF5","EURGBP5","EURJPY5","EURUSD5",
                   "GBPCAD5","GBPCHF5","GBPJPY5","GBPUSD5","USDCAD5","USDCHF5","USDJPY5"]

PriceHistoryArray = []

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

"""
mycursor.execute("CREATE TABLE testTable(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	Hour1RSIPrediction TINYTEXT NOT NULL, \
	Hour1StochPrediction TINYTEXT NOT NULL,  \
	Hour1CCIPrediction TINYTEXT NOT NULL,\
	Hour1ADIPrediction TINYTEXT NOT NULL, \
	Hour1AOPrediction TINYTEXT NOT NULL, \
	Hour1MomPrediction TINYTEXT NOT NULL,\
	Hour1MACDPrediction TINYTEXT NOT NULL,\
	Hour1StochRSIPrediction TINYTEXT NOT NULL,\
	Hour1WillPrediction TINYTEXT NOT NULL,\
	Hour1BullBearPrediction TINYTEXT NOT NULL,\
	Hour1UltimateOPrediction TINYTEXT NOT NULL,\
	Hour1EMA005Prediction TINYTEXT NOT NULL,\
	Hour1SMA005Prediction TINYTEXT NOT NULL,  Hour1EMA010Prediction TINYTEXT NOT NULL,  Hour1SMA010Prediction TINYTEXT NOT NULL,  Hour1EMA020Prediction TINYTEXT NOT NULL,  Hour1SMA020Prediction TINYTEXT NOT NULL,  Hour1EMA030Prediction TINYTEXT NOT NULL,  Hour1SMA030Prediction TINYTEXT NOT NULL,  Hour1EMA050Prediction TINYTEXT NOT NULL,  Hour1SMA050Prediction TINYTEXT NOT NULL,  Hour1EMA100Prediction TINYTEXT NOT NULL,  Hour1SMA100Prediction TINYTEXT NOT NULL,  Hour1EMA200Prediction TINYTEXT NOT NULL,  Hour1SMA200Prediction TINYTEXT NOT NULL,  Hour1IChiPrediction TINYTEXT NOT NULL,  Hour1VWMAPrediction TINYTEXT NOT NULL,  Hour1HMAPrediction TINYTEXT NOT NULL,  Hour4RSIPrediction TINYTEXT NOT NULL,  Hour4StochPrediction TINYTEXT NOT NULL,  Hour4CCIPrediction TINYTEXT NOT NULL,  Hour4ADIPrediction TINYTEXT NOT NULL,  Hour4AOPrediction TINYTEXT NOT NULL,  Hour4MomPrediction TINYTEXT NOT NULL,  Hour4MACDPrediction TINYTEXT NOT NULL,  Hour4StochRSIPrediction TINYTEXT NOT NULL,  Hour4WillPrediction TINYTEXT NOT NULL,  Hour4BullBearPrediction TINYTEXT NOT NULL,  Hour4UltimateOPrediction TINYTEXT NOT NULL,  Hour4EMA005Prediction TINYTEXT NOT NULL,  Hour4SMA005Prediction TINYTEXT NOT NULL,  Hour4EMA010Prediction TINYTEXT NOT NULL,  Hour4SMA010Prediction TINYTEXT NOT NULL,  Hour4EMA020Prediction TINYTEXT NOT NULL,  Hour4SMA020Prediction TINYTEXT NOT NULL,  Hour4EMA030Prediction TINYTEXT NOT NULL,  Hour4SMA030Prediction TINYTEXT NOT NULL,  Hour4EMA050Prediction TINYTEXT NOT NULL,  Hour4SMA050Prediction TINYTEXT NOT NULL,  Hour4EMA100Prediction TINYTEXT NOT NULL,  Hour4SMA100Prediction TINYTEXT NOT NULL,  Hour4EMA200Prediction TINYTEXT NOT NULL,  Hour4SMA200Prediction TINYTEXT NOT NULL,  Hour4IChiPrediction TINYTEXT NOT NULL,  Hour4VWMAPrediction TINYTEXT NOT NULL,  Hour4HMAPrediction TINYTEXT NOT NULL,  DayRSIPrediction TINYTEXT NOT NULL,  DayStochPrediction TINYTEXT NOT NULL,  DayCCIPrediction TINYTEXT NOT NULL,  DayADIPrediction TINYTEXT NOT NULL,  DayAOPrediction TINYTEXT NOT NULL,  DayMomPrediction TINYTEXT NOT NULL,  DayMACDPrediction TINYTEXT NOT NULL,  DayStochRSIPrediction TINYTEXT NOT NULL,  DayWillPrediction TINYTEXT NOT NULL,  DayBullBearPrediction TINYTEXT NOT NULL,  DayUltimateOPrediction TINYTEXT NOT NULL,  DayEMA005Prediction TINYTEXT NOT NULL,  DaySMA005Prediction TINYTEXT NOT NULL,  DayEMA010Prediction TINYTEXT NOT NULL,  DaySMA010Prediction TINYTEXT NOT NULL,  DayEMA020Prediction TINYTEXT NOT NULL,  DaySMA020Prediction TINYTEXT NOT NULL,  DayEMA030Prediction TINYTEXT NOT NULL,  DaySMA030Prediction TINYTEXT NOT NULL,  DayEMA050Prediction TINYTEXT NOT NULL,  DaySMA050Prediction TINYTEXT NOT NULL,  DayEMA100Prediction TINYTEXT NOT NULL,  DaySMA100Prediction TINYTEXT NOT NULL,  DayEMA200Prediction TINYTEXT NOT NULL,  DaySMA200Prediction TINYTEXT NOT NULL,  DayIChiPrediction TINYTEXT NOT NULL,  DayVWMAPrediction TINYTEXT NOT NULL,  DayHMAPrediction TINYTEXT NOT NULL,  WeekRSIPrediction TINYTEXT NOT NULL,  WeekStochPrediction TINYTEXT NOT NULL,  WeekCCIPrediction TINYTEXT NOT NULL,  WeekADIPrediction TINYTEXT NOT NULL,  WeekAOPrediction TINYTEXT NOT NULL,  WeekMomPrediction TINYTEXT NOT NULL,  WeekMACDPrediction TINYTEXT NOT NULL,  WeekStochRSIPrediction TINYTEXT NOT NULL,  WeekWillPrediction TINYTEXT NOT NULL,  WeekBullBearPrediction TINYTEXT NOT NULL,  WeekUltimateOPrediction TINYTEXT NOT NULL,  WeekEMA005Prediction TINYTEXT NOT NULL,  WeekSMA005Prediction TINYTEXT NOT NULL,  WeekEMA010Prediction TINYTEXT NOT NULL,  WeekSMA010Prediction TINYTEXT NOT NULL,  WeekEMA020Prediction TINYTEXT NOT NULL,  WeekSMA020Prediction TINYTEXT NOT NULL,  WeekEMA030Prediction TINYTEXT NOT NULL,  WeekSMA030Prediction TINYTEXT NOT NULL,  WeekEMA050Prediction TINYTEXT NOT NULL,  WeekSMA050Prediction TINYTEXT NOT NULL,  WeekEMA100Prediction TINYTEXT NOT NULL,  WeekSMA100Prediction TINYTEXT NOT NULL,  WeekEMA200Prediction TINYTEXT NOT NULL,  WeekSMA200Prediction TINYTEXT NOT NULL,  WeekIChiPrediction TINYTEXT NOT NULL,  WeekVWMAPrediction TINYTEXT NOT NULL,  WeekHMAPrediction TINYTEXT NOT NULL,  MonthRSIPrediction TINYTEXT NOT NULL,  MonthStochPrediction TINYTEXT NOT NULL,  MonthCCIPrediction TINYTEXT NOT NULL,  MonthADIPrediction TINYTEXT NOT NULL,  MonthAOPrediction TINYTEXT NOT NULL,  MonthMomPrediction TINYTEXT NOT NULL,  MonthMACDPrediction TINYTEXT NOT NULL,  MonthStochRSIPrediction TINYTEXT NOT NULL,  MonthWillPrediction TINYTEXT NOT NULL,  MonthBullBearPrediction TINYTEXT NOT NULL,  MonthUltimateOPrediction TINYTEXT NOT NULL,  MonthEMA005Prediction TINYTEXT NOT NULL,  MonthSMA005Prediction TINYTEXT NOT NULL,  MonthEMA010Prediction TINYTEXT NOT NULL,  MonthSMA010Prediction TINYTEXT NOT NULL,  MonthEMA020Prediction TINYTEXT NOT NULL,  MonthSMA020Prediction TINYTEXT NOT NULL,  MonthEMA030Prediction TINYTEXT NOT NULL,  MonthSMA030Prediction TINYTEXT NOT NULL,  MonthEMA050Prediction TINYTEXT NOT NULL,  MonthSMA050Prediction TINYTEXT NOT NULL,  MonthEMA100Prediction TINYTEXT NOT NULL,  MonthSMA100Prediction TINYTEXT NOT NULL,  MonthEMA200Prediction TINYTEXT NOT NULL,  MonthSMA200Prediction TINYTEXT NOT NULL,  MonthIChiPrediction TINYTEXT NOT NULL,  MonthVWMAPrediction TINYTEXT NOT NULL,  MonthHMAPrediction TINYTEXT NOT NULL,\
	Hour1Buy INT(11) NOT NULL, Hour1Sell INT(11) NOT NULL, Hour1Neutral INT(11) NOT NULL, Hour4Buy INT(11) NOT NULL, Hour4Sell INT(11) NOT NULL, Hour4Neutral INT(11) NOT NULL, DayBuy INT(11) NOT NULL, DaySell INT(11) NOT NULL, DayNeutral INT(11) NOT NULL, WeekBuy INT(11) NOT NULL, WeekSell INT(11) NOT NULL, WeekNeutral INT(11) NOT NULL, MonthBuy INT(11) NOT NULL, MonthSell INT(11) NOT NULL, MonthNeutral INT(11) NOT NULL)")
"""


mycursor.execute("CREATE TABLE Hour1Table(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	Hour1RSIPrediction TINYTEXT NOT NULL, \
	Hour1StochPrediction TINYTEXT NOT NULL,  \
	Hour1CCIPrediction TINYTEXT NOT NULL,\
	Hour1ADIPrediction TINYTEXT NOT NULL, \
	Hour1AOPrediction TINYTEXT NOT NULL, \
	Hour1MomPrediction TINYTEXT NOT NULL,\
	Hour1MACDPrediction TINYTEXT NOT NULL,\
	Hour1StochRSIPrediction TINYTEXT NOT NULL,\
	Hour1WillPrediction TINYTEXT NOT NULL,\
	Hour1BullBearPrediction TINYTEXT NOT NULL,\
	Hour1UltimateOPrediction TINYTEXT NOT NULL,\
	Hour1EMA005Prediction TINYTEXT NOT NULL,\
	Hour1SMA005Prediction TINYTEXT NOT NULL,  Hour1EMA010Prediction TINYTEXT NOT NULL,  Hour1SMA010Prediction TINYTEXT NOT NULL,\
	Hour1EMA020Prediction TINYTEXT NOT NULL,  Hour1SMA020Prediction TINYTEXT NOT NULL,  Hour1EMA030Prediction TINYTEXT NOT NULL,\
	  Hour1SMA030Prediction TINYTEXT NOT NULL,  Hour1EMA050Prediction TINYTEXT NOT NULL,  Hour1SMA050Prediction TINYTEXT NOT NULL,\
	    Hour1EMA100Prediction TINYTEXT NOT NULL,  Hour1SMA100Prediction TINYTEXT NOT NULL,  Hour1EMA200Prediction TINYTEXT NOT NULL,\
	      Hour1SMA200Prediction TINYTEXT NOT NULL,  Hour1IChiPrediction TINYTEXT NOT NULL,  Hour1VWMAPrediction TINYTEXT NOT NULL,\
	        Hour1HMAPrediction TINYTEXT NOT NULL,Hour1Buy INT(11) NOT NULL,	Hour1Sell INT(11) NOT NULL,Hour1Neutral INT(11) NOT NULL)")
mydb.commit()

#-----------------------------------------------------------------------------------------##
mycursor.execute("CREATE TABLE Hour4Table(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	Hour4RSIPrediction TINYTEXT NOT NULL, \
	Hour4StochPrediction TINYTEXT NOT NULL,  \
	Hour4CCIPrediction TINYTEXT NOT NULL,\
	Hour4ADIPrediction TINYTEXT NOT NULL, \
	Hour4AOPrediction TINYTEXT NOT NULL, \
	Hour4MomPrediction TINYTEXT NOT NULL,\
	Hour4MACDPrediction TINYTEXT NOT NULL,\
	Hour4StochRSIPrediction TINYTEXT NOT NULL,\
	Hour4WillPrediction TINYTEXT NOT NULL,\
	Hour4BullBearPrediction TINYTEXT NOT NULL,\
	Hour4UltimateOPrediction TINYTEXT NOT NULL,\
	Hour4EMA005Prediction TINYTEXT NOT NULL,\
	Hour4SMA005Prediction TINYTEXT NOT NULL,  Hour4EMA010Prediction TINYTEXT NOT NULL,  Hour4SMA010Prediction TINYTEXT NOT NULL,\
	Hour4EMA020Prediction TINYTEXT NOT NULL,  Hour4SMA020Prediction TINYTEXT NOT NULL,  Hour4EMA030Prediction TINYTEXT NOT NULL,\
	  Hour4SMA030Prediction TINYTEXT NOT NULL,  Hour4EMA050Prediction TINYTEXT NOT NULL,  Hour4SMA050Prediction TINYTEXT NOT NULL,\
	    Hour4EMA100Prediction TINYTEXT NOT NULL,  Hour4SMA100Prediction TINYTEXT NOT NULL,  Hour4EMA200Prediction TINYTEXT NOT NULL,\
	      Hour4SMA200Prediction TINYTEXT NOT NULL,  Hour4IChiPrediction TINYTEXT NOT NULL,  Hour4VWMAPrediction TINYTEXT NOT NULL,\
	        Hour4HMAPrediction TINYTEXT NOT NULL,Hour4Buy INT(11) NOT NULL,	Hour4Sell INT(11) NOT NULL,Hour4Neutral INT(11) NOT NULL)")
mydb.commit()


#-----------------------------------------------------------------------------------------##
mycursor.execute("CREATE TABLE DayTable(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	DayRSIPrediction TINYTEXT NOT NULL, \
	DayStochPrediction TINYTEXT NOT NULL,  \
	DayCCIPrediction TINYTEXT NOT NULL,\
	DayADIPrediction TINYTEXT NOT NULL, \
	DayAOPrediction TINYTEXT NOT NULL, \
	DayMomPrediction TINYTEXT NOT NULL,\
	DayMACDPrediction TINYTEXT NOT NULL,\
	DayStochRSIPrediction TINYTEXT NOT NULL,\
	DayWillPrediction TINYTEXT NOT NULL,\
	DayBullBearPrediction TINYTEXT NOT NULL,\
	DayUltimateOPrediction TINYTEXT NOT NULL,\
	DayEMA005Prediction TINYTEXT NOT NULL,\
	DaySMA005Prediction TINYTEXT NOT NULL,  DayEMA010Prediction TINYTEXT NOT NULL,  DaySMA010Prediction TINYTEXT NOT NULL,\
	DayEMA020Prediction TINYTEXT NOT NULL,  DaySMA020Prediction TINYTEXT NOT NULL,  DayEMA030Prediction TINYTEXT NOT NULL,\
	  DaySMA030Prediction TINYTEXT NOT NULL,  DayEMA050Prediction TINYTEXT NOT NULL,  DaySMA050Prediction TINYTEXT NOT NULL,\
	    DayEMA100Prediction TINYTEXT NOT NULL,  DaySMA100Prediction TINYTEXT NOT NULL,  DayEMA200Prediction TINYTEXT NOT NULL,\
	      DaySMA200Prediction TINYTEXT NOT NULL,  DayIChiPrediction TINYTEXT NOT NULL,  DayVWMAPrediction TINYTEXT NOT NULL,\
	        DayHMAPrediction TINYTEXT NOT NULL,DayBuy INT(11) NOT NULL,	DaySell INT(11) NOT NULL,DayNeutral INT(11) NOT NULL)")
mydb.commit()

#-----------------------------------------------------------------------------------------##
mycursor.execute("CREATE TABLE WeekTable(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	WeekRSIPrediction TINYTEXT NOT NULL, \
	WeekStochPrediction TINYTEXT NOT NULL,  \
	WeekCCIPrediction TINYTEXT NOT NULL,\
	WeekADIPrediction TINYTEXT NOT NULL, \
	WeekAOPrediction TINYTEXT NOT NULL, \
	WeekMomPrediction TINYTEXT NOT NULL,\
	WeekMACDPrediction TINYTEXT NOT NULL,\
	WeekStochRSIPrediction TINYTEXT NOT NULL,\
	WeekWillPrediction TINYTEXT NOT NULL,\
	WeekBullBearPrediction TINYTEXT NOT NULL,\
	WeekUltimateOPrediction TINYTEXT NOT NULL,\
	WeekEMA005Prediction TINYTEXT NOT NULL,\
	WeekSMA005Prediction TINYTEXT NOT NULL,  WeekEMA010Prediction TINYTEXT NOT NULL,  WeekSMA010Prediction TINYTEXT NOT NULL,\
	WeekEMA020Prediction TINYTEXT NOT NULL,  WeekSMA020Prediction TINYTEXT NOT NULL,  WeekEMA030Prediction TINYTEXT NOT NULL,\
	  WeekSMA030Prediction TINYTEXT NOT NULL,  WeekEMA050Prediction TINYTEXT NOT NULL,  WeekSMA050Prediction TINYTEXT NOT NULL,\
	    WeekEMA100Prediction TINYTEXT NOT NULL,  WeekSMA100Prediction TINYTEXT NOT NULL,  WeekEMA200Prediction TINYTEXT NOT NULL,\
	      WeekSMA200Prediction TINYTEXT NOT NULL,  WeekIChiPrediction TINYTEXT NOT NULL,  WeekVWMAPrediction TINYTEXT NOT NULL,\
	        WeekHMAPrediction TINYTEXT NOT NULL,WeekBuy INT(11) NOT NULL,	WeekSell INT(11) NOT NULL,WeekNeutral INT(11) NOT NULL)")
mydb.commit()

#-----------------------------------------------------------------------------------------##
mycursor.execute("CREATE TABLE MonthTable(CurrentDate DATETIME  NOT NULL, \
	Symbol TINYTEXT NOT NULL, Price DOUBLE NOT NULL, \
	MonthRSIPrediction TINYTEXT NOT NULL, \
	MonthStochPrediction TINYTEXT NOT NULL,  \
	MonthCCIPrediction TINYTEXT NOT NULL,\
	MonthADIPrediction TINYTEXT NOT NULL, \
	MonthAOPrediction TINYTEXT NOT NULL, \
	MonthMomPrediction TINYTEXT NOT NULL,\
	MonthMACDPrediction TINYTEXT NOT NULL,\
	MonthStochRSIPrediction TINYTEXT NOT NULL,\
	MonthWillPrediction TINYTEXT NOT NULL,\
	MonthBullBearPrediction TINYTEXT NOT NULL,\
	MonthUltimateOPrediction TINYTEXT NOT NULL,\
	MonthEMA005Prediction TINYTEXT NOT NULL,\
	MonthSMA005Prediction TINYTEXT NOT NULL,  MonthEMA010Prediction TINYTEXT NOT NULL,  MonthSMA010Prediction TINYTEXT NOT NULL,\
	MonthEMA020Prediction TINYTEXT NOT NULL,  MonthSMA020Prediction TINYTEXT NOT NULL,  MonthEMA030Prediction TINYTEXT NOT NULL,\
	  MonthSMA030Prediction TINYTEXT NOT NULL,  MonthEMA050Prediction TINYTEXT NOT NULL,  MonthSMA050Prediction TINYTEXT NOT NULL,\
	    MonthEMA100Prediction TINYTEXT NOT NULL,  MonthSMA100Prediction TINYTEXT NOT NULL,  MonthEMA200Prediction TINYTEXT NOT NULL,\
	      MonthSMA200Prediction TINYTEXT NOT NULL,  MonthIChiPrediction TINYTEXT NOT NULL,  MonthVWMAPrediction TINYTEXT NOT NULL,\
	        MonthHMAPrediction TINYTEXT NOT NULL,MonthBuy INT(11) NOT NULL,	MonthSell INT(11) NOT NULL,MonthNeutral INT(11) NOT NULL)")
mydb.commit()




"""

mycursor.execute("INSERT INTO Hour1TableShort(CurrentDate, Symbol, Price, Hour1Buy, Hour1Sell,\
 Hour1Neutral ) VALUES ('2019-03-10 14:16:00','USDJPY',100,10,6,3)")

sql = "INSERT INTO Hour1TableShort(CurrentDate, Symbol, Price, Hour1Buy, Hour1Sell, Hour1Neutral) VALUES (%s, %s, %s, %s, %s, %s)"
val = ('2019-03-10 14:16:00','USDJPY',100,10,6,3)

mycursor.execute(sql,val)

mydb.commit()

sql = "INSERT INTO Hour1Table(CurrentDate, Symbol, Price,\
	Hour1RSIPrediction , \
	Hour1StochPrediction ,  \
	Hour1CCIPrediction ,\
	Hour1ADIPrediction , \
	Hour1AOPrediction , \
	Hour1MomPrediction ,\
	Hour1MACDPrediction ,\
	Hour1StochRSIPrediction ,\
	Hour1WillPrediction ,\
	Hour1BullBearPrediction ,\
	Hour1UltimateOPrediction ,\
	Hour1EMA005Prediction ,\
	Hour1SMA005Prediction ,  Hour1EMA010Prediction ,  Hour1SMA010Prediction ,\
	Hour1EMA020Prediction ,  Hour1SMA020Prediction ,  Hour1EMA030Prediction ,\
	  Hour1SMA030Prediction ,  Hour1EMA050Prediction ,  Hour1SMA050Prediction ,\
	    Hour1EMA100Prediction ,  Hour1SMA100Prediction ,  Hour1EMA200Prediction ,\
	      Hour1SMA200Prediction ,  Hour1IChiPrediction ,  Hour1VWMAPrediction ,\
	        Hour1HMAPrediction ,Hour1Buy ,	Hour1Sell ,Hour1Neutral )\
     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

val = ('2019-03-10 14:16:00','USDJPY',100,10,6,3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)

mycursor.execute(sql,val)
mydb.commit()


"""

def InsertDataIntoSql(TimeFrame,DataBase):
    for i in range(0, len(DataBase)):
        sql = "INSERT INTO " + TimeFrame +"Table(CurrentDate, Symbol, Price,\
        	" + TimeFrame +"RSIPrediction , \
        	" + TimeFrame +"StochPrediction ,  \
        	" + TimeFrame +"CCIPrediction ,\
        	" + TimeFrame +"ADIPrediction , \
        	" + TimeFrame +"AOPrediction , \
        	" + TimeFrame +"MomPrediction ,\
        	" + TimeFrame +"MACDPrediction ,\
        	" + TimeFrame +"StochRSIPrediction ,\
        	" + TimeFrame +"WillPrediction ,\
        	" + TimeFrame +"BullBearPrediction ,\
        	" + TimeFrame +"UltimateOPrediction ,\
        	" + TimeFrame +"EMA005Prediction ,\
        	" + TimeFrame +"SMA005Prediction ,  " + TimeFrame +"EMA010Prediction ,  " + TimeFrame +"SMA010Prediction ,\
        	" + TimeFrame +"EMA020Prediction ,  " + TimeFrame +"SMA020Prediction ,  " + TimeFrame +"EMA030Prediction ,\
        	  " + TimeFrame +"SMA030Prediction ,  " + TimeFrame +"EMA050Prediction ,  " + TimeFrame +"SMA050Prediction ,\
        	    " + TimeFrame +"EMA100Prediction ,  " + TimeFrame +"SMA100Prediction ,  " + TimeFrame +"EMA200Prediction ,\
        	      " + TimeFrame +"SMA200Prediction ,  " + TimeFrame +"IChiPrediction ,  " + TimeFrame +"VWMAPrediction ,\
        	        " + TimeFrame +"HMAPrediction ," + TimeFrame +"Buy ,	" + TimeFrame +"Sell ," + TimeFrame +"Neutral )\
             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        
        val = (DataBase['Date'][i],DataBase['Symbol'][i],DataBase['Price'][i],	DataBase[TimeFrame +"RSIPrediction"][i], \
    	DataBase[TimeFrame +"StochPrediction"][i],  \
    	DataBase[TimeFrame +"CCIPrediction"][i],\
    	DataBase[TimeFrame +"ADIPrediction"][i], \
    	DataBase[TimeFrame +"AOPrediction"][i], \
    	DataBase[TimeFrame +"MomPrediction"][i],\
    	DataBase[TimeFrame +"MACDPrediction"][i],\
    	DataBase[TimeFrame +"StochRSIPrediction"][i],\
    	DataBase[TimeFrame +"WillPrediction"][i],\
    	DataBase[TimeFrame +"BullBearPrediction"][i],\
    	DataBase[TimeFrame +"UltimateOPrediction"][i],\
    	DataBase[TimeFrame +"EMA005Prediction"][i],\
    	DataBase[TimeFrame +"SMA005Prediction"][i],  DataBase[TimeFrame +"EMA010Prediction"][i],  DataBase[TimeFrame +"SMA010Prediction"][i],\
    	DataBase[TimeFrame +"EMA020Prediction"][i],  DataBase[TimeFrame +"SMA020Prediction"][i],  DataBase[TimeFrame +"EMA030Prediction"][i],\
    	  DataBase[TimeFrame +"SMA030Prediction"][i],  DataBase[TimeFrame +"EMA050Prediction"][i],  DataBase[TimeFrame +"SMA050Prediction"][i],\
    	    DataBase[TimeFrame +"EMA100Prediction"][i],  DataBase[TimeFrame +"SMA100Prediction"][i],  DataBase[TimeFrame +"EMA200Prediction"][i],\
    	      DataBase[TimeFrame +"SMA200Prediction"][i],  DataBase[TimeFrame +"IChiPrediction"][i],  DataBase[TimeFrame +"VWMAPrediction"][i],\
    	        DataBase[TimeFrame +"HMAPrediction"][i],int(DataBase[TimeFrame +"Buy"][i]),	int(DataBase[TimeFrame +"Sell"][i]),int(DataBase[TimeFrame +"Neutral"][i]))
    
        mycursor.execute(sql,val)
        mydb.commit()

def FillingEveryDatabase():
    InsertDataIntoSql('Hour1',DB)
    print("20%")
    InsertDataIntoSql('Hour4',DB)
    print("40%")
    InsertDataIntoSql('Day',DB)
    print("60%")
    InsertDataIntoSql('Week',DB)
    print("80%")
    InsertDataIntoSql('Month',DB)
    print("100%")