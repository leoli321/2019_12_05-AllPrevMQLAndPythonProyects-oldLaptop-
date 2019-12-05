//+------------------------------------------------------------------+
//|                      2018_12_21-ModularEABootcamp-CheckTrend.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

double CheckTrend(){
   double MyMovingAverage10080min = iMA(NULL,10080,14,5,0,0,0);
   double OldMyMovingAverage10080min = iMA(NULL,10080,14,5,0,0,10);
   double Trend10080min = MyMovingAverage10080min - OldMyMovingAverage10080min;
   
   return Trend10080min;
}