//+------------------------------------------------------------------+
//|                                2019_02_02-SupAndResLessLines.mq4 |
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

int ActualYear;
double High1;
double High2;
double High3;
double Low1;
double Low2;
double Low3;

double Highest;
double Lowest;
int HighestPosition;
int LowestPosition;

double HighArray[3];
double LowArray[3];
int DayBars;

double CurrentCloseValue;
double CurrentOpenValue;
double NearestValueHigh;
double NearestValueLow;
double ClosestValue;

extern double LotSize = .2; //1
int Ticket_1;
int Ticket_1_Close;
int Ticket_1_OrderDirection;
double Ticket_1_ClosePrice;

int NearestValueHighIndex;
int NearestValueLowIndex;


double YearHigh(int DesiredYear){
   HighestPosition = iHighest(Symbol(),10080,MODE_CLOSE,52, (DesiredYear*52) );
   Highest = iHigh(Symbol(),10080,HighestPosition);
   return(Highest);
}

double YearLow(int DesiredYear){
   LowestPosition = iLowest(Symbol(),10080,MODE_CLOSE,52,(DesiredYear*52));
   Lowest = iLow(Symbol(),10080,LowestPosition);
   return(Lowest);
}
bool IsLastCandleDifferent;
double IsLastCandleDifDirection(int Ticket){   
      IsLastCandleDifferent = false;
      if (  OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket_1_OrderDirection = OrderType(); }
      if(Ticket_1_OrderDirection == OP_BUY) { 
         Ticket_1_ClosePrice = Bid;  
         if(   iClose(Symbol(),1440,1) < iOpen(Symbol(),1440,1)  ){IsLastCandleDifferent = true;    }
      } 
      if(Ticket_1_OrderDirection == OP_SELL){ 
         Ticket_1_ClosePrice = Ask; 
         if(   iClose(Symbol(),1440,1) > iOpen(Symbol(),1440,1)  ){IsLastCandleDifferent = true;    }
      }
      
      return(IsLastCandleDifferent);
      
}

void OnTick()
  {
   
   if(Year() >  ActualYear){
   
      for (int i = 0; i < 3; i++){
         HighArray[i] = YearHigh(i);
         LowArray[i] = YearLow(i);
      }
      
   }
   
   if( DayBars < iBars(Symbol(),1440) )   {
   
      CurrentCloseValue = iClose(Symbol(),1440,1);
      CurrentOpenValue = iOpen(Symbol(),1440,1);
      NearestValueHighIndex = ArrayBsearch(HighArray,CurrentCloseValue,WHOLE_ARRAY,0,MODE_ASCEND);
      NearestValueLowIndex = ArrayBsearch(LowArray,CurrentCloseValue,WHOLE_ARRAY,0,MODE_ASCEND);
      NearestValueHigh = HighArray[NearestValueHighIndex];
      NearestValueLow = LowArray[NearestValueLowIndex];
      
      if(   MathAbs(CurrentCloseValue - NearestValueHigh) > (CurrentCloseValue - NearestValueLow)  ){    
         ClosestValue = NearestValueLow;
      }
      else ClosestValue = NearestValueHigh;
      
      if(  (CurrentCloseValue > ClosestValue) &&   (CurrentOpenValue < ClosestValue  )   && (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == false) 
      && (  HighArray[ArrayMaximum(HighArray,WHOLE_ARRAY,0)] > ClosestValue )   )   {
         Ticket_1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
      }
      
      if(  (CurrentCloseValue < ClosestValue) &&   (CurrentOpenValue > ClosestValue  )   && (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == false)   
      && (  LowArray[ArrayMinimum(LowArray,WHOLE_ARRAY,0)] < ClosestValue ) )   {
         Ticket_1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      }      
      
      
      //SELL CONDITIONS.
      if(   (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true) && (IsLastCandleDifDirection(Ticket_1) == true) ){ 
      
            if (  OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket_1_OrderDirection = OrderType(); }
            if(Ticket_1_OrderDirection == OP_BUY) { Ticket_1_ClosePrice = Bid;  } 
            if(Ticket_1_OrderDirection == OP_SELL){ Ticket_1_ClosePrice = Ask; }
            Ticket_1_Close = OrderClose(Ticket_1,LotSize,Ticket_1_ClosePrice,3,NULL);
            Ticket_1 = NULL;
            
      }      
      
      /*
      
      if(   (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true) && (OrderProfit()  > 100)  ){ //100
            if (  OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket_1_OrderDirection = OrderType(); }
            if(Ticket_1_OrderDirection == OP_BUY) { Ticket_1_ClosePrice = Bid;  } 
            if(Ticket_1_OrderDirection == OP_SELL){ Ticket_1_ClosePrice = Ask; }
            Ticket_1_Close = OrderClose(Ticket_1,LotSize,Ticket_1_ClosePrice,3,NULL);
            Ticket_1 = NULL;
            
      }      
      
      if(   (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap())  < -50)  ){
            if (  OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket_1_OrderDirection = OrderType(); }
            if(Ticket_1_OrderDirection == OP_BUY) { Ticket_1_ClosePrice = Bid;  } 
            if(Ticket_1_OrderDirection == OP_SELL){ Ticket_1_ClosePrice = Ask; }
            Ticket_1_Close = OrderClose(Ticket_1,LotSize,Ticket_1_ClosePrice,3,NULL);
            Ticket_1 = NULL;
            
      }      
      */
      
   }
   
   DayBars = iBars(Symbol(),1440);
   
   ActualYear = Year();
   Comment("Closest: ", ClosestValue, "\n",
   "OrderProfit: ", OrderProfit(),"\n",
   "HighArray 1: ", HighArray[0], "\n",
   "HighArray 2: ", HighArray[1], "\n",
   "HighArray 3: ", HighArray[2], "\n",
   "LowArray 1: ", LowArray[0], "\n",
   "LowArray 2: ", LowArray[1], "\n",
   "LowArray 3: ", LowArray[2], "\n",
   "Candle direction: ", IsLastCandleDifDirection(Ticket_1), "\n");
  
  }

   
//+------------------------------------------------------------------+
