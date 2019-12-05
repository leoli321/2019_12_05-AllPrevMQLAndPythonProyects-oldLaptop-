//+------------------------------------------------------------------+
//|                             2019_02_09-TestingArrayOrderSend.mq4 |
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

int DayBars;
int OrderArray[20];
int n = 0;
void OnTick()
  {
   if( DayBars < iBars(Symbol(),1440) )   {
      
      OrderArray[n] = OrderSend(Symbol(),OP_BUY,.01,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
      n = 0 + 1;
       
   }
   
   DayBars = iBars(Symbol(),1440);
   
  }
//+------------------------------------------------------------------+
