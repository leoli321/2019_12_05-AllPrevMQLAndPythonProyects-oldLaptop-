# -*- coding: utf-8 -*-
"""
Created on Sat Apr 13 07:53:13 2019

@author: gvega
"""

"""
GettingBuy and sell signals
"""

def AnalyzingDBData():
    import os
    import pandas as pd
    import datetime
    os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')
    
    try:
        Database = pd.read_csv('TradingViewDataBase.csv')
    except:
        print('No-Db-Found')
        pass
    
    
    #PASS TIME STRING TO DATETIME AND GET CURRENT-TIMEDELTA.#
    for i in range(0, len(Database)):
        try:
            Database['Date'][i] = datetime.datetime.strptime(Database['Date'][i], '%d/%m/%Y %H:%M')
        except:
            try:
                Database['Date'][i] = datetime.datetime.strptime(Database['Date'][i], '%Y/%m/%d %H:%M:%S')
            except:
                Database['Date'][i] = datetime.datetime.strptime(Database['Date'][i], '%Y-%m-%d %H:%M:%S')        
    #PASS TIME STRING TO DATETIME AND GET CURRENT-TIMEDELTA. END#
    
    Hour4Desition = []
    DayDesition = []
    WeekDesition = []
    MonthDesition = []
    
    ####Get desition by simple mayority
    for i in range(0,len(Database)):
        if( (Database['Hour4Buy'][i] > Database['Hour4Sell'][i]) and (Database['Hour4Buy'][i] > Database['Hour4Neutral'][i])   ):
            Hour4Desition.append('BUY')
        elif (   (Database['Hour4Sell'][i] > Database['Hour4Buy'][i])  and (Database['Hour4Sell'][i] > Database['Hour4Neutral'][i]) ):
            Hour4Desition.append('SELL')
        else:
            Hour4Desition.append('NEUTRAL')
            
        if( (Database['DayBuy'][i] > Database['DaySell'][i]) and (Database['DayBuy'][i] > Database['DayNeutral'][i])   ):
            DayDesition.append('BUY')
        elif (   (Database['DaySell'][i] > Database['DayBuy'][i])  and (Database['DaySell'][i] > Database['DayNeutral'][i]) ):
            DayDesition.append('SELL')
        else:
            DayDesition.append('NEUTRAL')
    
        if( (Database['WeekBuy'][i] > Database['WeekSell'][i]) and (Database['WeekBuy'][i] > Database['WeekNeutral'][i])   ):
            WeekDesition.append('BUY')
        elif (   (Database['WeekSell'][i] > Database['WeekBuy'][i])  and (Database['WeekSell'][i] > Database['WeekNeutral'][i]) ):
            WeekDesition.append('SELL')
        else:
            WeekDesition.append('NEUTRAL')
    
        if( (Database['MonthBuy'][i] > Database['MonthSell'][i]) and (Database['MonthBuy'][i] > Database['MonthNeutral'][i])   ):
            MonthDesition.append('BUY')
        elif (   (Database['MonthSell'][i] > Database['MonthBuy'][i])  and (Database['MonthSell'][i] > Database['MonthNeutral'][i]) ):
            MonthDesition.append('SELL')
        else:
            MonthDesition.append('NEUTRAL')        
            
    ####Get desition by simple mayority    
        
    Database['Hour4Desition'] = Hour4Desition
    Database['DayDesition'] = DayDesition
    Database['WeekDesition'] = WeekDesition
    Database['MonthDesition'] = MonthDesition
    
    Database.to_csv('TradingViewDataBase.csv')

AnalyzingDBData()
