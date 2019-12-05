//+------------------------------------------------------------------+
//|                   2019_09_04-WhithinRangeTradingBottomFinder.mq4 |
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
double currentAccountBalanceRatio;
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

int cicle0 = 1;
int cicle1 = 1;
int cicle2 = 1;
int cicle3 = 1;
int cicle4 = 1;
int cicle6 = 1;
double extern TP = 20;
int nextCandle = 0;

double SL;
void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
      nextCandle =0;
      
      Average = 0;
      for(int i=0;i < 30;i++){
            Average += MathAbs(iOpen(Symbol(),BarTimeFrame,i) - iClose(Symbol(),BarTimeFrame,i));
         }
      Average = (Average / 30); //He makin dat avrg bigger.
               
      
      if(OrdersTotal() == 0){
         if (AccountBalance() > OriginalAccountBalance){
                 currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
                 currentLot_size = lot_size * MathPow(currentAccountBalanceRatio,.66);
               } else{  
                 currentLot_size = lot_size;
               }  
          
          
          
      weekRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0));
      weekRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0));
   
      monthRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0));
      monthRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0));
      
      month2RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0));
      month2RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0));
      
      month3RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0));
      month3RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0));
      
      month4RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0));
      month4RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0));            
      
      month6RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0));
      month6RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0));          
 
       }
      }
      
      if(OrdersTotal() == 0 && nextCandle == 0){
               if(Bid < monthRangeLowest){
                  OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
                  x += 1;
                  prevDir = 1; // Change this when you change top one. you could do this automatically.
                  
                  //Stop loss is the next closest resistance or average-
                  if(monthRangeLowest < (Ask-Average)){
                     SL = monthRangeLowest;
                  }else if (month2RangeLowest < (Ask-Average)){
                     SL = month2RangeLowest;
                  }else if (month3RangeLowest < (Ask-Average)){
                     SL = month3RangeLowest;
                  }else if (month4RangeLowest < (Ask-Average)){
                     SL = month4RangeLowest;
                  }else if (month6RangeLowest < (Ask-Average)){
                     SL = month6RangeLowest;
                  } else{
                     SL = Ask - Average;
                  }
               }
               
               if(Ask > monthRangeHighest){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x += 1;
                  prevDir = 0; // Change this when you change top one. you could do this automatically.
                  
                  //Stop loss is the next closest resistance or average+
                  if(monthRangeHighest > (Ask+Average)){
                     SL = monthRangeHighest;
                  }else if (month2RangeHighest > (Ask+Average)){
                     SL = month2RangeHighest;
                  }else if (month3RangeHighest > (Ask+Average)){
                     SL = month3RangeHighest;
                  }else if (month4RangeHighest > (Ask+Average)){
                     SL = month4RangeHighest;
                  }else if (month6RangeHighest > (Ask+Average)){
                     SL = month6RangeHighest;
                  } else{
                     SL = Ask + Average;
                  }            
               }      
            }       
             

      
   
  
   //TP that really is a tracking SL,
   if(OrdersTotal() > 0){
      if(prevDir == 0){
         if(month6RangeLowest > Ask){
            SL = Ask + Average;

         }else if(month4RangeLowest > Ask){
            SL = Ask + Average;

         }else if(month3RangeLowest > Ask){
            SL = Ask + Average;

         }else if(month2RangeLowest > Ask){
            SL = Ask + Average;

         }else if(monthRangeLowest > Ask){
            SL = Ask + Average;

         }else if(weekRangeLowest > Ask){
            SL = Ask + Average;

         }  
         
         if(Ask > SL){
            CloseAllOrders();
            nextCandle = 1;
         }
      }
      
      if(prevDir == 1){
         if(month6RangeHighest < Bid){
            SL = Bid - Average;
          
         }else if(month4RangeHighest < Bid){
            SL = Bid - Average;
           
         }else if(month3RangeHighest < Bid){
            SL = Bid - Average;
         
         }else if(month2RangeHighest < Bid){
            SL = Bid - Average;
            
         }else if(monthRangeHighest < Bid){
            SL = Bid - Average;

         }   
         
         if(Bid < SL){
            CloseAllOrders();
            nextCandle = 1;          
         }
      }
   }  
   
   if(AccountProfit() > TP * MathPow(currentAccountBalanceRatio,.66)){
      CloseAllOrders();    
      nextCandle = 1;
   }
   
   
   //STOP LOSS WHEN YOU REACH MID RANGE OBJECTIVE. IF YOU DONT REACH HIGH BUT YOU ALREADY REACHED MID, SELL
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment("SL = ",SL, "\n",
   "MonthRangeHighest: ", monthRangeHighest, "\n",
   "MonthRangeLowest: ", monthRangeLowest, "\n",
   "WeekRangeH: ", weekRangeHighest, "\n",
   "WeekRangeL: ", weekRangeLowest,"\n",
   "Month2RangeH: ", month2RangeHighest, "\n",
   "Month2RangeL: ", month2RangeLowest,
   "AccountProfit: ", AccountProfit()
   );   
   
  }
//+------------------------------------------------------------------+
