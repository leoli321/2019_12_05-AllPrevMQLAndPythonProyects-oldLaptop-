//+------------------------------------------------------------------+
//|                                 2019_09_09-IGuessJustBuildUp.mq4 |
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

double hour4WeekHigh;
double hour4WeekLow;
int currentWeekBars;
int currentMinBars;
double SMA20H4;
double minClose1;
double minClose2;
int minTimeframe = 30;

double extern lot_size = .01;
double TP;
double extern LotTPRatio = 1000;
int OpenOrder[3000];
int x;
int prevDir;
double accProfit = 0;
int currentDayBars;
double dailyAwesome;
double orderAwesome;

double daily1AccDist;
double daily2AccDist;
double dailyBBandH;
double dailyBBandL;
double minBBandL;
double minBBandH;
double minRSI;
double openOrderMinBars;

double minAO2;
double minAO1;
double minAC2;
double minAC1;

int whichIndicatorDecided = 0;
double currentDayBarSize;
double Average;

double daySMA;
int lastBBandTouchL;
int lastBBandTouchH;
double prevDayClose;
double dayMACD0;
double dayMACD1;

double orderMin240Low;
double orderMin240High;
double minAverage;
double firstOrderPrice;

void OnTick()
  {
//---
   if(currentWeekBars < iBars(Symbol(),10080)){
      TP = LotTPRatio * lot_size;   
   }
   
   if(currentMinBars < iBars(Symbol(),minTimeframe)){
      SMA20H4 = iMA(Symbol(),240,20,0,MODE_SMA,PRICE_CLOSE,0);
      minBBandL = iBands(Symbol(),minTimeframe,240,2,0,PRICE_CLOSE,MODE_LOWER,0);
      minBBandH = iBands(Symbol(),minTimeframe,240,2,0,PRICE_CLOSE,MODE_UPPER,0);
      minRSI = iRSI(Symbol(),minTimeframe,8,PRICE_CLOSE,0);
      minAO2 = iAO(Symbol(),minTimeframe,2);
      minAO1 = iAO(Symbol(),minTimeframe,1);
      minAC2 = iAC(Symbol(),minTimeframe,2);
      minAC1 = iAC(Symbol(),minTimeframe,1);
      
      minClose1 = iClose(Symbol(),minTimeframe,1);
      minClose2 = iClose(Symbol(),minTimeframe,2);
      if(OrdersTotal() == 0 && currentDayBarSize > Average/3){  //Orderstotal And check if its not doji.
            if(minClose1 > minBBandL && minClose2 < minBBandL){
                  OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size+lot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 1;
                  
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  //Indicatiors the moment of Send
                  orderAwesome = iAO(Symbol(),1440,0);
                  orderMin240High = iClose(Symbol(),minTimeframe,iHighest(Symbol(),minTimeframe,MODE_CLOSE,240,0));
                  orderMin240Low = iClose(Symbol(),minTimeframe,iLowest(Symbol(),minTimeframe,MODE_CLOSE,240,0));
                  firstOrderPrice = Ask;
            }
            
            if(minClose1 < minBBandH && minClose2 > minBBandH){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size+lot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 0;
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  //Indicatiors the moment of Send
                  orderAwesome = iAO(Symbol(),1440,0);
                  orderMin240High = iClose(Symbol(),minTimeframe,iHighest(Symbol(),minTimeframe,MODE_CLOSE,240,0));
                  orderMin240Low = iClose(Symbol(),minTimeframe,iLowest(Symbol(),minTimeframe,MODE_CLOSE,240,0));
                  firstOrderPrice = Bid;
            }
         }//OrdersTotal = 0
      }
   
   
   if(openOrderMinBars + 8*OrdersTotal() < currentMinBars){
      if(AccountProfit() < 0){
         if(prevDir == 1){
            if(Ask < orderMin240Low - minAverage){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size+lot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 0;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 4;
               }
         }else{
            if(Ask > orderMin240High + minAverage){
                     OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size+lot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
                     x +=1;
                     prevDir = 1;
                     accProfit = AccountProfit();
                     openOrderMinBars = iBars(Symbol(),minTimeframe);
                     whichIndicatorDecided = 4;
                  }
         }
      }
   }
   
   if(OrdersTotal() == 1){
      if(openOrderMinBars + 144*OrdersTotal() < currentMinBars){ //if after 3 days no close
         if(AccountProfit() < 0 && AccountProfit() < accProfit){
            
            if(prevDir == 1){
               
               if(Ask < dailyBBandL){
                  CloseAllOrders();
                  whichIndicatorDecided = 6;
               }
               
               if(dayMACD1 > 0 && dayMACD0 < 0){
                  CloseAllOrders();
                  whichIndicatorDecided = 7;
               }
               
               if(minRSI > 70){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size+lot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 0;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 1;
               }else if(minAO2 > 0 && minAO1 < 0){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size+lot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 0;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 2;
               }else if(minAC2 > minAC1){
                  OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size+lot_size*OrdersTotal(),Bid,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 0;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 3;
               }   
            }else{
               
               
               if(dayMACD1 < 0 && dayMACD0 > 0){
                  CloseAllOrders();
                  whichIndicatorDecided = 6;
               }
               
               if(Ask > dailyBBandH){
                  CloseAllOrders();
                  whichIndicatorDecided = 7;
               }
                  
               if(minRSI < 30){
                  OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size+lot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 1;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 1;
               }else if(minAO2 < 0 && minAO1 > 0){
                  OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size+lot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 1;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 2;
               }else if(minAC2 < minAC1){
                  OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size+lot_size*OrdersTotal(),Ask,3,NULL,NULL,NULL,NULL,NULL);
                  x +=1;
                  prevDir = 1;
                  accProfit = AccountProfit();
                  openOrderMinBars = iBars(Symbol(),minTimeframe);
                  whichIndicatorDecided = 3;
               }
            }
         }
      } //Close if bars > 144
   }//Close ordersTotal == 1

   if(OrdersTotal() == 2){
      if(prevDir == 1){
         if(Ask < firstOrderPrice){
            CloseAllOrders();
            whichIndicatorDecided = 5;
         }
      }else{
         if(Bid > firstOrderPrice){
            CloseAllOrders();
            whichIndicatorDecided = 5;
         }
      }
   }
   
   if(currentDayBars < iBars(Symbol(),1440)){
      Average = 0;
      for(int i=0;i < 30;i++){
            Average += MathAbs(iOpen(Symbol(),1440,i) - iClose(Symbol(),1440,i));
         }
      Average = (Average / 30);
      
      minAverage = 0;
      for(int i=0;i < 30;i++){
            minAverage += MathAbs(iOpen(Symbol(),1440,i) - iClose(Symbol(),1440,i));
         }
      minAverage = (minAverage / 30);
      
      currentDayBarSize = MathAbs(iOpen(Symbol(),1440,1) - iClose(Symbol(),1440,1)); 
      dailyBBandH = iBands(Symbol(),1440,20,1.5,0,PRICE_CLOSE,MODE_UPPER,0);
      dailyBBandL = iBands(Symbol(),1440,20,1.5,0,PRICE_CLOSE,MODE_LOWER,0);
      
      daySMA = iMA(Symbol(),1440,20,0,MODE_SMA,PRICE_CLOSE,0);
      
      if(iClose(Symbol(),1440,1) > dailyBBandH){
         lastBBandTouchH = 0;
      }
      
      if(iClose(Symbol(),1440,1) < dailyBBandL){
         lastBBandTouchL = 0;
      }
      
      
      lastBBandTouchH += 1;
      lastBBandTouchL += 1;
      
      prevDayClose = iClose(Symbol(),1440,1);
      
      if(prevDayClose < dailyBBandL){ //Poner esto solo si esta en el contrario???
         CloseAllOrders();
         whichIndicatorDecided = 8;
      }else if(prevDayClose > dailyBBandH){
         CloseAllOrders();
         whichIndicatorDecided = 8;
      }
      
      
      dayMACD0 = iMACD(Symbol(),1440,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      dayMACD1 = iMACD(Symbol(),1440,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      
   }
   
   
   if(AccountProfit() > TP){
      CloseAllOrders();
      accProfit = 0;
   }
   
   Comment("SMA20: ",SMA20H4, "\n",
   "hour4Week H, L:  ", hour4WeekHigh, " ",hour4WeekLow, "\n",
   "TP: ", TP,"\n",
   "AccountProfit: ", AccountProfit(),"\n",
   "accProfit: ", accProfit,"\n",
   "OpenOrderBars: ", openOrderMinBars, "  CurrentBars: ", currentMinBars,"\n",
   "Which indicator: ",whichIndicatorDecided,"\n",
   "Min240: ", orderMin240Low," MinAverage: ", minAverage
   );
   
   currentWeekBars = iBars(Symbol(),10080);
   currentMinBars = iBars(Symbol(),minTimeframe);
   currentDayBars = iBars(Symbol(),1440);
  }
//+------------------------------------------------------------------+
