# -*- coding: utf-8 -*-
"""
Created on Sat Apr 13 19:31:23 2019

@author: gvega
"""

def DeltaTimeCheckAndResult(TimePeriod, TimePeriodClosingPrice):
    import os
    import pandas as pd
    import datetime
    os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')
    
    try:
        Database = pd.read_csv('TradingViewDataBase.csv')
    except:
        print('No-Db-Found')
        pass
    
    try:
        Hour4PeriodStatus = Database['Hour4PeriodStatus']
        Hour4ClosingPrice = Database['Hour4ClosingPrice']
        DayPeriodStatus = Database['DayPeriodStatus']
        DayClosingPrice = Database['DayClosingPrice']
        WeekPeriodStatus = Database['WeekPeriodStatus']
        WeekClosingPrice = Database['WeekClosingPrice']
        MonthPeriodStatus = Database['MonthPeriodStatus']
        MonthClosingPrice = Database['MonthClosingPrice']
    except:
        Hour4PeriodStatus = ['PENDING'] * len(Database)
        Hour4ClosingPrice = ['PENDING'] * len(Database)
        DayPeriodStatus = ['PENDING'] * len(Database)
        DayClosingPrice = ['PENDING'] * len(Database)
        WeekPeriodStatus = ['PENDING'] * len(Database)
        WeekClosingPrice = ['PENDING'] * len(Database)
        MonthPeriodStatus = ['PENDING'] * len(Database)
        MonthClosingPrice = ['PENDING'] * len(Database)
    
    Database['Hour4PeriodStatus'] = Hour4PeriodStatus
    Database['Hour4ClosingPrice'] = Hour4ClosingPrice
    Database['DayPeriodStatus'] = DayPeriodStatus
    Database['DayClosingPrice'] = DayClosingPrice
    Database['WeekPeriodStatus'] = WeekPeriodStatus
    Database['WeekClosingPrice'] = WeekClosingPrice
    Database['MonthPeriodStatus'] = MonthPeriodStatus
    Database['MonthClosingPrice'] = MonthClosingPrice
    """
    Nota quiero hacer una storage database para no tener que volver a escribir todo
    una vez que la base de datos actual sea grande. Se borra lo que ya terminó de
    la Database y se pasa a StorageDatabase, luego ya podemos sortear o hacer lo que sea.
    """
    
    try:
        for i in range(0, len(Database)):
            Database['Date'][i] = datetime.datetime.strptime(Database['Date'][i], '%Y-%m-%d %H:%M:%S')
    except:
        print('Except Date conversion')
        pass
    
    
    def TestDelta(TimePeriod, TimePeriodClosingPrice):
        if(TimePeriod == 'Hour4PeriodStatus'):
            RequiredDelta = datetime.timedelta(0,14400)
        elif(TimePeriod == 'DayPeriodStatus'):
            RequiredDelta = datetime.timedelta(1,0)
        elif(TimePeriod == 'WeekPeriodStatus'):
            RequiredDelta = datetime.timedelta(7,0)
        elif(TimePeriod == 'MonthPeriodStatus'):
            RequiredDelta = datetime.timedelta(30,0)
            
        for i in range(0,len(Database)):
            if( Database[TimePeriod][i] == 'PENDING'):
                Delta = Database['Date'][len(Database)-1] - Database['Date'][i]
                if(Delta > RequiredDelta): #Timedelta
                    Database[TimePeriod][i] = "CLOSED"
                    Database[TimePeriodClosingPrice][i] = Database['Price'][len(Database)-1]
            
    
    TestDelta('Hour4PeriodStatus','Hour4ClosingPrice')
    TestDelta('DayPeriodStatus','DayClosingPrice')
    TestDelta('WeekPeriodStatus','WeekClosingPrice')
    TestDelta('MonthPeriodStatus','MonthClosingPrice')
    
    Database.to_csv('TradingViewDataBase.csv')


