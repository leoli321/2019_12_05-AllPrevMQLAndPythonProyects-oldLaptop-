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
void CloseAllOrdersThisPair()
{
   for (int i = OrdersTotal(); i >=0; i--){
    if (OrderSelect(1,SELECT_BY_POS)==TRUE){
      if (OrderSymbol() == Symbol()){
         int type = OrderType();
         bool result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Red);
      
      }
           
    }
   
   } 

}

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
double BackwardHighArray[200];
double ForwardLowArray[200];
double BackwardLowArray[200];
double TimeFrameCandleRange = 300;
double MaxPoint = 0;
int TimeFrame = 60;
int BarTimeFrame = 60;
//NOTA: Lit la candle actual se ignora.
//Prev candle es la previa de la ultima completada.
double PrevCandleMaxArray[2];
int CurrentBars;
int CurrentForwardHighArrayPosition = 0;

double Lot_Size = .2;
int OpenOrder[200];
bool OrderCloseArray[200];
int MinimumBars;
int MinBarTimeFrame = 1;
int CurrentOrderNumber = 0;
double currentProfit;

void OnTick()
  {
  
    if(   iBars(Symbol(),BarTimeFrame) > CurrentBars   ){
        //////////////////////////////Creando el prev candle Array 
        CurrentForwardHighArrayPosition = 0;
        for(int i= 1; i < TimeFrameCandleRange;i++){
            
            if( iOpen(Symbol(),TimeFrame,i) > iClose(Symbol(),TimeFrame,i)  ){
               MaxPoint = iOpen(Symbol(),TimeFrame,i); 
            } else if( iOpen(Symbol(),TimeFrame,i) < iClose(Symbol(),TimeFrame,1)     ){
               MaxPoint = iClose(Symbol(),TimeFrame,i); 
            }
            
            //Creando el prev candle Array 
            if(  iOpen(Symbol(),TimeFrame,i+1) > iClose(Symbol(),TimeFrame,i+1) ){
               PrevCandleMaxArray[0] = iOpen(Symbol(),TimeFrame,i+1);
            } else if( iOpen(Symbol(),TimeFrame,i+1) < iClose(Symbol(),TimeFrame,i+1)    ){
               PrevCandleMaxArray[0] = iClose(Symbol(),TimeFrame,i+1);
            }
            
            if(  iOpen(Symbol(),TimeFrame,i+2) > iClose(Symbol(),TimeFrame,i+2) ){
               PrevCandleMaxArray[1] = iOpen(Symbol(),TimeFrame,i+2);
            } else if( iOpen(Symbol(),TimeFrame,i+2) < iClose(Symbol(),TimeFrame,i+2)    ){
               PrevCandleMaxArray[1] = iClose(Symbol(),TimeFrame,i+2);
            }         
            
            if( (MaxPoint > PrevCandleMaxArray[0]) && (MaxPoint > PrevCandleMaxArray[1]) ){
               ForwardHighArray[CurrentForwardHighArrayPosition] = MaxPoint;
               CurrentForwardHighArrayPosition = CurrentForwardHighArrayPosition + 1;
            }
            
        }
        
      if( (ForwardHighArray[0] > ForwardHighArray[1]) && 
        (ForwardHighArray[0] > ForwardHighArray[2])&&
         (OrdersTotal() < 1)
         ){
            OpenOrder[CurrentOrderNumber] = OrderSend(Symbol(),OP_BUY,Lot_Size,Ask,10,NULL,NULL,NULL,NULL,NULL,NULL);
     }
         //////////////////////////////Creando el prev candle Array 
   }
   
   
   
   

    if ((OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES) == true) 
      && (OrderProfit() > 150)
    ){
      OrderCloseArray[CurrentOrderNumber] = OrderClose(OpenOrder[CurrentOrderNumber],Lot_Size,Bid,10,NULL);
      CurrentOrderNumber = CurrentOrderNumber + 1;
    } else if(
    (OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES) == true) 
      && (OrderProfit() < -100)
    ){
      OrderCloseArray[CurrentOrderNumber] = OrderClose(OpenOrder[CurrentOrderNumber],Lot_Size,Bid,10,NULL);
      CurrentOrderNumber = CurrentOrderNumber + 1;    
    
    }
   
     CurrentBars = iBars(Symbol(),BarTimeFrame);
     MinimumBars = iBars(Symbol(),MinBarTimeFrame);
     Comment(ForwardHighArray[0]," \n", ForwardHighArray[1]," \n", ForwardHighArray[2]
     ," \n", ForwardHighArray[3]
     ," \n", ForwardHighArray[4]
     ," \n MAX: ", ForwardHighArray[ArrayMaximum(ForwardHighArray,WHOLE_ARRAY,0)]
     ," \n", OpenOrder[CurrentOrderNumber]
     ," \n", OrderProfit()
     ," \n", CurrentOrderNumber
     ," \n", (OrderSelect(OpenOrder[CurrentOrderNumber],SELECT_BY_TICKET,MODE_TRADES))
     );
   
  }
//+------------------------------------------------------------------+
