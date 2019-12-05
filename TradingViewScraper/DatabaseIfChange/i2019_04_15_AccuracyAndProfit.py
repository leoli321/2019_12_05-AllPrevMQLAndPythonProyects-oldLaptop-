import pandas as pd
import os

def Accuracy(DBName):
    
    try:
        Database = pd.read_csv(DBName)
    except:
        print('No-Db-Found')
    pass
    
    def AccCalcs(TimePeriod, TimePeriodClosingPrice,TimePeriodDesition,TimePeriodAcc,TimePeriodProfitPer):
    	for i in range(0,len(Database)):
    		if(Database[TimePeriod][i] == 'CLOSED'):
    			StartPrice = float(Database['Price'][i])
    			EndPrice = float(Database[TimePeriodClosingPrice][i])
    			if( Database[TimePeriodDesition][i] == 'BUY'):
    				if(StartPrice < EndPrice):
    					Database[TimePeriodAcc][i] = 1
    					Database[TimePeriodProfitPer][i] = (EndPrice - StartPrice)/EndPrice
    				else:
    					Database[TimePeriodAcc][i] = 0
    					Database[TimePeriodProfitPer][i] = (EndPrice - StartPrice)/EndPrice
    
    			if( Database[TimePeriodDesition][i] == 'SELL'):
    				if(StartPrice < EndPrice):
    					Database[TimePeriodAcc][i] = 0
    					Database[TimePeriodProfitPer][i] = (EndPrice - StartPrice)/EndPrice * -1
    				else:
    					Database[TimePeriodAcc][i] = 1
    					Database[TimePeriodProfitPer][i] = (EndPrice - StartPrice)/EndPrice	* -1	
    
    	
    AccCalcs('Hour1PeriodStatus','Hour1ClosingPrice','Hour1Desition','Hour1Accuracy','Hour1ProfitPercentage')
    AccCalcs('Hour4PeriodStatus','Hour4ClosingPrice','Hour4Desition','Hour4Accuracy','Hour4ProfitPercentage')
    AccCalcs('DayPeriodStatus','DayClosingPrice','DayDesition','DayAccuracy','DayProfitPercentage')
    AccCalcs('WeekPeriodStatus','WeekClosingPrice','WeekDesition','WeekAccuracy','WeekProfitPercentage')
    AccCalcs('MonthPeriodStatus','MonthClosingPrice','MonthDesition','MonthAccuracy','MonthProfitPercentage')  
    
    Database.to_csv(DBName, index = False)
    
    
