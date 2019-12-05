//+------------------------------------------------------------------+
//|                   2019_08_30-TryingToGetWithRangeSupsAndRess.mq4 |
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
int H4BarTimeFrame = 240;
int random;
int randomMax = 32767;

double extern lot_size = .1;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size;
int OpenOrder[3000];
int x;
int prevDir;

int extern lowRange = 5;
int extern midRange = 30;
int extern highRange = 90;

int extern lowRangeH4 = 5;
int extern midRangeH4 = 30;
int extern highRangeH4 = 90;

double lowRangeHighest;
double lowRangeLowest;
double midRangeHighest;
double midRangeLowest;
double highRangeHighest;
double highRangeLowest;

double TP;
double SL;

int OpenBars;
int TimeLimitBars = 15;
double trailingTP;

void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
      
      if(OrdersTotal() == 0){
         if (AccountBalance() > OriginalAccountBalance){
                 currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
                 currentLot_size = lot_size * currentAccountBalanceRatio;
               } else{  
                 currentLot_size = lot_size;
               }   
       }
      
      lowRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,lowRange,0));
      lowRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,lowRange,0));
   
      midRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,midRange,0));
      midRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,midRange,0));
      
      highRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,highRange,0));
      highRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,highRange,0));
      
      
   }
   
   
   
   if(OrdersTotal() == 1){
      if(prevDir == 0){
         if(midRangeLowest == highRangeLowest){
            if(Bid > lowRangeHighest){
            CloseAllOrders();
            }
          } else{
            if(Ask < TP){
               CloseAllOrders();
            }
            if(Bid > SL){
               CloseAllOrders();
            }
         }
         
        if(iClose(Symbol(),BarTimeFrame,2) < trailingTP && iClose(Symbol(),BarTimeFrame,1) > trailingTP){
         CloseAllOrders();        
        }
         
      }
      if(prevDir == 1){
         if(midRangeHighest == highRangeHighest){
            if(Ask < lowRangeLowest){
               CloseAllOrders();
            }
         } else{
            if(Bid > TP){
               CloseAllOrders();
            }
            if(Ask < SL){
               CloseAllOrders();
            }
         }
         
        if(iClose(Symbol(),BarTimeFrame,2) > trailingTP && iClose(Symbol(),BarTimeFrame,1) < trailingTP){
         CloseAllOrders();        
        }         
      } 
         
   }
   
   if(OrdersTotal() == 0){
      if(Bid == midRangeHighest){
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         //OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
         prevDir = 1; // Change this when you change top one. you could do this automatically.
         
         //Deciding the take profit and Stop Loss, which is the next level.
         TP = highRangeHighest;
         SL = highRangeLowest;
         OpenBars = currentBars;
         trailingTP = midRangeHighest;
         
      }
      if(Ask == midRangeLowest){
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         //OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;  
         prevDir = 0; // Change this when you change top one. you could do this automatically.    
         //Deciding the take profit and Stop Loss, which is the next level.
         TP = highRangeLowest;
         SL = highRangeHighest;
         OpenBars = currentBars;
         trailingTP = midRangeLowest;
      }
   }
   
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   Comment("lowRangeHighest = ", lowRangeHighest, "\n",
   "lowRangeLowest ",lowRangeLowest ,"\n",
   "midRangeHighest = ", midRangeHighest, "\n",
   "midRangeLowest ",midRangeLowest ,"\n",
   "highRangeHighest = ", highRangeHighest, "\n",
   "highRangelowest ",highRangeLowest ,"\n",
   "TP: ", TP,
   "\n", "SL: ", SL,
   "\n", "trailingTP: ", trailingTP);   
   
  }
//+------------------------------------------------------------------+
