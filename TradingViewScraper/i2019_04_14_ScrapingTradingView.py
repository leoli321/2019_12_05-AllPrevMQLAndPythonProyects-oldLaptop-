# -*- coding: utf-8 -*-
"""
Created on Sun Apr 14 13:01:32 2019

@author: gvega
"""

def GetTVData(DBName,Symbol):
    from selenium import webdriver
    from bs4 import BeautifulSoup
    import re
    import pandas as pd
    import time
    
    
    now = time.strftime('%Y/%m/%d %H:%M:%S')
    StringNow = str(now)
    
    ###SCRAPING TD
    url = 'https://www.tradingview.com/symbols/' + Symbol +'/technicals/'
    driver = webdriver.Chrome(r"C:\Users\gvega\Google Drive\MQL4 + Python\TradingViewScraper\chromedriver_win32\chromedriver.exe")
    driver.implicitly_wait(300)
    time.sleep(5)
    driver.get(url)
    soup=BeautifulSoup(driver.page_source, 'lxml')# Parse the HTML as a string
    #END WEBPAGE DATA
    '''
    We have to get it again in the loop btw... this is to get the price.
    '''
    
    #Select timeframe. 0 = 1min, 1 = 5min, 5 = 1day, etc...
    select = (driver.find_elements_by_class_name('itemContent-OyUxIzTS-'))#.click()
    
    driver.maximize_window()
    
    def GetPrice():    
        StartPriceStr = str(soup).find("large js-symbol-last")
        EndPriceStr = str(soup).find('tv-data-mode tv-data-mode--size')
        Price = str(soup)[StartPriceStr+22:EndPriceStr-21]
        BeforeDot = Price[0:(Price.find('.'))]
        AfterDot = Price[(Price.find('.')):((len(Price)))]
        BeforeDot = re.sub("\D", "", BeforeDot)
        Price = BeforeDot + AfterDot
        return(Price)
    
    CurrentPrice = GetPrice()
    
    for i in range(3,8):
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
            
            if (i == 3):
                Hour1PredictionBuy = (BuyAmmount)
                Hour1PredictionSell = (SellAmmount)
                Hour1PredictionNeutral = (NeutralAmmount)
            if (i == 4):
                Hour4PredictionBuy = (BuyAmmount)
                Hour4PredictionSell = (SellAmmount)
                Hour4PredictionNeutral = (NeutralAmmount)
            elif (i == 5):
                DayPredictionBuy = (BuyAmmount)
                DayPredictionSell = (SellAmmount)
                DayPredictionNeutral = (NeutralAmmount)
            elif (i == 6):
                WeekPredictionBuy = (BuyAmmount)
                WeekPredictionSell = (SellAmmount)
                WeekPredictionNeutral = (NeutralAmmount)   
            elif(i == 7):
                MonthPredictionBuy = (BuyAmmount)
                MonthPredictionSell = (SellAmmount)
                MonthPredictionNeutral = (NeutralAmmount)   
        
    driver.quit()
    ###SCRAPING TD END
    
    #CurrentData
    CurrentData = pd.DataFrame()
    CurrentData['Date'] = [StringNow]
    CurrentData['Symbol'] = Symbol
    CurrentData['Price'] = CurrentPrice
    CurrentData['Hour1Buy'] = Hour1PredictionBuy
    CurrentData['Hour1Sell'] = Hour1PredictionSell
    CurrentData['Hour1Neutral'] = Hour1PredictionNeutral
    CurrentData['Hour4Buy'] = Hour4PredictionBuy
    CurrentData['Hour4Sell'] = Hour4PredictionSell
    CurrentData['Hour4Neutral'] = Hour4PredictionNeutral
    CurrentData['DayBuy'] = DayPredictionBuy
    CurrentData['DaySell'] = DayPredictionSell
    CurrentData['DayNeutral'] = DayPredictionNeutral
    CurrentData['WeekBuy'] = WeekPredictionBuy
    CurrentData['WeekSell'] = WeekPredictionSell
    CurrentData['WeekNeutral'] = WeekPredictionNeutral
    CurrentData['MonthBuy'] = MonthPredictionBuy
    CurrentData['MonthSell'] = MonthPredictionSell
    CurrentData['MonthNeutral'] = MonthPredictionNeutral
    #AnalyzingDBData
    CurrentData['Hour1Desition'] = ['CALCULATING']
    CurrentData['Hour4Desition'] = ['CALCULATING']
    CurrentData['DayDesition'] = ['CALCULATING']
    CurrentData['WeekDesition'] = ['CALCULATING']
    CurrentData['MonthDesition'] = ['CALCULATING']
    #DELTATIMECHACKANDRESULT
    CurrentData['Hour1PeriodStatus'] = ['PENDING']
    CurrentData['Hour1ClosingPrice'] = ['PENDING']    
    CurrentData['Hour4PeriodStatus'] = ['PENDING']
    CurrentData['Hour4ClosingPrice'] = ['PENDING']
    CurrentData['DayPeriodStatus'] =['PENDING']
    CurrentData['DayClosingPrice'] = ['PENDING']
    CurrentData['WeekPeriodStatus'] = ['PENDING']
    CurrentData['WeekClosingPrice'] = ['PENDING']
    CurrentData['MonthPeriodStatus'] = ['PENDING']
    CurrentData['MonthClosingPrice'] = ['PENDING']    
    CurrentData['Hour1Accuracy'] = ['PENDING']
    CurrentData['Hour1ProfitPercentage'] = ['PENDING']  
    CurrentData['Hour4Accuracy'] = ['PENDING']
    CurrentData['Hour4ProfitPercentage'] = ['PENDING']        
    CurrentData['DayAccuracy'] = ['PENDING']
    CurrentData['DayProfitPercentage'] = ['PENDING']            
    CurrentData['WeekAccuracy'] = ['PENDING']
    CurrentData['WeekProfitPercentage'] = ['PENDING']            
    CurrentData['MonthAccuracy'] = ['PENDING']
    CurrentData['MonthProfitPercentage'] = ['PENDING']            
    
    
    #CurrentData
    
    try:
        Database = pd.read_csv(DBName)  
        Database = Database.append(CurrentData)
        Database.to_csv(DBName, index = False)
    except:
        print('No Actual Database...Creating.')
        Database = pd.DataFrame()
        Database = CurrentData
        Database.to_csv(DBName, index = False)
    
    
    