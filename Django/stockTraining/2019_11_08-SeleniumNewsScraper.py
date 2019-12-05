# -*- coding: utf-8 -*-
"""
Created on Thu Nov  7 20:41:40 2019

@author: gvega
"""

import requests
from bs4 import BeautifulSoup
from selenium import webdriver
import os
import pandas as pd
import datetime

os.chdir(r'C:\\Users\gvega\Documents\django\FxTrainMain\ScenariosData\EURCHF\2019_11_11-EURCHF-DowntrendMaySep2019')

#Open browser and navigate to website
ChromePath = r"C:\\Users\gvega\Downloads\chromedriver.exe"
driver = webdriver.Chrome(ChromePath)
driver.get("https://www.google.com/search?q=aapl&rlz=1C1CHBF_esMX860MX860&biw=931&bih=568&source=lnt&tbs=cdr%3A1%2Ccd_min%3A10%2F20%2F2019%2Ccd_max%3A11%2F7%2F2019&tbm=nws")

content = driver.find_elements_by_class_name("g")
dates = driver.find_elements_by_class_name("slp")
Title = driver.find_elements_by_class_name("gG0TJc")


ids = []
datesArray = []
titlesArray = []
for i in range(len(Title)):
    ids.append("")
    currentDate = dates[i].text[((dates[i].text.find("-"))+1): ]
    datesArray.append(currentDate)
    currentTitle = Title[i].text[:((Title[i].text.find("\n")))]
    titlesArray.append(currentTitle)
    
    
#sorting datetime
for i in range(len(datesArray)):
    if(datesArray[i][5] == ","):
        datesArray[i] = datesArray[i][:4] + "0" + datesArray[i][4:] 
    if(datesArray[i][5] == "."):
        datesArray[i] = "0" + datesArray[i]
    
    try:
        datesArray[i] = datetime.datetime.strptime(datesArray[i], "%b %d, %Y")
    except:
        try:
            datesArray[i] = datetime.datetime.strptime(datesArray[i], "%d %b. %Y")
        except:
            print("ERROR")
            
            
combinedArray = []
for i in range(len(datesArray)):
    combinedArray.append([datesArray[i],titlesArray[i]])
    
combinedArray.sort()

datesArray = []
titlesArray = []
for i in range(len(combinedArray)):
    datesArray.append(combinedArray[i][0])
    titlesArray.append(combinedArray[i][1])

newsDatabase = pd.DataFrame()
newsDatabase["id"] = ids
newsDatabase["date"] = datesArray
newsDatabase["title"] = titlesArray

newsDatabase.to_csv("news.csv", index = False)


"""
Solo usando bs4 (no jala)
page_link = 'https://www.google.com/search?rlz=1C1CHBF_esMX860MX860&biw=931&bih=568&tbs=cdr%3A1%2Ccd_min%3A9%2F16%2F2019%2Ccd_max%3A10%2F10%2F2019&tbm=nws&sxsrf=ACYBGNSItCtLJ_79AWX3oZrx-OzehS3vFg%3A1573055781035&ei=Je3CXaDdAYSQsAXEoLPwAg&q=nasdaq&oq=nasdaq&gs_l=psy-ab.3...6747.8020.0.8180.6.6.0.0.0.0.98.475.6.6.0....0...1c.1.64.psy-ab..0.0.0....0.lAAbSJuqGnY'
# this is the url that we've already determined is safe and legal to scrape from.
page_response = requests.get(page_link, timeout=5)
# here, we fetch the content from the url, using the requests library
page_content = BeautifulSoup(page_response.content, "html.parser")
#we use the html parser to parse the url content and store it in a variable.
"""