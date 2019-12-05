//+------------------------------------------------------------------+
//|                   2019_09_07-BuyAndSellAndRandomTrendFindTry.mq4 |
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
int OrderSelectArray[3000];
int CloseAllOrders()
{
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
  
  return(0);
}

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
double extern lot_size = .01;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size = lot_size;
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 10080;
int currentDayBars;
void OnTick()
  {
//---
   if(currentDayBars < iBars(Symbol(),1440)){

      if(OrdersTotal() > 0){
         if(DayOfWeek() > 1 && DayOfWeek() < 6){
            if(iClose(Symbol(),1440,1) > iOpen(Symbol(),1440,1)){
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);      
               x +=1;
            }else{
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
               x +=1;
            }
         }
      }   
   
      if(currentBars < iBars(Symbol(),BarTimeFrame)){
         CloseAllOrders();
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x +=1;
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);      
         x +=1;
      }//End of currentBarsWeekly
      

      
   }//End of day bars
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   currentDayBars = iBars(Symbol(),1440);
   
   Comment("AccountProfit: ", AccountProfit(),"\n",
   "DayOfWeek: ", DayOfWeek()
   );
   
  }
//+------------------------------------------------------------------+
