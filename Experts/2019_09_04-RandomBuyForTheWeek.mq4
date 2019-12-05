//+------------------------------------------------------------------+
//|                               2019_09_04-RandomBuyForTheWeek.mq4 |
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
double extern lot_size = .1;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio = 1;
double currentLot_size;
int OpenOrder[3000];
int x;
int prevDir;
double Average;

int weekRange = 5;
int monthRange = 30;
int month2Range = 60;
int month3Range = 90;
int month4Range = 120;
int month6Range = 180;

double weekRangeHighest;
double weekRangeLowest;
double monthRangeHighest;
double monthRangeLowest;
double month2RangeHighest;
double month2RangeLowest;
double month3RangeHighest;
double month3RangeLowest;
double month4RangeHighest;
double month4RangeLowest;
double month6RangeHighest;
double month6RangeLowest;

double highBand;
double lowBand;

int cicle0 = 0;
int cicle1 = 0;
int cicle2 = 0;
int cicle3 = 0;
int cicle4 = 0;
int cicle6 = 0;
double extern TP = 30;
int nextCandle = 0;
int currentWeekBars;

double SL;

int randomMax = 32767;
int random;


void OnTick()
  {
//---
   if(currentWeekBars < iBars(Symbol(),10080)){
      CloseAllOrders();
   }

      

   if(currentBars < iBars(Symbol(),BarTimeFrame)){     
   
      random = MathRand(); 
      if(OrdersTotal() == 0){
         if (AccountBalance() > OriginalAccountBalance){
                 currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
                 currentLot_size = lot_size * MathPow(currentAccountBalanceRatio,.5);
               } else{  
                 currentLot_size = lot_size;
               }         
 
       }
       
      if(OrdersTotal() == 0){
         if(random < randomMax/5){
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
         }
      }  
      
             
      }

   
   currentWeekBars = iBars(Symbol(),10080);
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment(
   "AccountProfit: ", AccountProfit(), "\n",
   "random: ", random,"\n"
   );   
   
  }
//+------------------------------------------------------------------+
