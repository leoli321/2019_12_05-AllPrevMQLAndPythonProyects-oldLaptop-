//+------------------------------------------------------------------+
//|                           2019_07_03-WickPercentageOptimizer.mq4 |
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


int BarTimeFrame = 240;
double extern lot_size = .1;
int OpenOrder[200];
int OrderCloseArray[200];
int currentBars;
double ClosePrice;
double OpenPrice;
int i = 0;
int OrderSelectArray[300];
double extern Wick_Percentage = .1;

double BarHeight;
double WickHeight;
int OrderCloseAskOrBid;
double BarBodyHeight;
double currentWickPercentage;

double extern StopLoss = -20;
double extern TakeProfit = 20;
void OnTick()
  {
   if(iBars(Symbol(),BarTimeFrame) > currentBars){
      
      if(   (iClose(Symbol(),BarTimeFrame,1) > iOpen(Symbol(),BarTimeFrame,1))
         && (OrdersTotal() < 1)
         ){
         
         BarBodyHeight = iClose(Symbol(),BarTimeFrame,1) - iOpen(Symbol(),BarTimeFrame,1);
         WickHeight = iHigh(Symbol(),BarTimeFrame,1) - iClose(Symbol(),BarTimeFrame,1);
         currentWickPercentage = WickHeight/BarBodyHeight;
         
         if(  (currentWickPercentage < Wick_Percentage)     ){
            OpenOrder[i] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         }
         
         
      }
      
      
      if(   (iClose(Symbol(),BarTimeFrame,1) < iOpen(Symbol(),BarTimeFrame,1))
         && (OrdersTotal() < 1)
         ){
         
         BarBodyHeight = iOpen(Symbol(),BarTimeFrame,1) - iClose(Symbol(),BarTimeFrame,1);
         WickHeight = iClose(Symbol(),BarTimeFrame,1) - iLow(Symbol(),BarTimeFrame,1);
         currentWickPercentage = WickHeight/BarBodyHeight;
         
         if(  (currentWickPercentage < Wick_Percentage)     ){
            OpenOrder[i] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         }   
      }      
      
      
      
      
   }
   
   
      if(AccountProfit() < StopLoss){
         
      
         OrderSelectArray[i] = OrderSelect(OpenOrder[i],SELECT_BY_TICKET,MODE_TRADES);
         
         if(OrderType() == OP_BUY){ClosePrice = Bid;}
         if(OrderType() == OP_SELL){ClosePrice = Ask;}
         
         OrderCloseArray[i] = OrderClose(OpenOrder[i],lot_size,ClosePrice,3,NULL);
      }
   
      if(AccountProfit() > TakeProfit){
         OrderSelectArray[i] = OrderSelect(OpenOrder[i],SELECT_BY_TICKET,MODE_TRADES);
         
         if(OrderType() == OP_BUY){ClosePrice = Bid;}
         if(OrderType() == OP_SELL){ClosePrice = Ask;}
         
         OrderCloseArray[i] = OrderClose(OpenOrder[i],lot_size,ClosePrice,3,NULL);
      }   
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
    Comment(
      iClose(Symbol(),BarTimeFrame,1)," \n",
      i," \n"
     );
   
  }
//+------------------------------------------------------------------+
