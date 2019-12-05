//+------------------------------------------------------------------+
//|                                      2018_12_20-MQL4BootCamp.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//Variables;
double BuyPrice;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

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
int buyticket;
void OnTick()
  {

   
   if (Close[1]>Close[2]){
      if (OrdersTotal() < 1){
         buyticket = OrderSend(Symbol(),OP_BUY,0.1,Ask,3,0,(Ask+0.25),NULL,0,0,Green);
         BuyPrice = Ask;
      }
   }
   
   if (Close[2]<Close[1]){
      if(BuyPrice < (Close[1]*.999)){
         int sellticket = OrderClose(buyticket,.1,Bid,3,Red);
      }
   }
   
  }
//+------------------------------------------------------------------+
