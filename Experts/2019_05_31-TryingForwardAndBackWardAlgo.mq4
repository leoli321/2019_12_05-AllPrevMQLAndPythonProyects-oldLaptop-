//+------------------------------------------------------------------+
//|                                   2019_05_30-JustTryingstuff.mq4 |
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
///--- Just some code snipets.
//if( MaxPoint > ForwardHighArray[ArrayMaximum(ForwardHighArray,WHOLE_ARRAY,0)]){
//     ForwardHighArray[CurrentForwardHighArrayPosition] = MaxPoint;
//     CurrentForwardHighArrayPosition = CurrentForwardHighArrayPosition + 1;}   
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
double ForwardLowArray[200];
double TimeFrameCandleRange = 24;
double MaxPoint = 0;
double MinPoint = 10000;
int TimeFrame = 60;
int BarTimeFrame = 240;
//NOTA: Lit la candle actual se ignora.
//Prev candle es la previa de la ultima completada.
double PrevCandleMaxArray[2];
double PrevCandleMinArray[2];
int CurrentBars;
int CurrentForwardHighArrayPosition = 0;
int CurrentForwardLowArrayPosition = 0;

double Lot_Size = .2;
int OpenOrder[200];
bool OrderCloseArray[200];
int MinimumBars;
int MinBarTimeFrame = 1;
int CurrentOrderNumber = 0;
double currentProfit;

int currentOrderType;
double PriceToCloseOrder;

double extern TakeProfit = 20;
double extern StopLoss = 50;

void OnTick()
  {
  
    if(   iBars(Symbol(),BarTimeFrame) > CurrentBars   ){
        
         //////////////////////////////Creando el Array        
         CurrentForwardHighArrayPosition = 0;
         CurrentForwardLowArrayPosition = 0;
         for(int i = 0; i < 200; i++){
            ForwardHighArray[i] = 0;
         }
         
         for(int i = 0; i < 200; i++){
            ForwardLowArray[i] = Ask*100;
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
         
         //ForwardLowArray
         for(int i= 1; i < TimeFrameCandleRange;i++){
            
            if( iOpen(Symbol(),TimeFrame,i) < iClose(Symbol(),TimeFrame,i)  ){
               MinPoint = iOpen(Symbol(),TimeFrame,i); 
            } else if( iOpen(Symbol(),TimeFrame,i) > iClose(Symbol(),TimeFrame,1)     ){
               MinPoint = iClose(Symbol(),TimeFrame,i); 
            }
            
            if(  iOpen(Symbol(),TimeFrame,i+1) < iClose(Symbol(),TimeFrame,i+1) ){
               PrevCandleMinArray[0] = iOpen(Symbol(),TimeFrame,i+1);
            } else if( iOpen(Symbol(),TimeFrame,i+1) > iClose(Symbol(),TimeFrame,i+1)    ){
               PrevCandleMinArray[0] = iClose(Symbol(),TimeFrame,i+1);
            }
            
            
            if( (MinPoint < PrevCandleMinArray[0])
               && (MinPoint < ForwardLowArray[ArrayMinimum(ForwardLowArray,WHOLE_ARRAY,0)])
             ){
               ForwardLowArray[CurrentForwardLowArrayPosition] = MinPoint;
               CurrentForwardLowArrayPosition = CurrentForwardLowArrayPosition + 1;
            }                                    
            
            
         }      
         
         ///////ORDER OPENING   
         ///ForwardHigh ORDER OPENING
         if( (ForwardHighArray[0] < ForwardHighArray[1]) && 
           (ForwardHighArray[0] < ForwardHighArray[2])&&
            (OrdersTotal() < 1)
            ){
               OpenOrder[CurrentOrderNumber] = OrderSend(Symbol(),OP_SELL,Lot_Size,Bid,10,NULL,NULL,NULL,NULL,NULL,NULL);
        } 
        
        ///ForwardLow ORDER OPENING    
         if( (ForwardLowArray[0] > ForwardLowArray[1]) && 
           (ForwardLowArray[0] > ForwardLowArray[2])&&
            (OrdersTotal() < 1)
            ){
               OpenOrder[CurrentOrderNumber] = OrderSend(Symbol(),OP_BUY,Lot_Size,Ask,10,NULL,NULL,NULL,NULL,NULL,NULL);
        }         
            
    }
    
    if ( (OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES) == true) ){
      currentOrderType = OrderType();
      if (currentOrderType == OP_BUY ){
         PriceToCloseOrder = Bid; 
      } else if (currentOrderType == OP_SELL ){
         PriceToCloseOrder = Ask; 
      }
    }
    
    
    
    if ((OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES) == true) 
      && (OrderProfit() > TakeProfit)
    ){
      OrderCloseArray[CurrentOrderNumber] = OrderClose(OpenOrder[CurrentOrderNumber],Lot_Size,PriceToCloseOrder,10,NULL);
      CurrentOrderNumber = CurrentOrderNumber + 1;
    } else if(
    (OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES) == true) 
      && (OrderProfit() < -StopLoss)
    ){
      OrderCloseArray[CurrentOrderNumber] = OrderClose(OpenOrder[CurrentOrderNumber],Lot_Size,PriceToCloseOrder,10,NULL);
      CurrentOrderNumber = CurrentOrderNumber + 1;    
    
    }    
   
   
     CurrentBars = iBars(Symbol(),BarTimeFrame);
     
      Comment(ForwardHighArray[0]," \n", ForwardHighArray[1]," \n", ForwardHighArray[2]
     ," \n", ForwardHighArray[3]
     ," \n", ForwardHighArray[4]
     ," \n MAX: ", ForwardHighArray[ArrayMaximum(ForwardHighArray,WHOLE_ARRAY,0)]
     ," \n", ForwardLowArray[0]," \n", ForwardLowArray[1]
     ," \n", ForwardLowArray[2]
     ," \n", ForwardLowArray[3]
     ," \n MIN: ", ForwardLowArray[ArrayMinimum(ForwardLowArray,WHOLE_ARRAY,0)]
     ," \n", OrderProfit()
     );
   
  }
//+------------------------------------------------------------------+
