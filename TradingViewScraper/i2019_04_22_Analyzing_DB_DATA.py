# -*- coding: utf-8 -*-
"""
Created on Sun Apr 14 14:19:30 2019

@author: gvega
"""



def AnalyzingDBData(DBName):
    import pandas as pd
    import datetime
    
    try:
        Database = pd.read_csv(DBName)
    except:
        print('No-Db-Found')
        pass
    
    pd.options.mode.chained_assignment = None
    #pd.options.mode.chained_assignment = Warning
    
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
    
    
    ####Get desition by simple mayority
    for i in range(0,len(Database)):
        
        if( (Database['Hour1Buy'][i] > Database['Hour1Sell'][i]) and (Database['Hour1Buy'][i] > Database['Hour1Neutral'][i])   ):
            Database['Hour1Desition'][i] = 'BUY'
        elif (   (Database['Hour1Sell'][i] > Database['Hour1Buy'][i])  and (Database['Hour1Sell'][i] > Database['Hour1Neutral'][i]) ):
            Database['Hour1Desition'][i] = 'SELL'
        else:
            Database['Hour1Desition'][i] = 'NEUTRAL'
            
        if( (Database['Hour4Buy'][i] > Database['Hour4Sell'][i]) and (Database['Hour4Buy'][i] > Database['Hour4Neutral'][i])   ):
            Database['Hour4Desition'][i] = 'BUY'
        elif (   (Database['Hour4Sell'][i] > Database['Hour4Buy'][i])  and (Database['Hour4Sell'][i] > Database['Hour4Neutral'][i]) ):
            Database['Hour4Desition'][i] = 'SELL'
        else:
            Database['Hour4Desition'][i] = 'NEUTRAL'
        
        if( (Database['DayBuy'][i] > Database['DaySell'][i]) and (Database['DayBuy'][i] > Database['DayNeutral'][i])   ):
            Database['DayDesition'][i] = 'BUY'
        elif (   (Database['DaySell'][i] > Database['DayBuy'][i])  and (Database['DaySell'][i] > Database['DayNeutral'][i]) ):
            Database['DayDesition'][i] = 'SELL'
        else:
            Database['DayDesition'][i] = 'NEUTRAL'  
            
        if( (Database['WeekBuy'][i] > Database['WeekSell'][i]) and (Database['WeekBuy'][i] > Database['WeekNeutral'][i])   ):
            Database['WeekDesition'][i] = 'BUY'
        elif (   (Database['WeekSell'][i] > Database['WeekBuy'][i])  and (Database['WeekSell'][i] > Database['WeekNeutral'][i]) ):
            Database['WeekDesition'][i] = 'SELL'
        else:
            Database['WeekDesition'][i] = 'NEUTRAL'
        
        if( (Database['MonthBuy'][i] > Database['MonthSell'][i]) and (Database['MonthBuy'][i] > Database['MonthNeutral'][i])   ):
            Database['MonthDesition'][i] = 'BUY'
        elif (   (Database['MonthSell'][i] > Database['MonthBuy'][i])  and (Database['MonthSell'][i] > Database['MonthNeutral'][i]) ):
            Database['MonthDesition'][i] = 'SELL'
        else:
            Database['MonthDesition'][i] = 'NEUTRAL'            
      
            
    ####Get desition by simple mayority    
    
    Database.to_csv(DBName, index = False)
