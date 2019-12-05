//+------------------------------------------------------------------+
//|                              2019_07_11-MAOverMATrendTrading.mq4 |
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
int OrderSelectArray[300];
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


double ArrayOfMAs[10];
int InitialMACandleNumber = 700;
int extern MAPeriod = 15;
double MA1Array[700];
double MA2Array[700];
double MA3Array[700];
double MA4Array[700];
double MA5Array[700];
int BarTimeFrame = 240;
int MABarTimeFrame = 240;
int currentBars;
double currentMAArraySum  = 0;
int currentMAsCount = 0;
int inner_i = 0;
int OpenOrder[300];
int x = 0;
double extern lot_size = .05;
double extern TakeProfit = 20;
int LastOrder;

void OnTick()
  {

   if(iBars(Symbol(),BarTimeFrame) > currentBars){
       
       
       //Building MA's     
      for(int i = 0;i < InitialMACandleNumber;i++){
         MA1Array[i] =  iMA(Symbol(),MABarTimeFrame,MAPeriod,0,MODE_SMA,PRICE_CLOSE,i);
      }
      
      inner_i = 0;
      for(int i = 0;i < InitialMACandleNumber - 10;i++){
         currentMAArraySum += MA1Array[i];
         currentMAsCount += 1;
         if(i% (MAPeriod+inner_i) == 0){  
            MA2Array[inner_i] = currentMAArraySum/currentMAsCount;
            inner_i += 1;
            i = inner_i;
            
         }
         currentMAArraySum = 0;
         currentMAsCount = 0;  
      }    
      
      inner_i = 0;
      for(int i = 0;i < InitialMACandleNumber - 20;i++){
         currentMAArraySum += MA2Array[i];
         currentMAsCount += 1;
         if(i% (MAPeriod+inner_i) == 0){  
            MA3Array[inner_i] = currentMAArraySum/currentMAsCount;
            inner_i += 1;
            i = inner_i;
            
         }
         currentMAArraySum = 0;
         currentMAsCount = 0;  
      }           
   
   //Building MA's END
   //if All ma's point in the same direction, go in the slope.
   
    if((OrdersTotal() > 0) && (AccountProfit() > TakeProfit)){
      CloseAllOrders();
    }
    
    
   if( (MA1Array[0] > MA1Array[1]) && (MA1Array[1] > MA1Array[2]) && (MA1Array[2] > MA1Array[3]) 
      && (MA2Array[0] > MA2Array[1]) && (MA2Array[1] > MA2Array[2]) && (MA2Array[2] > MA2Array[3])    
      && (MA3Array[0] > MA3Array[1]) && (MA3Array[1] > MA3Array[2]) && (MA3Array[2] > MA3Array[3])
      && (OrdersTotal() > 0) && (LastOrder == OP_SELL)
    ){
            CloseAllOrders();
    }
   
   if( (MA1Array[0] < MA1Array[1]) && (MA1Array[1] < MA1Array[2]) && (MA1Array[2] < MA1Array[3]) 
      && (MA2Array[0] < MA2Array[1]) && (MA2Array[1] < MA2Array[2]) && (MA2Array[2] < MA2Array[3])    
      && (MA3Array[0] < MA3Array[1]) && (MA3Array[1] < MA3Array[2]) && (MA3Array[2] < MA3Array[3])
      && (OrdersTotal() > 0) && (LastOrder == OP_BUY)
    ){
            CloseAllOrders();
    }     

   
   if( (MA1Array[0] > MA1Array[1]) && (MA1Array[1] > MA1Array[2]) && (MA1Array[2] > MA1Array[3]) 
      && (MA2Array[0] > MA2Array[1]) && (MA2Array[1] > MA2Array[2]) && (MA2Array[2] > MA2Array[3])    
      && (MA3Array[0] > MA3Array[1]) && (MA3Array[1] > MA3Array[2]) && (MA3Array[2] > MA3Array[3])
      && (OrdersTotal() < 1)
    ){
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         x = x+1;                  
         LastOrder = OP_BUY;
    
    }
   
   if( (MA1Array[0] < MA1Array[1]) && (MA1Array[1] < MA1Array[2]) && (MA1Array[2] < MA1Array[3]) 
      && (MA2Array[0] < MA2Array[1]) && (MA2Array[1] < MA2Array[2]) && (MA2Array[2] < MA2Array[3])    
      && (MA3Array[0] < MA3Array[1]) && (MA3Array[1] < MA3Array[2]) && (MA3Array[2] < MA3Array[3])
      && (OrdersTotal() < 1)
    ){
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x = x+1;                  
         LastOrder = OP_SELL;
    
    }   
     
   
   
   
   }
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
   
    if((OrdersTotal() > 0) && (AccountProfit() > TakeProfit)){
      CloseAllOrders();
    }   
   
   Comment(
      MA2Array[0], "\n",
      MA2Array[1], "\n",
      MA2Array[2], "\n",
      "NOW MA 1: ", "\n",
      MA1Array[0], "\n",
      MA1Array[1], "\n",
      MA1Array[2], "\n",
      "NOW MA 3: ", "\n",
      MA3Array[0], "\n",
      MA3Array[1], "\n",
      MA3Array[2]      
   );
   
  }
//+------------------------------------------------------------------+
