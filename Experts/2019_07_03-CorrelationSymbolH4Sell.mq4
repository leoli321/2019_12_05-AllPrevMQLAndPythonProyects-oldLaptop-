//+------------------------------------------------------------------+
//|                              2019_03_07-CorrelationSymbol1H4.mq4 |
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
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

int BarTimeFrame = 1440;
double extern lot_size = .1;
int OpenOrder[200];
int OrderCloseArray[200];
int currentBars;
double ClosePrice;
double OpenPrice;
int i = 0;
int OrderSelectArray[300];


void OnTick()
  {
   if(iBars(Symbol(),BarTimeFrame) > currentBars){
      
      if(OrdersTotal() > 0){
         
         OrderSelectArray[i] = OrderSelect(OpenOrder[i],SELECT_BY_TICKET,MODE_TRADES);
         OrderCloseArray[i] = OrderClose(OpenOrder[i],lot_size,Ask,3,NULL);
         i = i +1;
      }else{
         
         OpenOrder[i] = OrderSend(Symbol(),  OP_SELL  ,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      }
   }
   
   
      if(AccountProfit() < -20){
         OrderSelectArray[i] = OrderSelect(OpenOrder[i],SELECT_BY_TICKET,MODE_TRADES);
         OrderCloseArray[i] = OrderClose(OpenOrder[i],lot_size,Ask,3,NULL);
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
    Comment(
      OpenOrder[i]," \n",
      OrderSelectArray[i]," \n",
      OrderCloseArray[i], " \n",
      i," \n"
     );
   
  }
//+------------------------------------------------------------------+
