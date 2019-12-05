//+------------------------------------------------------------------+
//|                          2019_09_09-SuppAndResWeeklyOutAndIn.mq4 |
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
double prevYearHigh;
double prevYearLow;
int OpenOrder[3000];
int x;
int prevDir;
double prev2WeekClose;
double prevWeekClose;
int currentBars;
int openWeekBars;
int currentWeekBars;
int yearStartActivated = 0;
int lastYear;
double TP;
double extern LotTPRatio = 1000;


void OnTick()
  {
//---
   if(currentWeekBars < iBars(Symbol(),10080)){
      TP = lot_size*LotTPRatio;
      CloseAllOrders();
      if(yearStartActivated == 0){
         prevYearHigh = iClose(Symbol(),10080,iHighest(Symbol(),10080,MODE_CLOSE,52,0));
         prevYearLow = iClose(Symbol(),10080,iLowest(Symbol(),10080,MODE_CLOSE,52,0));
         yearStartActivated = 1;
         lastYear = Year();
      }
      
      
      prevWeekClose = iClose(Symbol(),10080,1);
      prev2WeekClose = iClose(Symbol(),10080,2);
      
      if(OrdersTotal() == 0){
         if(prev2WeekClose < prevYearLow && prevWeekClose > prevYearLow){
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x +=1;
            prevDir = 1;
         } 
         
         if(prev2WeekClose > prevYearHigh && prevWeekClose < prevYearHigh){
            OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            x +=1;
            prevDir = 0;
         }          
      }
   }
   
   if(Year() > lastYear){
      yearStartActivated = 0;
   }
   
   if(AccountProfit() > TP){
      CloseAllOrders();
   }
   
   currentBars = iBars(Symbol(),1440);
   currentWeekBars = iBars(Symbol(),10080);
   
   
   Comment("prevYearHigh: ", prevYearHigh,"\n",
   "prevYearLow: ", prevYearLow,"\n",
   "prevWeekClose: ", prevWeekClose, "\n",
   "prev2WeekClose: ", prev2WeekClose
   );
  }
//+------------------------------------------------------------------+
