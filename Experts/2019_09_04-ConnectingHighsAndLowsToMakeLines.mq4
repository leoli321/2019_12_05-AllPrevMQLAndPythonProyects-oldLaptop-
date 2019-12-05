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

double extern lot_size = .1;
double extern OriginalAccountBalance = 500;
double currentAccountBalanceRatio;
double currentLot_size;
int OpenOrder[3000];
int x;
int prevDir;

int currentBars;
int BarTimeFrame = 1440;

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

double Average;

int weekRangeHighestPosition;
int weekRangeLowestPosition;
int monthRangeHighestPosition;
int monthRangeLowestPosition;
int month2RangeHighestPosition;
int month2RangeLowestPosition;
int month3RangeHighestPosition;
int month3RangeLowestPosition;
int month4RangeHighestPosition;
int month4RangeLowestPosition;
int month6RangeHighestPosition;
int month6RangeLowestPosition;

double month2PartialHighest;
double month2PartialLowest;
double month3PartialHighest;
double month3PartialLowest;
double month4PartialHighest;
double month4PartialLowest;

double deltaY;
double deltaX;
double month1to2LineHighActual;
double month1to2LineHighB;
double month1to2LineHighM;

double month1to3LineHighActual;
double month1to3LineHighB;
double month1to3LineHighM;

double month1to4LineHighActual;
double month1to4LineHighB;
double month1to4LineHighM;

double month1to6LineHighActual;
double month1to6LineHighB;
double month1to6LineHighM;

double month1to2LineLowActual;
double month1to2LineLowB;
double month1to2LineLowM;

double month1to3LineLowActual;
double month1to3LineLowB;
double month1to3LineLowM;

double month1to4LineLowActual;
double month1to4LineLowB;
double month1to4LineLowM;

double month1to6LineLowActual;
double month1to6LineLowB;
double month1to6LineLowM;


double actualHighsArray[10];
double actualLowsArray[10];
int z;

double closestHigh;
double closestLow;

double SL;

int weekCloseDirectionsArray[30];
int isTrend = 0;
int newDir;
int closestNotZero;
int hBandTouch;
int lBandTouch;
int bollingerTouchTimeFrame = 30;

