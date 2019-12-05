//+------------------------------------------------------------------+
//|                                            CheckForNewCandle.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bool NewCandleOnChart(){
   static int CurrentChartCandles=0;
   if (Bars == CurrentChartCandles)
   return (false);
   CurrentChartCandles = Bars;
   return(true);
}