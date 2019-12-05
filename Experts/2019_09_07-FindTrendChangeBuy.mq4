//+------------------------------------------------------------------+
//|                                2019_09_07-FindTrendChangeBuy.mq4 |
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
double currentLot_size;
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 10080;
double openPriceArray[300];
double openPriceDifference;
double currentProfit = -OriginalAccountBalance;
void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
      if(OrdersTotal() > 0){
         if(iClose(Symbol(),10080,1) > iOpen(Symbol(),10080,1)){
            currentLot_size *= 2;
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            openPriceArray[x] = Ask;
            x+=1;   
            
            //Getting SL 
            currentProfit = AccountProfit();
         }
      }  
      
      if(OrdersTotal() == 1 && currentLot_size == .01){
         CloseAllOrders();
      }
       
      if(OrdersTotal() == 0){
         currentLot_size = .01;
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         openPriceArray[x] = Ask;
         x+=1;
      }

   }//End of current Bars
   
   
   if(currentProfit/2 > AccountProfit()){
      CloseAllOrders();
      currentProfit = -OriginalAccountBalance; 
   }
   
   if(AccountProfit() > currentProfit *2){
      currentProfit *=2;
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment("SL: ","\n",
   "AccountProfit: ", AccountProfit(),"\n",
   "currentProfit: ", currentProfit
   );
   
  }
//+------------------------------------------------------------------+