void OnTick()
  {
//---
   
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
   
      //Building the week array
          if(iClose(Symbol(),10080,3) > iOpen(Symbol(),10080,3) )  {
            weekCloseDirectionsArray[0] = 1;
          } else{
            weekCloseDirectionsArray[0] = 0;
          } 
          if(iClose(Symbol(),10080,2) > iOpen(Symbol(),10080,2) )  {
            weekCloseDirectionsArray[1] = 1;
          } else{
            weekCloseDirectionsArray[1] = 0;
          } 
          if(iClose(Symbol(),10080,1) > iOpen(Symbol(),10080,1) )  {
            weekCloseDirectionsArray[2] = 1;
          } else{
            weekCloseDirectionsArray[2] = 0;
          }                     

         
         //Checking if it has touched bollinger up and down
         hBandTouch = 0;
         lBandTouch = 0;
         for(int i = 1; i < bollingerTouchTimeFrame;i++){
            if(iClose(Symbol(),BarTimeFrame,i) > iBands(Symbol(),BarTimeFrame,50,1,0,PRICE_CLOSE,MODE_UPPER,i)){
               hBandTouch = 1;
            }
            if(iClose(Symbol(),BarTimeFrame,i) < iBands(Symbol(),BarTimeFrame,50,1,0,PRICE_CLOSE,MODE_LOWER,i)){
               lBandTouch = 1;
            }            
         }
         
         if(weekCloseDirectionsArray[0] == weekCloseDirectionsArray[1] && weekCloseDirectionsArray[0] ==  weekCloseDirectionsArray[2]){
            isTrend = 1;
         }else if(hBandTouch == 0 || lBandTouch == 0){
            isTrend = 1;
         }else{isTrend = 0;}

   
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
                  
          

     
     
     
     
     ///////////////////////////////////////////////////
      if(OrdersTotal() == 0 && isTrend == 0){
      
      weekRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0));
      weekRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0));
      weekRangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0);
      weekRangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,weekRange,0);
      
      monthRangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0));
      monthRangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0));
      monthRangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0);
      monthRangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,monthRange,0);
      
      month2RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0));
      month2RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0));
      month2RangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0);
      month2RangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month2Range,0);
      
      month3RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0));
      month3RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0));
      month3RangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0);
      month3RangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month3Range,0);
      
      month4RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0));
      month4RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0));            
      month4RangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0);
      month4RangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month4Range,0);
      
      
      month6RangeHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0));
      month6RangeLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0));  
      month6RangeHighestPosition = iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0);
      month6RangeLowestPosition = iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,month6Range,0);        
      
       
      month2PartialHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,30,month2Range));
      month2PartialLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,30,month2Range));    
      
      month3PartialHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,30,month3Range));
      month3PartialLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,30,month3Range));  
      
      month4PartialHighest = iClose(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_CLOSE,90,month4Range));
      month4PartialLowest = iClose(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_CLOSE,90,month4Range));  
           
      
         //Month 1 to 2
         if( monthRangeHighest > month2RangeHighest*.995 && monthRangeHighest < month2RangeHighest*1.005){
            month1to2LineHighActual = monthRangeHighest;
         } else{
            deltaX = MathAbs(month2RangeHighestPosition - monthRangeHighestPosition);
            deltaY = MathAbs(month2RangeHighest - monthRangeHighest);
            
            
            month1to2LineHighM = deltaY/deltaX;
            month1to2LineHighB = month2RangeHighest - month1to2LineHighM * month2RangeHighestPosition;
            // B es el actual... Es en la posicion 0.
            month1to2LineHighActual = month1to2LineHighB;
         }
         //Month 1 to 3
         if( monthRangeHighest > month3RangeHighest*.995 && monthRangeHighest < month3RangeHighest*1.005){
            month1to3LineHighActual = monthRangeHighest;
         } else{
            deltaX = MathAbs(month3RangeHighestPosition - monthRangeHighestPosition);
            deltaY = MathAbs(month3RangeHighest - monthRangeHighest);
            
            
            month1to3LineHighM = deltaY/deltaX;
            month1to3LineHighB = month3RangeHighest - month1to3LineHighM * month3RangeHighestPosition;
            // B es el actual... Es en la posicion 0.
            month1to3LineHighActual = month1to3LineHighB;
         }
         
         //Month 1 to 4
         if( monthRangeHighest > month4RangeHighest*.995 && monthRangeHighest < month4RangeHighest*1.005){
            month1to4LineHighActual = monthRangeHighest;
         } else{
            deltaX = MathAbs(month4RangeHighestPosition - monthRangeHighestPosition);
            deltaY = MathAbs(month4RangeHighest - monthRangeHighest);
            
            
            month1to4LineHighM = deltaY/deltaX;
            month1to4LineHighB = month4RangeHighest - month1to4LineHighM * month4RangeHighestPosition;
            // B es el actual... Es en la posicion 0.
            month1to4LineHighActual = month1to4LineHighB;
         }
         
         
         //Month 1 to 6
         if( monthRangeHighest > month6RangeHighest*.995 && monthRangeHighest < month6RangeHighest*1.005){
            month1to6LineHighActual = monthRangeHighest;
         } else{
            deltaX = MathAbs(month6RangeHighestPosition - monthRangeHighestPosition);
            deltaY = MathAbs(month6RangeHighest - monthRangeHighest);
            
            
            month1to6LineHighM = deltaY/deltaX;
            month1to6LineHighB = month6RangeHighest - month1to6LineHighM * month6RangeHighestPosition;
            // B es el actual... Es en la posicion 0.
            month1to6LineHighActual = month1to6LineHighB;
         }         
         
         //////////////////////////////////////////////////////////////////////NOW goes lowestt.
         //////////////////////////////////////////////////////////////////////NOW goes lowestt.
         //////////////////////////////////////////////////////////////////////NOW goes lowestt.
         //Month 1 to 2
         if( monthRangeLowest > month2RangeLowest*.995 && monthRangeLowest < month2RangeLowest*1.005){
            month1to2LineLowActual = monthRangeLowest;
         } else{
            deltaX = MathAbs(month2RangeLowestPosition - monthRangeLowestPosition);
            deltaY = (month2RangeLowest - monthRangeLowest);
            
            
            month1to2LineLowM = deltaY/deltaX;
            month1to2LineLowB = month2RangeLowest - month1to2LineLowM * month2RangeLowestPosition;
            // B es el actual... Es en la posicion 0.
            month1to2LineLowActual = month1to2LineLowB;
         }
         //Month 1 to 3
         if( monthRangeLowest > month3RangeLowest*.995 && monthRangeLowest < month3RangeLowest*1.005){
            month1to3LineLowActual = monthRangeLowest;
         } else{
            deltaX = MathAbs(month3RangeLowestPosition - monthRangeLowestPosition);
            deltaY = (month3RangeLowest - monthRangeLowest);
            
            
            month1to3LineLowM = deltaY/deltaX;
            month1to3LineLowB = month3RangeLowest - month1to3LineLowM * month3RangeLowestPosition;
            // B es el actual... Es en la posicion 0.
            month1to3LineLowActual = month1to3LineLowB;
         }
         
         //Month 1 to 4
         if( monthRangeLowest > month4RangeLowest*.995 && monthRangeLowest < month4RangeLowest*1.005){
            month1to4LineLowActual = monthRangeLowest;
         } else{
            deltaX = MathAbs(month4RangeLowestPosition - monthRangeLowestPosition);
            deltaY = (month4RangeLowest - monthRangeLowest);
            
            
            month1to4LineLowM = deltaY/deltaX;
            month1to4LineLowB = month4RangeLowest - month1to4LineLowM * month4RangeLowestPosition;
            // B es el actual... Es en la posicion 0.
            month1to4LineLowActual = month1to4LineLowB;
         }
         
         
         //Month 1 to 6
         if( monthRangeLowest > month6RangeLowest*.995 && monthRangeLowest < month6RangeLowest*1.005){
            month1to6LineLowActual = monthRangeLowest;
         } else{
            deltaX = MathAbs(month6RangeLowestPosition - monthRangeLowestPosition);
            deltaY = (month6RangeLowest - monthRangeLowest);
            
            
            month1to6LineLowM = deltaY/deltaX;
            month1to6LineLowB = month6RangeLowest - month1to6LineLowM * month6RangeLowestPosition;
            // B es el actual... Es en la posicion 0.
            month1to6LineLowActual = month1to6LineLowB;
         }         
         
         //////////////////////////////////////////////////////////////////////NOW goes the trading strat.
         //////////////////////////////////////////////////////////////////////NOW goes the trading strat.
         
         //We check if you are higher/lower than Ask+Avrg or Bid-Avrg, then we select the one closest to price
         z = 0;
         if(month1to2LineHighActual > Ask + Average){
            actualHighsArray[z] = month1to2LineHighActual;
            z+=1;
         }
         if(month1to2LineHighActual > Ask + Average){
            actualHighsArray[z] = month1to3LineHighActual;
            z+=1;
         }         
         if(month1to4LineHighActual > Ask + Average){
            actualHighsArray[z] = month1to4LineHighActual;
            z+=1;
         }
         if(month1to6LineHighActual > Ask + Average){
            actualHighsArray[z] = month1to6LineHighActual;
            z+=1;
         }
         
         z = 0;
         if(month1to2LineLowActual < Bid - Average){
            actualLowsArray[z] = month1to2LineLowActual;
            z+=1;
         }
         if(month1to2LineLowActual < Bid - Average){
            actualLowsArray[z] = month1to3LineLowActual;
            z+=1;
         }         
         if(month1to4LineLowActual < Bid - Average){
            actualLowsArray[z] = month1to4LineLowActual;
            z+=1;
         }
         if(month1to6LineLowActual < Bid - Average){
            actualLowsArray[z] = month1to6LineLowActual;
            z+=1;
         }  
         
         ////////////Now we sort the arrays and choose the closest to ask or bid
         ArraySort(actualHighsArray,WHOLE_ARRAY,0,MODE_DESCEND);
         ArraySort(actualLowsArray,WHOLE_ARRAY,0,MODE_ASCEND);
         
         closestHigh = actualHighsArray[0];
         closestLow = actualLowsArray[0];
         
         ////////////Now making the trade
         if(closestHigh == closestLow){
            closestNotZero = 0;
         }else{closestNotZero = 1;}
         if(closestNotZero == 1){
            if(MathAbs(closestHigh - Ask) < MathAbs(Bid - closestLow)){
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
               x += 1;
               prevDir = 0; // Change this when you change top one. you could do this automatically.     
               if(closestHigh > Bid + Average){
                     SL = closestHigh + Average;
                  }else{
                     SL = Bid + Average;
                  }
            } else{
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
               x += 1;
               prevDir = 1;
                  if(closestLow < Ask - Average){
                     SL = closestLow - Average;
                  }else{
                     SL = Ask - Average;
                  }            
            }
           }// This one ends closestNonZero
          
      }// This one ends OrdersTotal == 0  
                
            
      
     ///Now comes the takeProfit and stopLoss:
             //StopLoss
             if(prevDir == 0){
              
            //El take profit    
               if(month6RangeLowest > Ask){
                  SL = month6RangeLowest  + Average;
                  
                  
                  double deltaAverageAmmount = (month6RangeLowest - Ask)/Average;
                  if(SL > month6RangeLowest - (deltaAverageAmmount/1.5)*Average){
                     SL = month6RangeLowest - (deltaAverageAmmount/1.5)*Average;
                  }
                  
      
               }else if(month4RangeLowest > Ask){
                  SL = month4RangeLowest+ Average;
      
               }else if(month3RangeLowest > Ask){
                  SL = month3RangeLowest  + Average;
      
               }else if(month2RangeLowest > Ask){
                  SL = month2RangeLowest + Average;
      
               }else if(monthRangeLowest > Ask){
                  SL = monthRangeLowest  + Average;
      
               }   
               
               
   
             } //Close PrevDir == 0
             
            if(prevDir == 1){
               if(month6RangeHighest < Bid){
                  SL = month6RangeLowest  - Average;
                  
                  double deltaAverageAmmount = (Bid - month6RangeHighest)/Average;
                  if(SL < month6RangeHighest + (deltaAverageAmmount/1.5)*Average){
                     SL = month6RangeLowest + (deltaAverageAmmount/1.5)*Average;
                  }
               }else if(month6RangeHighest < Bid){
                  SL = month6RangeHighest - Average;
                
               }else if(month4RangeHighest < Bid){
                  SL = month4RangeHighest - Average;
                 
               }else if(month3RangeHighest < Bid){
                  SL = month3RangeHighest - Average;
               
               }else if(month2RangeHighest < Bid){
                  SL = month2RangeHighest - Average;
                  
               }else if(monthRangeHighest < Bid){
                  SL = monthRangeHighest - Average;
      
               }   
               
               
               
             }// Close PrevDir == 1
     
     
     
     } //This one ends currentBars
      
             
   
      if(prevDir == 0){
         if(iClose(Symbol(),BarTimeFrame,1) > SL  ){
            CloseAllOrders();
         }
      }else if(prevDir == 1){
         if(iClose(Symbol(),BarTimeFrame,1) < SL  ){
            CloseAllOrders();
         }
      }
   
   
   
   
   
   //Comment and current bars
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   /*
   Comment( "\n",
   "WeekRangeH: ", weekRangeHighest, " PositionH: ", weekRangeHighestPosition, "\n",
   "WeekRangeL: ", weekRangeLowest," PositionL: ", weekRangeLowestPosition,"\n",
   "MonthRangeHighest: ", monthRangeHighest, " PositionH: ", monthRangeHighestPosition, "\n",
   "MonthRangeLowest: ", monthRangeLowest, " PositionL: ", monthRangeLowestPosition, "\n",
   "Month2RangeH: ", month2RangeHighest, " PositionH: ", month2RangeHighestPosition,  "\n",
   "Month2RangeL: ", month2RangeLowest, " PositionL: ", month2RangeLowestPosition,  "\n",
   "Month3RangeL: ", month3RangeLowest, " PositionL: ", month3RangeLowestPosition, "\n",
   "Month3RangeH: ", month3RangeHighest, " PositionH: ", month3RangeHighestPosition,  "\n",
   "Month4RangeL: ", month4RangeLowest, " PositionL: ", month4RangeLowestPosition, "\n",
   "Month4RangeH: ", month4RangeHighest, " PositionH: ", month4RangeHighestPosition,  "\n",
   "Month6RangeL: ", month6RangeLowest, " PositionL: ", month6RangeLowestPosition, "\n",
   "Month6RangeH: ", month6RangeHighest, " PositionH: ", month6RangeHighestPosition,  "\n",
   "month2PartialHighest: ", month2PartialHighest, " month2PartialLowest: ");
   
   
   //"month3PartialHighest: ", month3PartialHighest, "  month3PartialLowest: ", month3PartialLowest, "\n",
   //"month4PartialHighest: ", month4PartialHighest, "  month4PartialLowest: ", month4PartialLowest, "\n"
      
      
   Comment("ActualLine1To2Low: ", month1to2LineLowActual, "\n",
      "ActualLine1To3Low: ", month1to3LineLowActual, "\n",
      "ActualLine1To4Low: ", month1to4LineLowActual, "\n",
      "ActualLine1To6Low: ", month1to6LineLowActual, "\n",
      "ActualLine1To2High: ", month1to2LineHighActual, "\n",
      "ActualLine1To3High: ", month1to3LineHighActual, "\n",
      "ActualLine1To4High: ", month1to4LineHighActual, "\n",
      "ActualLine1To6High: ", month1to6LineHighActual, "\n",
      "month2PartialHighest: ", month2PartialHighest, " month2PartialLowest: ", month2PartialLowest,"\n",
      "month3PartialHighest: ", month3PartialHighest, "  month3PartialLowest: ", month3PartialLowest, "\n",
      "month4PartialHighest: ", month4PartialHighest, "  month4PartialLowest: ", month4PartialLowest, "\n",
      "closestHigh: ", closestHigh, " closestLow: ", closestLow, "\n",
      "SL: ", SL, "\n"
      );      
      
   */
   Comment(
   "closestHigh: ", closestHigh, " closestLow: ", closestLow, "\n",
   "SL: ", SL, "\n",
   "MonthRangeHighest: ", monthRangeHighest, "\n",
   "MonthRangeLowest: ", monthRangeLowest, "\n",
   "Month2RangeH: ", month2RangeHighest,  "\n",
   "Month2RangeL: ", month2RangeLowest,   "\n",
   "Month3RangeL: ", month3RangeLowest,  "\n",
   "Month3RangeH: ", month3RangeHighest,   "\n",
   "Month4RangeL: ", month4RangeLowest,  "\n",
   "Month4RangeH: ", month4RangeHighest,   "\n",
   "Month6RangeL: ", month6RangeLowest, "\n",
   "Month6RangeH: ", month6RangeHighest, "\n",
   "WeekClosedirArray0,1,2: ",weekCloseDirectionsArray[0], " ", weekCloseDirectionsArray[1], " ", weekCloseDirectionsArray[2], "\n",
   "IsTrend: ", isTrend,"\n",
   "Average: ", Average, "\n",
   "Closest non cero: ", closestNotZero, "\n",
   "hAndlBandTouch: ", hBandTouch, " ", lBandTouch,"\n",
   "currentBars: ",currentBars
   
   );
   
  }
//+------------------------------------------------------------------+
