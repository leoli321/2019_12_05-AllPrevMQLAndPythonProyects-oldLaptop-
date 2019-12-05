# -*- coding: utf-8 -*-
"""
Created on Fri Apr 12 11:21:35 2019

@author: gvega
"""
#GET WEBPAGE DATA

def GetData(CurrentSymbol):
    ###PREPARATIONS
    from selenium import webdriver
    from bs4 import BeautifulSoup
    import re
    import pandas as pd
    from selenium.webdriver.support.ui import Select
    import time
    import datetime
    import os
    os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper')
    Date = []
    Symbol = []
    Price = []
    Hour4PredictionBuy = []
    Hour4PredictionSell = []
    Hour4PredictionNeutral = []
    DayPredictionBuy = []
    DayPredictionSell = []
    DayPredictionNeutral = []
    WeekPredictionBuy = []
    WeekPredictionSell = []
    WeekPredictionNeutral = []
    MonthPredictionBuy = []
    MonthPredictionSell = []
    MonthPredictionNeutral = []
    
    #ANALYZYNGDBDATA
    Hour4Desition = []
    DayDesition = []
    WeekDesition = []
    MonthDesition = []    
    ###PREPARATIONS
    try:
        PrevDatabase = pd.read_csv('TradingViewDataBase.csv')
        for i in range(0, len(PrevDatabase)):
            Date.append(PrevDatabase['Date'][i])
            Symbol.append(PrevDatabase['Symbol'][i])
            Price.append(PrevDatabase['Price'][i])
            Hour4PredictionBuy.append(PrevDatabase['Hour4Buy'][i])
            Hour4PredictionSell.append( PrevDatabase['Hour4Sell'][i])
            Hour4PredictionNeutral.append( PrevDatabase['Hour4Neutral'][i])
            DayPredictionBuy.append( PrevDatabase['DayBuy'][i])
            DayPredictionSell.append( PrevDatabase['DaySell'][i])
            DayPredictionNeutral.append( PrevDatabase['DayNeutral'][i])
            WeekPredictionBuy.append( PrevDatabase['WeekBuy'][i])
            WeekPredictionSell.append( PrevDatabase['WeekSell'][i])
            WeekPredictionNeutral.append( PrevDatabase['WeekNeutral'][i])
            MonthPredictionBuy.append( PrevDatabase['MonthBuy'][i])
            MonthPredictionSell.append( PrevDatabase['MonthSell'][i])
            MonthPredictionNeutral.append( PrevDatabase['MonthNeutral'][i])    
    except:
        print('Except1')
        pass    
    url = 'https://www.tradingview.com/symbols/' +CurrentSymbol+'/technicals/'
    driver = webdriver.Chrome(r"C:\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper\chromedriver_win32\chromedriver.exe")
    driver.implicitly_wait(300)
    driver.get(url)
    soup=BeautifulSoup(driver.page_source, 'lxml')# Parse the HTML as a string
    #END WEBPAGE DATA
    '''
    We have to get it again in the loop btw... this is to get the price.
    '''
    
    #Select timeframe. 0 = 1min, 1 = 5min, 5 = 1day, etc...
    select = (driver.find_elements_by_class_name('itemContent-OyUxIzTS-'))#.click()
    
    driver.maximize_window()
    
    #APPENDING DATE
    now = time.strftime('%Y/%m/%d %H:%M:%S')
    StringNow = str(now)
    Date.append(StringNow)
    #APPENDING DATE END
    
    def GetPrice():    
        StartPriceStr = str(soup).find("large js-symbol-last")
        EndPriceStr = str(soup).find('tv-data-mode tv-data-mode--size')
        Price = str(soup)[StartPriceStr+22:EndPriceStr-21]
        return((Price))
    
    CurrentPrice = GetPrice()
    Price.append(CurrentPrice)
    Symbol.append(CurrentSymbol)
    
    for i in range(4,8):
        select[i].click()    
        driver.implicitly_wait(3000)
        time.sleep(2)
        soup=BeautifulSoup(driver.page_source, 'lxml')# Parse the HTML as a string
        select = (driver.find_elements_by_class_name('itemContent-OyUxIzTS-'))#.click()
        #Get values
        table = soup.find_all('table')
        BuyIncidences = [m.start() for m in re.finditer('Buy',str(table))]
        SellIncidences = [m.start() for m in re.finditer('Sell',str(table))]
        NeutralIncidences = [m.start() for m in re.finditer('Neutral',str(table))]
        
        BuyAmmount = len(BuyIncidences)
        SellAmmount = len(SellIncidences)
        NeutralAmmount = len(NeutralIncidences)
        print(i)
        
        if (i == 4):
            Hour4PredictionBuy.append(BuyAmmount)
            Hour4PredictionSell.append(SellAmmount)
            Hour4PredictionNeutral.append(NeutralAmmount)
        elif (i == 5):
            DayPredictionBuy.append(BuyAmmount)
            DayPredictionSell.append(SellAmmount)
            DayPredictionNeutral.append(NeutralAmmount)
        elif (i == 6):
            WeekPredictionBuy.append(BuyAmmount)
            WeekPredictionSell.append(SellAmmount)
            WeekPredictionNeutral.append(NeutralAmmount)   
        elif(i == 7):
            MonthPredictionBuy.append(BuyAmmount)
            MonthPredictionSell.append(SellAmmount)
            MonthPredictionNeutral.append(NeutralAmmount)   
    
    driver.quit()
    
    Database = pd.DataFrame()
    Database['Date'] = Date
    Database['Symbol'] = Symbol
    Database['Price'] = Price
    Database['Hour4Buy'] = Hour4PredictionBuy
    Database['Hour4Sell'] = Hour4PredictionSell
    Database['Hour4Neutral'] = Hour4PredictionNeutral
    Database['DayBuy'] = DayPredictionBuy
    Database['DaySell'] = DayPredictionSell
    Database['DayNeutral'] = DayPredictionNeutral
    Database['WeekBuy'] = WeekPredictionBuy
    Database['WeekSell'] = WeekPredictionSell
    Database['WeekNeutral'] = WeekPredictionNeutral
    Database['MonthBuy'] = MonthPredictionBuy
    Database['MonthSell'] = MonthPredictionSell
    Database['MonthNeutral'] = MonthPredictionNeutral
    Database['Date'] = Date
    #AnalyzingDBData
    Database['Hour4Desition'] = ['CALCULATING'] * len(Database)
    Database['DayDesition'] = ['CALCULATING'] * len(Database)
    Database['WeekDesition'] = ['CALCULATING'] * len(Database)
    Database['MonthDesition'] = ['CALCULATING'] * len(Database)
    #DELTATIMECHACKANDRESULT
    try:
        Hour4PeriodStatus = PrevDatabase['Hour4PeriodStatus']
        Hour4ClosingPrice = PrevDatabase['Hour4ClosingPrice']
        DayPeriodStatus = PrevDatabase['DayPeriodStatus']
        DayClosingPrice = PrevDatabase['DayClosingPrice']
        WeekPeriodStatus = PrevDatabase['WeekPeriodStatus']
        WeekClosingPrice = PrevDatabase['WeekClosingPrice']
        MonthPeriodStatus = PrevDatabase['MonthPeriodStatus']
        MonthClosingPrice = PrevDatabase['MonthClosingPrice']
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
    
    Database.to_csv('TradingViewDataBase.csv')
    
##################################################################################################################
# NOW ITS LOOP TIME #
##################################################################################################################
