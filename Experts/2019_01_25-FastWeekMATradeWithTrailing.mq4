//+------------------------------------------------------------------+
//|                       2019_01_25-FastWeekMATradeWithTrailing.mq4 |
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
   FastMA = iMA(Symbol(),10080,3,0,MODE_SMA,PRICE_CLOSE,1);
   PrevFastMA = iMA(Symbol(),10080,3,0,MODE_SMA,PRICE_CLOSE,2);
   
   if ( (PrevFastMA < FastMA) && (CurrentBars < iBars(Symbol(),10080) )){
      OrderSend(Symbol(),OP
   }
   
  }
//+------------------------------------------------------------------+
