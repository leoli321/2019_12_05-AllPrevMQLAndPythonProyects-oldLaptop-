# -*- coding: utf-8 -*-
"""
Created on Tue Jun 18 21:43:01 2019

@author: gvega
"""
import os
os.chdir('C:\\Users\gvega\Google Drive\MQL4 + Python\ForexFactoryScraper')

def GetForexFactoryData(DBName,Symbol):
    from selenium import webdriver
    import pandas as pd
    import time
    from selenium.webdriver.common.keys import Keys
    
    
    url = 'https://www.forexfactory.com/'
    driver = webdriver.Chrome(r"C:\Users\gvega\Google Drive\MQL4 + Python\ForexFactoryScraper\chromedriver_win32\chromedriverv71.exe")
    driver.implicitly_wait(300)
    time.sleep(5)
    driver.get(url)
    #END WEBPAGE DATA
    
    ####GET PRICE#####
    
    SelectPrice = (driver.find_elements_by_class_name('currency'))
    SelectPrice[1].click()
    textboxPrice = driver.find_elements_by_class_name('ui-autocomplete-input') 
    driver.implicitly_wait(300)
    time.sleep(2)
    textboxPrice[0].send_keys(Symbol)
    driver.implicitly_wait(300)
    time.sleep(2)
    textboxPrice[0].send_keys(Keys.ENTER)
    driver.implicitly_wait(300)
    time.sleep(2)    
    PriceWebElement = driver.find_elements_by_class_name('market__scanner-column--bid')
    Price = PriceWebElement[0].text
    ###GET PRICE######
    
    
    select = (driver.find_elements_by_class_name('flexExternalOption'))
    select[2].click()
    textbox = driver.find_elements_by_class_name('ui-autocomplete-input')
    driver.implicitly_wait(300)
    time.sleep(2)
    textbox[10].send_keys(Symbol)
    driver.implicitly_wait(300)
    time.sleep(2)
    textbox[10].send_keys(Keys.ENTER)
    driver.implicitly_wait(300)
    time.sleep(2)

    
    LongShortRatioBars = driver.find_elements_by_class_name('trades_position__bars')
    
    LongShortRatioBars[4].click()
    
    TablesLong = driver.find_elements_by_class_name('positiondetails__long')
    TablesShort = driver.find_elements_by_class_name('positiondetails__short')
    
     
    
    LongTraderNumber = TablesLong[0].text
    LongLotNumber = TablesLong[1].text
    LongAverageEntry = TablesLong[2].text
    ShortTraderNumber = TablesShort[0].text
    ShortLotNumber = TablesShort[1].text
    ShortAverageEntry = TablesShort[2].text
    
    now = time.strftime('%Y/%m/%d %H:%M:%S')
    StringNow = str(now)    
    
    CurrentData = pd.DataFrame()
    CurrentData['Date'] = [StringNow]
    CurrentData['Symbol'] = [Symbol]
    CurrentData['Price'] = [Price]
    CurrentData['LongTraderNumber'] = [LongTraderNumber]
    CurrentData['LongLotNumber'] = [LongLotNumber]
    CurrentData['LongAverageEntry'] = [LongAverageEntry]
    CurrentData['ShortTraderNumber'] = [ShortTraderNumber]
    CurrentData['ShortLotNumber'] = [ShortLotNumber]
    CurrentData['ShortAverageEntry'] = [ShortAverageEntry]    
    
    driver.quit()
    
    try:
        Database = pd.read_csv(DBName)  
        Database = Database.append(CurrentData)
        Database.to_csv(DBName, index = False)
    except:
        print('No Actual Database...Creating.')
        Database = pd.DataFrame()
        Database = CurrentData
        Database.to_csv(DBName, index = False)
    
    
#########################################################################
        
SymbolDB = ["EURCHF","GBPJPY","USDMXN","EURGBP","EURUSD","GBPCAD","CADJPY","CHFJPY","USDCHF",
                "USDJPY","EURJPY","EURCAD","GBPUSD","USDCAD"]

DBName = 'ForexFactoryLongShortRatioDB.csv'
def BuildingForexDatabase(DBName):
    for i in range(0, len(SymbolDB)):
        GetForexFactoryData(DBName,SymbolDB[i])
        print(i/len(SymbolDB))
    
    
BuildingForexDatabase(DBName)

