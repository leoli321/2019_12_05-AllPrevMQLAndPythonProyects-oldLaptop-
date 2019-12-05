//+------------------------------------------------------------------+
//|                                2019_09_07-BuySellProfitOrDie.mq4 |
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
int BarTimeFrame = 1440;
int currentDayBars;
double extern TP = 10;
double OriginalTP = TP;
double random;
int randomMax = 32767;
void OnTick()
  {
//---
   
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
   
   
         if (AccountBalance() > OriginalAccountBalance){
           currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
           currentLot_size = lot_size * MathPow(currentAccountBalanceRatio,.66);
           TP = currentLot_size * 100;
         } else{  
           currentLot_size = lot_size;
           TP = OriginalTP;
         } 
   
   
   
      if(OrdersTotal() == 0){
         random = MathRand();
         if(random < randomMax/2){
            OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            x +=1;
         }else{
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x +=1;
         }
      
      }

      if(OrdersTotal() > 0){
         if(AccountProfit() < -TP*5){
            if(random > randomMax/2){
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size+currentLot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
               x +=1;
            }else{
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size+currentLot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
               x +=1;
            }
            
            random = MathRand();
         }
         
      }
   }
   
   if(AccountProfit() > TP){
      CloseAllOrders();
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment(AccountProfit(), "\n",
   "lotSize: ", currentLot_size,"\n",
   "TP: ", TP 
   );
   
  }
//+------------------------------------------------------------------+
