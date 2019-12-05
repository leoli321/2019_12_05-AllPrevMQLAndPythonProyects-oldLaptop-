//+------------------------------------------------------------------+
//|                                        2019_07_10-OnlyRandom.mq4 |
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
int currentBars;
int OpenOrder[200];
int OrderCloseArray[200];
int OrderSelectArray[300];
int i = 0;
int BarTimeFrame = 10080;
double ClosePrice;
double lot_size = .01;
double initial_lot_size = lot_size;
void OnTick()
  {

   if(iBars(Symbol(),BarTimeFrame) > currentBars){  

            
      if(OrdersTotal() > 0){
        int total = OrdersTotal();
           for(int n=total-1;n>=0;n--)
           {
             OrderSelectArray[n] = OrderSelect(n, SELECT_BY_POS);
             int type   = OrderType();
         
             bool result = false;
             
             switch(type)
             {
               //Close opened long positions
               case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                                   break;
               
               //Close opened short positions
               case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                                   
             }
             
             if(result == false)
             {
               Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
               Sleep(3000);
             }  
           }  

      }
      
      if (rand() < 16383){
         OpenOrder[i] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);                  
      } else{
         OpenOrder[i] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);                  
      }
    }
   

   currentBars = iBars(Symbol(),BarTimeFrame);
   
   
  }
//+------------------------------------------------------------------+
