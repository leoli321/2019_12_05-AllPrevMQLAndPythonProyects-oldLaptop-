//+------------------------------------------------------------------+
//|                     2019_06_13-HigherHighLowerLowTrendFinder.mq4 |
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
double ForwardHighArray[200];
double BackwardLowArray[200];
int TimeFrameCandleRange = 20;
double MaxPoint = 0;
double MinPoint = 10000;
int TimeFrame = 240;
double PrevCandleMaxArray[2];
double PrevCandleMinArray[2];
int CurrentBars;
int CurrentForwardHighArrayPosition = 0;
int CurrentBackwardLowArrayPosition = 0;

double LastForwardHighArrayValueWhenPositionOpens;

double extern Lot_Size = .2;

double currentProfit;
int CurrentOrderNumber = 0;
int currentOrderType;
double PriceToCloseOrder;
int OpenOrder[200];
bool OrderCloseArray[200];

void OnTick()
  {
//---

   if(   iBars(Symbol(),TimeFrame) > CurrentBars   ){
      
      CurrentForwardHighArrayPosition = 0;
      CurrentBackwardLowArrayPosition = 0;
      for(int i = 0; i < 200; i++){
         ForwardHighArray[i] = 0;
      }      
      for(int i = 0; i < 200; i++){
         BackwardLowArray[i] = Ask*100;
      }         
      
      //ForwardHighArray
      for(int i= 1; i < TimeFrameCandleRange;i++){
            if( iOpen(Symbol(),TimeFrame,i) > iClose(Symbol(),TimeFrame,i)  ){
               MaxPoint = iOpen(Symbol(),TimeFrame,i); 
            } else if( iOpen(Symbol(),TimeFrame,i) < iClose(Symbol(),TimeFrame,1)     ){
               MaxPoint = iClose(Symbol(),TimeFrame,i); 
            }
         
            if(  iOpen(Symbol(),TimeFrame,i+1) > iClose(Symbol(),TimeFrame,i+1) ){
               PrevCandleMaxArray[0] = iOpen(Symbol(),TimeFrame,i+1);
            } else if( iOpen(Symbol(),TimeFrame,i+1) < iClose(Symbol(),TimeFrame,i+1)    ){
               PrevCandleMaxArray[0] = iClose(Symbol(),TimeFrame,i+1);
            }         

           if( (MaxPoint > PrevCandleMaxArray[0])
               && (MaxPoint > ForwardHighArray[ArrayMaximum(ForwardHighArray,WHOLE_ARRAY,0)])
             ){
               ForwardHighArray[CurrentForwardHighArrayPosition] = MaxPoint;
               CurrentForwardHighArrayPosition = CurrentForwardHighArrayPosition + 1;
            }             
         
      }
      
      //BackwardLowArray
      for(int i = TimeFrameCandleRange; i > 1;i--){
            if( iOpen(Symbol(),TimeFrame,i) > iClose(Symbol(),TimeFrame,i)  ){
               MinPoint = iClose(Symbol(),TimeFrame,i); 
            } else if( iOpen(Symbol(),TimeFrame,i) < iClose(Symbol(),TimeFrame,1)     ){
               MinPoint = iOpen(Symbol(),TimeFrame,i); 
            }       
            
            if(  iOpen(Symbol(),TimeFrame,i+1) > iClose(Symbol(),TimeFrame,i+1) ){
               PrevCandleMinArray[0] = iClose(Symbol(),TimeFrame,i+1);
            } else if( iOpen(Symbol(),TimeFrame,i+1) < iClose(Symbol(),TimeFrame,i+1)    ){
               PrevCandleMinArray[0] = iOpen(Symbol(),TimeFrame,i+1);
            }             
            
            if( (MinPoint < PrevCandleMinArray[0])
               && (MinPoint < BackwardLowArray[ArrayMinimum(BackwardLowArray,WHOLE_ARRAY,0)])
             ){
               BackwardLowArray[CurrentBackwardLowArrayPosition] = MinPoint;
               CurrentBackwardLowArrayPosition  = CurrentBackwardLowArrayPosition  + 1;
            }             
              
      }      
      
   }
   
   
      ///////ORDER OPENING   
         ///ForwardHigh ORDER OPENING
    if( (ForwardHighArray[0] < ForwardHighArray[1]) && 
           (ForwardHighArray[0] < ForwardHighArray[2])&&
           (ForwardHighArray[0] < ForwardHighArray[3])&&
            (OrdersTotal() < 1)
            ){
               OpenOrder[CurrentOrderNumber] = OrderSend(Symbol(),OP_SELL,Lot_Size,Bid,10,NULL,NULL,NULL,NULL,NULL,NULL);
               LastForwardHighArrayValueWhenPositionOpens = ForwardHighArray[0];
        } 
        
   
   Comment(ForwardHighArray[0]," \n", ForwardHighArray[1]," \n", ForwardHighArray[2],
   " \n", ForwardHighArray[3],
   " \n", "AAAA",
   " \n", BackwardLowArray[0],
   " \n", BackwardLowArray[1],
   " \n", BackwardLowArray[2]
   );
   
   CurrentBars = iBars(Symbol(),TimeFrame);
   
  }
//+------------------------------------------------------------------+
