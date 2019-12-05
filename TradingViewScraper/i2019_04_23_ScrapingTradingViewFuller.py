# -*- coding: utf-8 -*-
"""
Created on Tue Apr 23 13:26:27 2019

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
    
    driver.execute_script("window.scrollTo(0,550)")
    #driver.maximize_window()
    
    def GetPrice():    
        StartPriceDiv = soup.find("header")
        Price = StartPriceDiv.find_all('div')[23].text
        return(Price)
    
    CurrentPrice = GetPrice()
    CurrentData = pd.DataFrame()
    CurrentData['Date'] = [StringNow]
    CurrentData['Symbol'] = [Symbol]
    CurrentData['Price'] = [CurrentPrice]
    for i in range(3,8):
            if(i < 8):
                select = (driver.find_elements_by_class_name('itemContent-OyUxIzTS-'))
                select[i].click()
            else: #Esto es porque antes en ubuntu no te dejaba agarrarlo sin hacer esto, pero luego se arregló solo...
                select = (driver.find_elements_by_class_name('itemContent-OyUxIzTS-'))
                select[6].click()
                select = (driver.find_elements_by_class_name('dropdownListItemNotActive-2dmeXX-V-'))
                select[i-6].click()
            
             
            driver.implicitly_wait(3000)
            time.sleep(2)
            soup=BeautifulSoup(driver.page_source, 'lxml')# Parse the HTML as a string
            #Get values
            table = soup.find_all('table')
            BuyIncidences = [m.start() for m in re.finditer('Buy',str(table))]
            SellIncidences = [m.start() for m in re.finditer('Sell',str(table))]
            NeutralIncidences = [m.start() for m in re.finditer('Neutral',str(table))]
            
            BuyAmmount = len(BuyIncidences)
            SellAmmount = len(SellIncidences)
            NeutralAmmount = len(NeutralIncidences)
            
            
            
            #GET ALL THE DATA##################GET ALL THE DATA
            Oscilators = pd.DataFrame()
            for n in range(0, (len(table[0].find_all('td'))) ):
                if ( ((table[0].find_all('td')[n].text) == 'Neutral') or ((table[0].find_all('td')[n].text) == 'Sell') or ((table[0].find_all('td')[n].text) == 'Buy')  ):
                    Current = pd.DataFrame() 
                    Current = ( table[0].find_all('td')[n].text )
                    Oscilators = Oscilators.append([Current] , ignore_index = True )
                    
                    #Getting the moving averages
            MovingAverages = pd.DataFrame() 
            for n in range(0, (len(table[1].find_all('td'))) ):
                if ( ((table[1].find_all('td')[n].text) == 'Neutral') or ((table[1].find_all('td')[n].text) == 'Sell') or ((table[1].find_all('td')[n].text) == 'Buy') or ( (n%3 == 2) and ((table[1].find_all('td')[n].text) == '—')) ):
                    Current = pd.DataFrame() 
                    Current = ( table[1].find_all('td')[n].text )
                    MovingAverages = MovingAverages.append([Current] , ignore_index = True )
            
            #END-GET ALL THE DATA##################END-GET ALL THE DATA
        
            if (i == 3):
                Hour1PredictionBuy = (BuyAmmount)
                Hour1PredictionSell = (SellAmmount)
                Hour1PredictionNeutral = (NeutralAmmount)
                #Oscilators Hour1
                CurrentData['Hour1RSIPrediction'] = Oscilators[0][0]
                CurrentData['Hour1StochPrediction'] = Oscilators[0][1]
                CurrentData['Hour1CCIPrediction'] = Oscilators[0][2]
                CurrentData['Hour1ADIPrediction'] = Oscilators[0][3]
                CurrentData['Hour1AOPrediction'] = Oscilators[0][4]
                CurrentData['Hour1MomPrediction'] = Oscilators[0][5]
                CurrentData['Hour1MACDPrediction'] = Oscilators[0][6]
                CurrentData['Hour1StochRSIPrediction'] = Oscilators[0][7]
                CurrentData['Hour1WillPrediction'] = Oscilators[0][8]
                CurrentData['Hour1BullBearPrediction'] = Oscilators[0][9]
                CurrentData['Hour1UltimateOPrediction'] = Oscilators[0][10]
                #MovingAverages Hour1
                CurrentData['Hour1EMA005Prediction'] = MovingAverages[0][0]
                CurrentData['Hour1SMA005Prediction'] = MovingAverages[0][1]
                CurrentData['Hour1EMA010Prediction'] = MovingAverages[0][2]
                CurrentData['Hour1SMA010Prediction'] = MovingAverages[0][3]
                CurrentData['Hour1EMA020Prediction'] = MovingAverages[0][4]
                CurrentData['Hour1SMA020Prediction'] = MovingAverages[0][5]
                CurrentData['Hour1EMA030Prediction'] = MovingAverages[0][6]
                CurrentData['Hour1SMA030Prediction'] = MovingAverages[0][7]
                CurrentData['Hour1EMA050Prediction'] = MovingAverages[0][8]
                CurrentData['Hour1SMA050Prediction'] = MovingAverages[0][9]
                CurrentData['Hour1EMA100Prediction'] = MovingAverages[0][10]
                CurrentData['Hour1SMA100Prediction'] = MovingAverages[0][11]
                CurrentData['Hour1EMA200Prediction'] = MovingAverages[0][12]
                CurrentData['Hour1SMA200Prediction'] = MovingAverages[0][13]
                CurrentData['Hour1IChiPrediction'] = MovingAverages[0][14]
                CurrentData['Hour1VWMAPrediction'] = MovingAverages[0][15]
                CurrentData['Hour1HMAPrediction'] = MovingAverages[0][16]  
                
            if (i == 4):
                Hour4PredictionBuy = (BuyAmmount)
                Hour4PredictionSell = (SellAmmount)
                Hour4PredictionNeutral = (NeutralAmmount)     
                #Oscilators Hour4     
                CurrentData['Hour4RSIPrediction'] = Oscilators[0][0]
                CurrentData['Hour4StochPrediction'] = Oscilators[0][1]
                CurrentData['Hour4CCIPrediction'] = Oscilators[0][2]
                CurrentData['Hour4ADIPrediction'] = Oscilators[0][3]
                CurrentData['Hour4AOPrediction'] = Oscilators[0][4]
                CurrentData['Hour4MomPrediction'] = Oscilators[0][5]
                CurrentData['Hour4MACDPrediction'] = Oscilators[0][6]
                CurrentData['Hour4StochRSIPrediction'] = Oscilators[0][7]
                CurrentData['Hour4WillPrediction'] = Oscilators[0][8]
                CurrentData['Hour4BullBearPrediction'] = Oscilators[0][9]
                CurrentData['Hour4UltimateOPrediction'] = Oscilators[0][10]
                #MovingAverages Hour4
                CurrentData['Hour4EMA005Prediction'] = MovingAverages[0][0]
                CurrentData['Hour4SMA005Prediction'] = MovingAverages[0][1]
                CurrentData['Hour4EMA010Prediction'] = MovingAverages[0][2]
                CurrentData['Hour4SMA010Prediction'] = MovingAverages[0][3]
                CurrentData['Hour4EMA020Prediction'] = MovingAverages[0][4]
                CurrentData['Hour4SMA020Prediction'] = MovingAverages[0][5]
                CurrentData['Hour4EMA030Prediction'] = MovingAverages[0][6]
                CurrentData['Hour4SMA030Prediction'] = MovingAverages[0][7]
                CurrentData['Hour4EMA050Prediction'] = MovingAverages[0][8]
                CurrentData['Hour4SMA050Prediction'] = MovingAverages[0][9]
                CurrentData['Hour4EMA100Prediction'] = MovingAverages[0][10]
                CurrentData['Hour4SMA100Prediction'] = MovingAverages[0][11]
                CurrentData['Hour4EMA200Prediction'] = MovingAverages[0][12]
                CurrentData['Hour4SMA200Prediction'] = MovingAverages[0][13]
                CurrentData['Hour4IChiPrediction'] = MovingAverages[0][14]
                CurrentData['Hour4VWMAPrediction'] = MovingAverages[0][14]
                CurrentData['Hour4HMAPrediction'] = MovingAverages[0][15]                
            elif (i == 5):
                DayPredictionBuy = (BuyAmmount)
                DayPredictionSell = (SellAmmount)
                DayPredictionNeutral = (NeutralAmmount)
                        #Oscilators Day     
                CurrentData['DayRSIPrediction'] = Oscilators[0][0]
                CurrentData['DayStochPrediction'] = Oscilators[0][1]
                CurrentData['DayCCIPrediction'] = Oscilators[0][2]
                CurrentData['DayADIPrediction'] = Oscilators[0][3]
                CurrentData['DayAOPrediction'] = Oscilators[0][4]
                CurrentData['DayMomPrediction'] = Oscilators[0][5]
                CurrentData['DayMACDPrediction'] = Oscilators[0][6]
                CurrentData['DayStochRSIPrediction'] = Oscilators[0][7]
                CurrentData['DayWillPrediction'] = Oscilators[0][8]
                CurrentData['DayBullBearPrediction'] = Oscilators[0][9]
                CurrentData['DayUltimateOPrediction'] = Oscilators[0][10]
                #MovingAverages Day
                CurrentData['DayEMA005Prediction'] = MovingAverages[0][0]
                CurrentData['DaySMA005Prediction'] = MovingAverages[0][1]
                CurrentData['DayEMA010Prediction'] = MovingAverages[0][2]
                CurrentData['DaySMA010Prediction'] = MovingAverages[0][3]
                CurrentData['DayEMA020Prediction'] = MovingAverages[0][4]
                CurrentData['DaySMA020Prediction'] = MovingAverages[0][5]
                CurrentData['DayEMA030Prediction'] = MovingAverages[0][6]
                CurrentData['DaySMA030Prediction'] = MovingAverages[0][7]
                CurrentData['DayEMA050Prediction'] = MovingAverages[0][8]
                CurrentData['DaySMA050Prediction'] = MovingAverages[0][9]
                CurrentData['DayEMA100Prediction'] = MovingAverages[0][10]
                CurrentData['DaySMA100Prediction'] = MovingAverages[0][11]
                CurrentData['DayEMA200Prediction'] = MovingAverages[0][12]
                CurrentData['DaySMA200Prediction'] = MovingAverages[0][13]
                CurrentData['DayIChiPrediction'] = MovingAverages[0][14]
                CurrentData['DayVWMAPrediction'] = MovingAverages[0][15]
                CurrentData['DayHMAPrediction'] = MovingAverages[0][16]    
     
            elif (i == 6):
                WeekPredictionBuy = (BuyAmmount)
                WeekPredictionSell = (SellAmmount)
                WeekPredictionNeutral = (NeutralAmmount)   
                #Oscilators Week     
                CurrentData['WeekRSIPrediction'] = Oscilators[0][0]
                CurrentData['WeekStochPrediction'] = Oscilators[0][1]
                CurrentData['WeekCCIPrediction'] = Oscilators[0][2]
                CurrentData['WeekADIPrediction'] = Oscilators[0][3]
                CurrentData['WeekAOPrediction'] = Oscilators[0][4]
                CurrentData['WeekMomPrediction'] = Oscilators[0][5]
                CurrentData['WeekMACDPrediction'] = Oscilators[0][6]
                CurrentData['WeekStochRSIPrediction'] = Oscilators[0][7]
                CurrentData['WeekWillPrediction'] = Oscilators[0][8]
                CurrentData['WeekBullBearPrediction'] = Oscilators[0][9]
                CurrentData['WeekUltimateOPrediction'] = Oscilators[0][10]
                #MovingAverages Week
                CurrentData['WeekEMA005Prediction'] = MovingAverages[0][0]
                CurrentData['WeekSMA005Prediction'] = MovingAverages[0][1]
                CurrentData['WeekEMA010Prediction'] = MovingAverages[0][2]
                CurrentData['WeekSMA010Prediction'] = MovingAverages[0][3]
                CurrentData['WeekEMA020Prediction'] = MovingAverages[0][4]
                CurrentData['WeekSMA020Prediction'] = MovingAverages[0][5]
                CurrentData['WeekEMA030Prediction'] = MovingAverages[0][6]
                CurrentData['WeekSMA030Prediction'] = MovingAverages[0][7]
                CurrentData['WeekEMA050Prediction'] = MovingAverages[0][8]
                CurrentData['WeekSMA050Prediction'] = MovingAverages[0][9]
                CurrentData['WeekEMA100Prediction'] = MovingAverages[0][10]
                CurrentData['WeekSMA100Prediction'] = MovingAverages[0][11]
                CurrentData['WeekEMA200Prediction'] = MovingAverages[0][12]
                CurrentData['WeekSMA200Prediction'] = MovingAverages[0][13]
                CurrentData['WeekIChiPrediction'] = MovingAverages[0][14]
                CurrentData['WeekVWMAPrediction'] = MovingAverages[0][15]
                CurrentData['WeekHMAPrediction'] = MovingAverages[0][16]                  
    
            elif(i == 7):
                MonthPredictionBuy = (BuyAmmount)
                MonthPredictionSell = (SellAmmount)
                MonthPredictionNeutral = (NeutralAmmount)  
                    #Oscilators Month     
                CurrentData['MonthRSIPrediction'] = Oscilators[0][0]
                CurrentData['MonthStochPrediction'] = Oscilators[0][1]
                CurrentData['MonthCCIPrediction'] = Oscilators[0][2]
                CurrentData['MonthADIPrediction'] = Oscilators[0][3]
                CurrentData['MonthAOPrediction'] = Oscilators[0][4]
                CurrentData['MonthMomPrediction'] = Oscilators[0][5]
                CurrentData['MonthMACDPrediction'] = Oscilators[0][6]
                CurrentData['MonthStochRSIPrediction'] = Oscilators[0][7]
                CurrentData['MonthWillPrediction'] = Oscilators[0][8]
                CurrentData['MonthBullBearPrediction'] = Oscilators[0][9]
                CurrentData['MonthUltimateOPrediction'] = Oscilators[0][10]
                #MovingAverages Month
                CurrentData['MonthEMA005Prediction'] = MovingAverages[0][0]
                CurrentData['MonthSMA005Prediction'] = MovingAverages[0][1]
                CurrentData['MonthEMA010Prediction'] = MovingAverages[0][2]
                CurrentData['MonthSMA010Prediction'] = MovingAverages[0][3]
                CurrentData['MonthEMA020Prediction'] = MovingAverages[0][4]
                CurrentData['MonthSMA020Prediction'] = MovingAverages[0][5]
                CurrentData['MonthEMA030Prediction'] = MovingAverages[0][6]
                CurrentData['MonthSMA030Prediction'] = MovingAverages[0][7]
                CurrentData['MonthEMA050Prediction'] = MovingAverages[0][8]
                CurrentData['MonthSMA050Prediction'] = MovingAverages[0][9]
                CurrentData['MonthEMA100Prediction'] = MovingAverages[0][10]
                CurrentData['MonthSMA100Prediction'] = MovingAverages[0][11]
                CurrentData['MonthEMA200Prediction'] = MovingAverages[0][12]
                CurrentData['MonthSMA200Prediction'] = MovingAverages[0][13]
                CurrentData['MonthIChiPrediction'] = MovingAverages[0][14]
                CurrentData['MonthVWMAPrediction'] = MovingAverages[0][15]
                CurrentData['MonthHMAPrediction'] = MovingAverages[0][16]
                    
    
    driver.quit()
    ###SCRAPING TD END
    
    #CurrentData
    

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
    
            
    
    
    
    try:
        Database = pd.read_csv(DBName)  
        Database = Database.append(CurrentData)
        Database.to_csv(DBName, index = False)
    except:
        print('No Actual Database...Creating.')
        Database = pd.DataFrame()
        Database = CurrentData
        Database.to_csv(DBName, index = False)
    

