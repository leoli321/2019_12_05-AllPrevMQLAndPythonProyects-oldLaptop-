//+------------------------------------------------------------------+
//|                         2019_02_07-AddingPerCorrectDirection.mq4 |
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


int CloseAllOrders(){

  int total = OrdersTotal();
  for(int i=total-1;i>=0;i--)
  {
    int checkedError = OrderSelect(i, SELECT_BY_POS);
    int type   = OrderType();

    bool result = false;
    
    switch(type)
    {
      //Close opened long positions
      case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                          break;
      
      //Close opened short positions
      case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                          break;

      //Close pending orders
      case OP_BUYLIMIT  :
      case OP_BUYSTOP   :
      case OP_SELLLIMIT :
      case OP_SELLSTOP  : result = OrderDelete( OrderTicket() );
    }
    
    if(result == false)
    {
      Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      Sleep(3000);
    }  
  }
  
  return(0);
}



string CandleColour;

string CandleColor(int TimeFrame){
   if( iClose(Symbol(),TimeFrame,1) > iOpen(Symbol(),TimeFrame,1)  ){  CandleColour = "GREEN";  }
   if( iClose(Symbol(),TimeFrame,1) < iOpen(Symbol(),TimeFrame,1)  ){  CandleColour = "RED";    }
   return(CandleColour);
   
}

int OrderDirection;
double OrderDir(int OrderIdentity){
   if (  OrderSelect(DayOrderArray[OrderIdentity],SELECT_BY_TICKET,MODE_TRADES) == true   ){ OrderDirection = OrderType(); }
   return(OrderDirection);
}




int WeekOrderArray[300];
int DayOrderArray[300];
int CloseOrderArray[300];
int DayOrderIdentifier = 0;

int DayBars;
int WeekBars;
int WeekTicket;
double LotSize = .01;
int CloseWeek;
int CountArray = 0;


void OnTick()
  {
  
   if( DayBars < iBars(Symbol(),1440) )   {
      Print("dayBarLoop");
      if(WeekBars < iBars(Symbol(),10080)){
         Print("WeekBarLoop");
         if (  OrderSelect(WeekTicket,SELECT_BY_TICKET,MODE_TRADES) == false   ){
            if(   CandleColor(10080) == "GREEN" ){
               WeekTicket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               CountArray = CountArray + 1;
            }
            
            if(   CandleColor(10080) == "RED" ){
               WeekTicket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               CountArray = CountArray + 1;
            }
         }
         
         //COVER IF CONDITIONS ARE MET.
         if (  OrderSelect(WeekTicket,SELECT_BY_TICKET,MODE_TRADES) == true   ){
         
         
            if(   (OrderDir(WeekTicket) == OP_BUY ) && (CandleColor(10080) == "RED" )  ){
               Print("SHOULD SELL");
               CloseWeek = OrderClose(WeekTicket,LotSize,Bid,3,NULL);
               WeekTicket = NULL;
               
               for(int i = 0; i <= CountArray; i++){
                  CloseOrderArray[i] = OrderClose(DayOrderArray[i],LotSize,Bid,3,NULL);
                  DayOrderArray[i] = NULL;
                  
               }
               CloseAllOrders();
               CountArray = 0;
               DayOrderIdentifier = 0;
            }
            
            
            if(   (OrderDir(WeekTicket) == OP_SELL ) && (CandleColor(10080) == "GREEN" )  ){
               Print("SHOULD COVER");
               CloseWeek = OrderClose(WeekTicket,LotSize,Ask,3,NULL);
               WeekTicket = NULL;
               
               for(int i = 0; i <= CountArray; i++){
                  CloseOrderArray[i] = OrderClose(DayOrderArray[i],LotSize,Ask,3,NULL);
                  DayOrderArray[i] = NULL;
               }
               CloseAllOrders();
               CountArray = 0;
               DayOrderIdentifier = 0;
            }            
         
         
         }
      }
      
      //SEND ORDER IF CONDITIONS ARE MET.
      if (  (OrderDir(WeekTicket) == OP_BUY) && ( CandleColor(1440) == "GREEN"  ) ){
         DayOrderArray[DayOrderIdentifier] = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
         DayOrderIdentifier = DayOrderIdentifier + 1;
         CountArray = CountArray + 1;
      }
      
      if (  (OrderDir(WeekTicket) == OP_SELL) && ( CandleColor(1440) == "RED"  ) ){
         DayOrderArray[DayOrderIdentifier] = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         DayOrderIdentifier = DayOrderIdentifier + 1;
         CountArray = CountArray + 1;
      }      
   
   }
   DayBars = iBars(Symbol(),1440);
   WeekBars = iBars(Symbol(),10080);
   Comment(CountArray);
  }
//+------------------------------------------------------------------+
