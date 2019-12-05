//+------------------------------------------------------------------+
//|                               2019_09_06-WeeklySuppAndResTry.mq4 |
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
      closestUp = 1000;
   closestDown = 0;
   for(int i = 0;i < pastYearRange*2;i++){
      if(highAndLowSupsAndRes[i] > Ask && highAndLowSupsAndRes[i] < closestUp){
         closestUp = highAndLowSupsAndRes[i];
      } else if(highAndLowSupsAndRes[i] < Ask && highAndLowSupsAndRes[i] > closestDown){
         closestDown = highAndLowSupsAndRes[i];
      }
   }
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

double highAndLowSupsAndRes[50];
int x;
int pastYearRange = 5;
int yearsWeeks = 0;
double closestUp;
double closestDown;
int y = 0;

int OpenOrder[3000];
int prevDir;

double extern lot_size = .1;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size;

double Average;
double SL;
double upDistance;
double downDistance;
int currentBars;
int BarTimeFrame = 240;
void OnTick()
  {
  
  if(currentBars < iBars(Symbol(),BarTimeFrame)){
    if (AccountBalance() > OriginalAccountBalance){
           currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
           currentLot_size = lot_size * MathPow(currentAccountBalanceRatio,.66);
         } else{  
           currentLot_size = lot_size;
         } 
   
      Average = 0;
      for(int i=0;i < 5;i++){
            Average += MathAbs(iOpen(Symbol(),10080,i) - iClose(Symbol(),10080,i));
         }
      Average = (Average / 5); //He makin dat avrg bigger.
      Average = NormalizeDouble(Average,4);
                 
   
   yearsWeeks = 0;
   x = 0;
   for(int i=0; i< pastYearRange;i++){
      double RangeHighest = iClose(Symbol(),10080,iHighest(Symbol(),10080,MODE_CLOSE,52+yearsWeeks,yearsWeeks));
      double RangeLowest = iClose(Symbol(),10080,iLowest(Symbol(),10080,MODE_CLOSE,52+yearsWeeks,yearsWeeks));
      yearsWeeks = i*52;
      highAndLowSupsAndRes[x] = RangeHighest;
      x+=1;
      highAndLowSupsAndRes[x] = RangeLowest;
      x+=1;
   }
   
   ArraySort(highAndLowSupsAndRes);
   
   closestUp = 1000;
   closestDown = 0;
   for(int i = 0;i < pastYearRange*2;i++){
      if(highAndLowSupsAndRes[i] > Ask && highAndLowSupsAndRes[i] < closestUp){
         closestUp = highAndLowSupsAndRes[i];
      } else if(highAndLowSupsAndRes[i] < Ask && highAndLowSupsAndRes[i] > closestDown){
         closestDown = highAndLowSupsAndRes[i];
      }
   }
   
   upDistance = closestUp - Ask;
   downDistance = Ask - closestDown;
   
   upDistance = NormalizeDouble(upDistance,4);
   downDistance = NormalizeDouble(downDistance,4);
   
     if(OrdersTotal() == 0){
      upDistance = NormalizeDouble(upDistance,4);
      if(upDistance > downDistance*3){
            OpenOrder[y] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            y+=1;
            prevDir = 1;
            SL = Ask - Average;
      }
      downDistance = NormalizeDouble(downDistance,4);
      if(upDistance*3 < downDistance){
            OpenOrder[y] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            y+=1;
            prevDir = 0;
            SL = Ask + Average;
      }
   }
   
   if(OrdersTotal() == 1){
      if(prevDir == 0){
         if(Ask + Average < SL){
            SL = Ask + Average;
         }
      }else{
         if(Ask - Average > SL){
            SL = Ask - Average;
         }
      }
   }
   
   if(OrdersTotal() == 1){
      if(prevDir == 0){
         if(iClose(Symbol(),1440,1) > SL  ){
            CloseAllOrders();
         }
      }else if(prevDir == 1){
         if(iClose(Symbol(),1440,1) < SL  ){
            CloseAllOrders();
         }
      }
   }
   }
   Comment(highAndLowSupsAndRes[0], " ", highAndLowSupsAndRes[1], " ", highAndLowSupsAndRes[2],
    " ", highAndLowSupsAndRes[3], " ", highAndLowSupsAndRes[4], " ", highAndLowSupsAndRes[5],
    " ", highAndLowSupsAndRes[6], " ", highAndLowSupsAndRes[7], " ", highAndLowSupsAndRes[8],
    " ", highAndLowSupsAndRes[7], " ", "\n",
    closestDown," ",closestUp, "\n",
    "SL: ", SL, " Average: ", Average, "\n",
    " upDistance: ",upDistance, " downDistace: ", downDistance, "\n",
    " currentBars: ", currentBars
    );
  }
//+------------------------------------------------------------------+
