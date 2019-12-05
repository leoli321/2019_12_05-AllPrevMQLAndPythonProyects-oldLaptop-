# -*- coding: utf-8 -*-
"""
Created on Fri Oct 19 8:20:21 2018

@author: cvega
"""

def GDMTO():

    import pandas as pd
    import numpy as np
    import matplotlib.pyplot as plt
    import seaborn as sns
    from urllib.request import urlopen
    from bs4 import BeautifulSoup
    import re
    from selenium import webdriver
    from selenium.webdriver.common.keys import Keys
    from selenium.webdriver.common.by import By
    import os
    import time
    from selenium.webdriver.support.ui import Select
    from selenium.webdriver.support.select import Select

    #%% Seleccionar Tarifa
    TarifaNombre = 'GDMTO' #ESTA TARIFA TIENE 2 diferentes en febrero dependiendo
                            #Del mes en el que factures

    url = "https://app.cfe.mx/Aplicaciones/CCFE/Tarifas/TarifasCREIndustria/Industria.aspx"

    driver = webdriver.Chrome(r"C:\\Users\CVEGA\Downloads\52-WebCrawlTarifas\chromedriver_win32\chromedriver.exe")
    driver.implicitly_wait(30)
    driver.get(url)

    #BUSCAS EL ID DEL JAVASCRIPT A EJECUTAR
    python_button = driver.find_element_by_link_text(TarifaNombre)   #LE PICAS A DONDE DICE GDMTH.

    ##Click el link
    python_button.click() #hace click en el link de GDMTH
    #%%
    TablaCategoria = []
    TablaCargo = []
    TablaUnidad = []
    TablaValor = []
    Ciudad = []
    Tarifa = []
    Fecha = []
    DivTarifaria = []

    #%% SELECCIONAR DE TABLAS


    #SELECCIONAR MES
    Mes = ['1','2','3','4','5','6','7','8','9','10','11','12']

    Estado =['2','1','8','13','12','24','7','14','25','6','30','4','5']

    Municipio = ['12','1','256','447','366','1804','218','531','1861','151',
                 '2093','22','33']

    Division = ['1','3','8','10','11','12','15','17','18','20','21','22','23']

    City = ['Ensenada','Aguascalientes','Armeria','Acatlan','Acapulco de Juarez',
              'Alaquines','Abasolo','Acatic','AHOME','Ahumada','Benito Juarez',
              'Calakmul','Acocoyagua']


    for x in range(0,13):

        b = Estado[x]
        c = Municipio[x]
        d = Division[x]

        for a in range(0,11):
            try:
                print("Mes", a)
                iMes = a
                select = Select(driver.find_element_by_id('ContentPlaceHolder1_Fecha2_ddMes'))
                select.select_by_value(Mes[iMes])
                time.sleep(2)

                iEstado = b
                print("Estado",b)
                #ESTADO
                select = Select(driver.find_element_by_id('ContentPlaceHolder1_EdoMpoDiv_ddEstado'))
                select.select_by_value(Estado[x])
                time.sleep(2)

                iMunicipio = c
                print("Municipio",c)
                #Municipio
                select = Select(driver.find_element_by_id('ContentPlaceHolder1_EdoMpoDiv_ddMunicipio'))
                select.select_by_value(Municipio[x])
                time.sleep(2)


                iDivision = d
                print("Division",d)
                #Division
                select = Select(driver.find_element_by_id('ContentPlaceHolder1_EdoMpoDiv_ddDivision'))
                select.select_by_value(Division[x])
                time.sleep(2)
                soup=BeautifulSoup(driver.page_source, 'lxml')# Parse the HTML as a string
                table = soup.find_all('table')[3]#Grab the third table

                if a == 1:
                    table = soup.find_all('table')[7]

                rows = table.findAll('tr')
                if a == 1:
                    for RowNumber in range (1,5):
                        ActualRow = rows[RowNumber]
                        Cargo = ActualRow.td.string
                        Unidad = ActualRow.td.nextSibling.string
                        Valor = ActualRow.td.nextSibling.nextSibling.string
                        DivTarifa = table.findAll('h3')[0].string

                        TablaCargo.append(Cargo)
                        TablaUnidad.append(Unidad)
                        TablaValor.append(Valor)
                        Ciudad.append(City[x]) #CHECA ESTO.
                        Tarifa.append(rows[1].th.string)
                        Fecha.append(rows[0].th.nextSibling.nextSibling.nextSibling.nextSibling.string)
                        DivTarifaria.append(DivTarifa)
                else:
                     for RowNumber in range(3,7):
                        ActualRow = rows[RowNumber]
                        Cargo = ActualRow.td.string
                        Unidad = ActualRow.td.nextSibling.string
                        Valor = ActualRow.td.nextSibling.nextSibling.string
                        DivTarifa = table.findAll('h3')[0].string

                        TablaCargo.append(Cargo)
                        TablaUnidad.append(Unidad)
                        TablaValor.append(Valor)
                        Ciudad.append(City[x]) #CHECA ESTO.
                        Tarifa.append(rows[3].th.string)
                        Fecha.append(rows[2].th.nextSibling.nextSibling.nextSibling.nextSibling.string)
                        DivTarifaria.append(DivTarifa)


                df = pd.DataFrame()
                df['Mes'] = Fecha
                df['Tarifa'] = Tarifa
                df['Ciudad'] = Ciudad
                df['Cargo'] = TablaCargo
                df['Unidad'] = TablaUnidad
                df['Valor'] = TablaValor
                df['Division Tarifaria'] = DivTarifaria

            except:
                print("ERROR MES", a)
                continue

    df.to_csv('dfGDMTO.csv')
