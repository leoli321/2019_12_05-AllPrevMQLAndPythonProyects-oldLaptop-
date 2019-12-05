//+------------------------------------------------------------------+
//|                       2019_09_07-SimpleSMACrossTinyTimeframe.mq4 |
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
double extern lot_size = .01;
double TP;
double extern LotTPRatio = 1000;
int extern SMAPeriod = 156;
double SMA;
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 240;
int SMALastTouch = 0;
int SMALastTouchCondition = 10;
void OnTick()
  {
//---
   
   if(currentBars < iBars(Symbol(),BarTimeFrame)){
         
         SMA = iMA(Symbol(),BarTimeFrame,SMAPeriod,1,MODE_SMA,PRICE_CLOSE,1);
         TP = lot_size*LotTPRatio;
         
            if(OrdersTotal() == 0){
               if(iClose(Symbol(),BarTimeFrame,1) > SMA && iOpen(Symbol(),BarTimeFrame,1) < SMA){
                  
                  if(SMALastTouch > SMALastTouchCondition){
                     OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
                     x +=1;
                  }
                  
                  SMALastTouch = 0;
                  
               }
               
               if(iClose(Symbol(),BarTimeFrame,1) < SMA && iOpen(Symbol(),BarTimeFrame,1) > SMA){
                  
                  if(SMALastTouch > SMALastTouchCondition){
                     OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
                     x +=1;
                  }
                  
                  SMALastTouch = 0;
               }         
               
               SMALastTouch += 1;
      }//CloseOrdersTotal
   }//Close currentBars
   
   
      if(AccountProfit() > TP){
         CloseAllOrders();
      }
      if(AccountProfit() < -TP){
         CloseAllOrders();
      }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment("SMA: ", SMA, "\n",
   "SMALastTouch: ", SMALastTouch,"\n",
   "AccountProfit: ", AccountProfit()
   );
   
  }
//+------------------------------------------------------------------+
