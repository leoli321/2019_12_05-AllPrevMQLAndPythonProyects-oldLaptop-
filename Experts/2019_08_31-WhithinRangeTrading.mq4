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

double Average;

int OpenBars;
int isMidRangeConditionActive = 0;
int waitTillNextWeek = 0;
int currentDayOfYear;
int closeDayOfYear;
int extern waitingTime = 10;

double activatedSMA50;
double SMA50;

double trailingTP;
int lastTouchBars;
int lastTouchDiference = 14;

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
      
      if(currentDayOfYear - closeDayOfYear > waitingTime){
         waitTillNextWeek = 0;
      } else if(currentDayOfYear - closeDayOfYear < 0){
         waitTillNextWeek = 0;
      }
      
      SMA50 = iMA(Symbol(),BarTimeFrame,50,0,MODE_SMA,PRICE_CLOSE,0);
   }
   
   //STOP LOSS WHEN YOU REACH MID RANGE OBJECTIVE. IF YOU DONT REACH HIGH BUT YOU ALREADY REACHED MID, SELL
   
   
   if(Bid > SMA50*.9995 && Bid < SMA50 * 1.0005){
      lastTouchBars = iBars(Symbol(),BarTimeFrame);
   }
   
   if(OrdersTotal() == 1){
      if(prevDir == 0){
            if(isMidRangeConditionActive == 0){
               Average = 0;
               for(int i=0;i < 10;i++){
                     Average += MathAbs(iOpen(Symbol(),BarTimeFrame,i) - iClose(Symbol(),BarTimeFrame,i));
                  }
                  Average = (Average / 10);
                  
               double midRangeHighestPlusAverage = midRangeHighest+Average;
      
               if(midRangeHighestPlusAverage > highRangeHighest){
                  SL = midRangeHighestPlusAverage;
      
                }
               isMidRangeConditionActive = 1;
            
         }else{   
            if(Ask < TP){
               CloseAllOrders();
               isMidRangeConditionActive = 0;
               waitTillNextWeek = 1;    
               closeDayOfYear = DayOfYear();           
            }
            if(Bid > SL){
               CloseAllOrders();
               isMidRangeConditionActive = 0;
               waitTillNextWeek = 1;       
               closeDayOfYear = DayOfYear();     
            }
         }
         
        if(iClose(Symbol(),BarTimeFrame,2) < trailingTP && iClose(Symbol(),BarTimeFrame,1) > trailingTP){
         CloseAllOrders();    
         isMidRangeConditionActive = 0;
         waitTillNextWeek = 1;
         closeDayOfYear = DayOfYear();             
        }              
         
      }
      if(prevDir == 1){
         if(isMidRangeConditionActive == 0){
            Average = 0;
            for(int i=0;i < 10;i++){
                  Average += MathAbs(iOpen(Symbol(),BarTimeFrame,i) - iClose(Symbol(),BarTimeFrame,i));
               }
               Average = (Average / 10);
               
            double midRangeLowestLessAverage = midRangeLowest-Average;
   
            if(midRangeLowestLessAverage < highRangeLowest){
               SL = midRangeLowestLessAverage;
   
             }
            isMidRangeConditionActive = 1;
         }else{
            if(Bid > TP){
               CloseAllOrders();
               isMidRangeConditionActive = 0;
               waitTillNextWeek = 1;
               closeDayOfYear = DayOfYear();
            }
            if(Ask < SL){
               CloseAllOrders();
               isMidRangeConditionActive = 0;
               waitTillNextWeek = 1;
               closeDayOfYear = DayOfYear();
            }
         }
      } 
        if(iClose(Symbol(),BarTimeFrame,2) > trailingTP && iClose(Symbol(),BarTimeFrame,1) < trailingTP){
         CloseAllOrders();    
         isMidRangeConditionActive = 0;
         waitTillNextWeek = 1;
         closeDayOfYear = DayOfYear();             
        }         
         
   }
   
   if(currentBars - lastTouchBars < lastTouchDiference){
      activatedSMA50 = 0;
   } else {
      activatedSMA50 = 1;
   }
   
   if(OrdersTotal() == 0 && waitTillNextWeek == 0 && activatedSMA50 == 0){
      if(Bid == midRangeHighest){
         //OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
         prevDir = 0; // Change this when you change top one. you could do this automatically.
         
         //Deciding the take profit and Stop Loss, which is the next level.
         TP = highRangeLowest;
         SL = highRangeHighest;
         OpenBars = currentBars;
         trailingTP = midRangeLowest;

         
      }
      if(Ask == midRangeLowest){
         //OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;  
         prevDir = 1; // Change this when you change top one. you could do this automatically.    
         //Deciding the take profit and Stop Loss, which is the next level.
         SL = highRangeLowest;
         TP = highRangeHighest;
         OpenBars = currentBars;
         trailingTP = midRangeHighest;
      }
   }
   
   if(AccountProfit() < -AccountBalance()/2){ 
         CloseAllOrders();         
         isMidRangeConditionActive = 0;
         waitTillNextWeek = 1;
         closeDayOfYear = DayOfYear();   
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   currentDayOfYear = DayOfYear();
   
   Comment("lowRangeHighest = ", lowRangeHighest, "\n",
   "lowRangeLowest ",lowRangeLowest ,"\n",
   "midRangeHighest = ", midRangeHighest, "\n",
   "midRangeLowest ",midRangeLowest ,"\n",
   "highRangeHighest = ", highRangeHighest, "\n",
   "highRangelowest ",highRangeLowest ,"\n",
   "TP: ", TP,
   "\n", "SL: ", SL,"\n", "Average: ", Average, "\n",
   "DayOfYearDifference: ", currentDayOfYear - closeDayOfYear,
   "\n", "trailingTP: ", trailingTP, "\n",
   "isSMA50Activated: ", activatedSMA50, "\n",
   "currentBars-lastTouchBars: ", currentBars - lastTouchBars, "\n", "SMA50: ", SMA50,
   "\n", "AccountProfit: ",AccountProfit(), "\n", AccountBalance());   
   
  }
//+------------------------------------------------------------------+
