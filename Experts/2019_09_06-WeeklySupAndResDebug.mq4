//+------------------------------------------------------------------+
//|                              2019_09_06-WeeklySupAndResDebug.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                 2019_09_04-ConnectingHighsAndLowsToMakeLines.mq4 |
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

double extern lot_size = .03;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size;
int OpenOrder[3000];
int x;
int prevDir;

int currentBars;
int BarTimeFrame = 240;

double Average;
int pastYearRange = 5;
double highAndLowSupsAndRes[50];
double closestUp;
double closestDown;
double upDistance;
double downDistance;
int y;
double SL;
double bandH;
double bandL;
int notTrend;
void OnTick()
  {
//---
   
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
   
         bandH = iBands(Symbol(),1440,20,2,0,PRICE_CLOSE,MODE_UPPER,1);
         bandL = iBands(Symbol(),1440,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
         
         if(iClose(Symbol(),1440,1) > bandL && iClose(Symbol(),1440,1) < bandH){
            notTrend = 0;
         } else{notTrend = 1;}
   
       if (AccountBalance() > OriginalAccountBalance){
           currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
           currentLot_size = lot_size * MathPow(currentAccountBalanceRatio,.66);
         } else{  
           currentLot_size = lot_size;
         } 
      Average = 0;
      for(int i=0;i < 8;i++){
            Average += MathAbs(iOpen(Symbol(),10080,i) - iClose(Symbol(),10080,i));
         }
      Average = (Average / 8); //He makin dat avrg bigger.
      Average = NormalizeDouble(Average,4);
      
      //The section where we get highs and lows
      int yearsWeeks = 0;
      x = 0;
      for(int i=0; i< pastYearRange;i++){
         double RangeHighest = iClose(Symbol(),10080,iHighest(Symbol(),10080,MODE_CLOSE,52+yearsWeeks,yearsWeeks));
         double RangeLowest = iClose(Symbol(),10080,iLowest(Symbol(),10080,MODE_CLOSE,52+yearsWeeks,yearsWeeks));
         yearsWeeks = i*52;
         highAndLowSupsAndRes[x] = RangeHighest;
         x+=1;
         highAndLowSupsAndRes[x] = RangeLowest;
         x+=1;
      } //The section where we get highs and lows END
      
      //Setting up closestUp and closestDown
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
      //Setting up closestUp and closestDownEND
      
      //Making the order
      if(OrdersTotal() == 0 && notTrend == 0){
         if(upDistance > downDistance*3){
               OpenOrder[y] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
               y+=1;
               prevDir = 1;
               SL = Ask - Average*1.3;
         }
         if(upDistance*3 < downDistance){
               OpenOrder[y] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
               y+=1;
               prevDir = 0;
               SL = Ask + Average*1.3;
         }
      }//OrdersTotal == 0 close;
          
          
          
      //set up trailing StopLoss
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
         if(prevDir == 0){
            if(iClose(Symbol(),240,1) > SL  ){
               CloseAllOrders();
            }
         }else if(prevDir == 1){
            if(iClose(Symbol(),240,1) < SL  ){
               CloseAllOrders();
            }
          }
      
      }//OrdersTotal == 1 End
          
          
          
   } //This one ends currentBars
      
             
   
   
   
   
   
   
   //Comment and current bars
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment(highAndLowSupsAndRes[0], " ", highAndLowSupsAndRes[1], " ", highAndLowSupsAndRes[2],
    " ", highAndLowSupsAndRes[3], " ", highAndLowSupsAndRes[4], " ", highAndLowSupsAndRes[5],
    " ", highAndLowSupsAndRes[6], " ", highAndLowSupsAndRes[7], " ", highAndLowSupsAndRes[8], "\n",
   "currentBars: ",currentBars,"\n",
   "Average: ", Average,"\n",
   "upDistance: ", upDistance, " downDistance: ",downDistance,"\n",
   "SL: ",SL
   );
   
  }
//+------------------------------------------------------------------+
