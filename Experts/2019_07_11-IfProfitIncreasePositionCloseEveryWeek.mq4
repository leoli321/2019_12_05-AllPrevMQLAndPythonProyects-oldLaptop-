//+------------------------------------------------------------------+
//|            2019_07_11-IfProfitIncreasePositionCloseEveryWeek.mq4 |
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
int OrderSelectArray[300];

int CloseAllOrders()
{
  int total = OrdersTotal();
  for(int n=total-1;n>=0;n--)
  {
    OrderSelectArray[i] = OrderSelect(n, SELECT_BY_POS);
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

int LastOrder;

int OpenRandomOrder(){
if (rand() < 16383){
         OpenOrder[i] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         i = i+1;                  
         LastOrder = OP_BUY;
      } else{
         OpenOrder[i] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);                  
         i = i+1;
         LastOrder = OP_SELL;
      }
      
      return(LastOrder);
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
int BarTimeFrame = 240;
int HigherTimeFrame = 1440;
int currentBars;
int currentHighBars;

int NextOrder;
int i = 0;
int OpenOrder[200];
int OrderCloseArray[200];
double ClosePrice;
double lot_size = .1;
int firstOrder = 0;
void OnTick()
  {
    if(firstOrder == 0){
      OpenRandomOrder();
      firstOrder = 1;
    }
    
    if(iBars(Symbol(),BarTimeFrame) > currentBars){  
         
         
         if(   (iClose(Symbol(),BarTimeFrame,1) > iOpen(Symbol(),BarTimeFrame,1))  
               && (LastOrder == OP_BUY)
         ){            
            OpenOrder[i] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);                  
            i += 1;
          }
         if(   (iClose(Symbol(),BarTimeFrame,1) < iOpen(Symbol(),BarTimeFrame,1))  
               && (LastOrder == OP_SELL)
         ){            
            OpenOrder[i] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);                  
            i += 1;
          }
    
      if(iBars(Symbol(),HigherTimeFrame) > currentHighBars){  
            CloseAllOrders();
            OpenRandomOrder();
      }
         
    }
    
    
    
    currentBars = iBars(Symbol(),BarTimeFrame);
    currentHighBars = iBars(Symbol(),HigherTimeFrame);
    Comment(
      LastOrder, " \n",
      AccountProfit(), "\n",
      iClose(Symbol(),HigherTimeFrame,1)
    );
   
   
  }
//+------------------------------------------------------------------+
