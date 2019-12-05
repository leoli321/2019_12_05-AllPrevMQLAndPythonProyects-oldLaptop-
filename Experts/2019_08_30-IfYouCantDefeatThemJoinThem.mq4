//+------------------------------------------------------------------+
//|                       2019_08_30-IfYouCantDefeatThemJoinThem.mq4 |
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

int currentBars;
int BarTimeFrame = 1440;
int random;
int randomMax = 32767;

double extern lot_size = .1;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size;
int OpenOrder[3000];
int x;
int prevDir;

double extern SL = -5000;

void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
   
      
      CloseAllOrders();
   
      if (AccountBalance() > OriginalAccountBalance){
              currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
              currentLot_size = lot_size * currentAccountBalanceRatio;
            } else{  
              currentLot_size = lot_size;
            }
            
  
      if(OrdersTotal() == 0){
         random = MathRand();
         if(random > randomMax/2){
            OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
            prevDir = 0;
         } else{
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
            prevDir = 1;
         }
      }
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment(random, "\n",
   "AccountProfit: ",AccountProfit() ,"\n","\n");   
   
  }
//+------------------------------------------------------------------+
