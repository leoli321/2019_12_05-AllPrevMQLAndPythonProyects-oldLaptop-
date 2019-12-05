//+------------------------------------------------------------------+
//|                                   2018_12_21-MainEABootCamp2.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "2018_12_21-ModularEABootcamp-CheckAnyTrend.mq4"
#include "2018_12_21-OpenCloseTradeBootcamp.mq4"

double Trend;
extern int TrendFrame = 10080;

void OnTick()
  {
   
   Trend = CheckTrend(TrendFrame);
   
   if (OrdersTotal() ==0){
      
      if(Trend > 0){
         OpenTrade(0);
          }
      else{
         OpenTrade(1);
      }
             
   }
   
  }
//+------------------------------------------------------------------+
