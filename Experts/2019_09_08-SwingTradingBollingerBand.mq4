//+------------------------------------------------------------------+
//|                         2019_09_08-SwingTradingBollingerBand.mq4 |
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
double bHigh;
double bLow;
double bMid;
double extern lot_size = .01;
double TP;
double extern LotTPRatio = 1000;
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 1440;
int extern lastBBandTouchLimit = 10;
int lastBBandTouch = 0;
int touchDir;
double SL;
double Average;
void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
   
      Average = 0;
      for(int i=0;i < lastBBandTouchLimit;i++){
            Average += MathAbs(iOpen(Symbol(),BarTimeFrame,i) - iClose(Symbol(),BarTimeFrame,i));
         }
      Average = (Average / lastBBandTouchLimit);
     
     bHigh = iBands(Symbol(),BarTimeFrame,20,2,0,PRICE_CLOSE,MODE_UPPER,1);
     bLow = iBands(Symbol(),BarTimeFrame,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
     bMid = iBands(Symbol(),BarTimeFrame,20,2,0,PRICE_CLOSE,MODE_MAIN,1);
     if(iClose(Symbol(),BarTimeFrame,1) > bHigh){
      lastBBandTouch = 0;
      touchDir = 1;
     }
     
     
     if(iClose(Symbol(),BarTimeFrame,1) < bLow){
      lastBBandTouch = 0;
      touchDir = 0;
     }
     
     lastBBandTouch += 1;
     
     if(OrdersTotal() == 0){
        if(lastBBandTouch < lastBBandTouchLimit){
         
         if(touchDir == 1){
            if( (iClose(Symbol(),BarTimeFrame,1) < bMid ) &&  
            MathAbs( iOpen(Symbol(),BarTimeFrame,1) -  iClose(Symbol(),BarTimeFrame,1)  ) > Average
            ){
               TP = Bid - Average*2;
               SL = Ask + Average*2;
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,SL,TP,NULL,NULL,NULL);
               x +=1;
            }
         
         }
         
         
         if(touchDir == 0){
            if( (iClose(Symbol(),BarTimeFrame,1) > bMid ) &&  
            MathAbs( iOpen(Symbol(),BarTimeFrame,1) -  iClose(Symbol(),BarTimeFrame,1)  ) > Average
            ){
               TP = Ask + Average*3;
               SL = Bid - Average*2;
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,SL,TP,NULL,NULL,NULL);
               x +=1;
            }
         
         }
        
        }
     }
     
   }//Finish currentBars;
   
   
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment("lastTouch: ", lastBBandTouch, " TouchDir: ", touchDir, " Average: ",Average,"\n",
   "bHigh,Low,Mid: ", bHigh, " ", bLow, " ", bMid
   );
   
  }
//+------------------------------------------------------------------+
