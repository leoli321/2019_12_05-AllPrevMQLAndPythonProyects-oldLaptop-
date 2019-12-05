//+------------------------------------------------------------------+
//|                                    2019_09_08-SMATrendFinder.mq4 |
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
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 1440;
int extern lastBBandTouchLimit = 10;
double DaySMA20;
double DaySMA50;
double DaySMA100;
double H4SMA20;

double LastDownToUpCross50;
double LastDownToUpCross20;
double LastUpToDownCross20;
double LastUpToDownCross50;
double currentBarsDay;
int prevDir;
int isShortClosed = 0;
int isBuyClosed = 0;
double prevDayOpen;

void OnTick()
  {
//---
   if(currentBars < iBars(Symbol(),240)){
   
      
        DaySMA20 = iMA(Symbol(),BarTimeFrame,20,0,MODE_SMA,PRICE_CLOSE,1);
        DaySMA50 = iMA(Symbol(),BarTimeFrame,50,0,MODE_SMA,PRICE_CLOSE,1);
        DaySMA100 = iMA(Symbol(),BarTimeFrame,100,0,MODE_SMA,PRICE_CLOSE,1);
   
        H4SMA20 = iMA(Symbol(),240,30,0,MODE_SMA,PRICE_CLOSE,1);
        
           LastDownToUpCross50 += .25;
           LastDownToUpCross20 += .25;
           LastUpToDownCross20 += .25;
           LastUpToDownCross50 += .25;  
                 
        if(iClose(Symbol(),BarTimeFrame,2) > DaySMA50 && iClose(Symbol(),BarTimeFrame,1) < DaySMA50){
            LastUpToDownCross50 = 0;
        }
        
        if(iClose(Symbol(),BarTimeFrame,2) < DaySMA50 && iClose(Symbol(),BarTimeFrame,1) > DaySMA50){
            LastDownToUpCross50 = 0;
        }
        
        
        if(iClose(Symbol(),BarTimeFrame,2) > DaySMA20 && iClose(Symbol(),BarTimeFrame,1) < DaySMA20){
            LastUpToDownCross20 = 0;
        }
        
        if(iClose(Symbol(),BarTimeFrame,2) < DaySMA20 && iClose(Symbol(),BarTimeFrame,1) > DaySMA20){
            LastDownToUpCross20 = 0;
        }
        
        
        if(OrdersTotal() == 0){
         prevDayOpen = iOpen(Symbol(),1440,1);
         yo
         if(LastDownToUpCross20 > 10 && LastDownToUpCross50 > 5 && isBuyClosed == 0){
            if(prevDayOpen > DaySMA100  && prevDayOpen > DaySMA50 && prevDayOpen > DaySMA20){
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
               x +=1;
               prevDir = 1;
               isShortClosed = 0; ///REVSA ESTOS
            } 
         }
         
         if(LastUpToDownCross20 > 10 && LastUpToDownCross50 > 5 && isShortClosed == 0){
            if(prevDayOpen < DaySMA100 && prevDayOpen < DaySMA50 && prevDayOpen < DaySMA20){
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
               x +=1;
               prevDir = 0;
               isBuyClosed = 0; ///REVSA ESTOS
            } 
         }
        }//Finish SendOrders
        
        
        if(OrdersTotal() > 0){
           if(prevDir == 1){
               if(iClose(Symbol(),240,1) < H4SMA20){
                  if(AccountProfit() > 0){
                     CloseAllOrders();
                     isBuyClosed = 1;
                     }
               }
               if(iClose(Symbol(),240,1) < DaySMA20){
                  CloseAllOrders();
                  isBuyClosed = 1;
               }
           }else{
               if(iClose(Symbol(),1440,1) > H4SMA20){
                  if(AccountProfit() > 0){
                     CloseAllOrders();
                     isShortClosed = 1;
                  }
               }
               
               if(iClose(Symbol(),1440,1) > DaySMA20){
                  CloseAllOrders();
                  isShortClosed = 1;
               }
               
           }
        }
        
        
   }//Finish currentBars
   
   
   
   currentBars = iBars(Symbol(),240);
   
   Comment(" SMA100,50,20 And H4: ",DaySMA100," ",DaySMA50," ",DaySMA20," ",H4SMA20,"\n",
   "LastTouch, DU50,20. UD50,20:  ",LastDownToUpCross50, " ",LastDownToUpCross20, " ",LastUpToDownCross50, " ",LastUpToDownCross20,"\n",
   "IsBuy Short Closed: ", isBuyClosed, " ",isShortClosed
   );
   
  }
//+------------------------------------------------------------------+
