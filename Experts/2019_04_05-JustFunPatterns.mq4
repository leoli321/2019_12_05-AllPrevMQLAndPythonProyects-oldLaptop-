//+------------------------------------------------------------------+
//|                                   2019_04_05-JustFunPatterns.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   Comment(iClose(Symbol(),10080,1));
   
  }
//+------------------------------------------------------------------+
