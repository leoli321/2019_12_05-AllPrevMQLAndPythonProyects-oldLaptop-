//+------------------------------------------------------------------+
//|                      2018_12_21-ModularEABootcamp-CheckTrend.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


double CheckTrend(int TimeFrame){
   double MyMovingAverageTimeFramemin = iMA(NULL,TimeFrame,14,5,0,0,0);
   double OldMyMovingAverageTimeFramemin = iMA(NULL,TimeFrame,14,5,0,0,10);
   double TrendTimeFramemin = MyMovingAverageTimeFramemin - OldMyMovingAverageTimeFramemin;
   
   return Trend;
}