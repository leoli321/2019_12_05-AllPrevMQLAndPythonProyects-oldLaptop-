//+------------------------------------------------------------------+
//|                            2019_07_12-WhitinPrevCandleRanges.mq4 |
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

///La idea es que tomes una semana? Un periodod de tiempo de 4hCandles, y si 
///Luego se rompe el rango compras o vendes en la direccion que se haya roto
//(Tambien puedes hacer lo contrario y apostar en la direccion contraria.

double PrevWeek4HLowestClose;
double PrevWeek4HHighestClose;
double ThisWeek4HLowestClose = 1000;
double ThisWeek4HHighestClose;
int currentBars;
int currentWeekDay;
int BarTimeFrame = 240;
int OpenOrder[3000];
int x = 0;
double extern lot_size = .1;
double extern TakeProfit = 75;
double extern StopLossMultiplier = 1;
int WeeklyOrder = 0;

double StopLoss = -TakeProfit * StopLossMultiplier;
double OriginalLotSize = .1;
double OriginalTakeProfit = TakeProfit;
double OriginalStopLoss = StopLoss;
double currentAccountBalance;
int PreviousAccountBalanceReached = 0;
int IsSecondTradeOpen = 0;

void OnTick()
  {
     if(currentBars < iBars(Symbol(),BarTimeFrame)){
     StopLoss = OriginalStopLoss;
     StopLoss = StopLoss - MarketInfo(Symbol(),MODE_SPREAD);
      
      if(iClose(Symbol(),BarTimeFrame,1) < ThisWeek4HLowestClose ){
         ThisWeek4HLowestClose = iClose(Symbol(),BarTimeFrame,1);
      }
      if(iClose(Symbol(),BarTimeFrame,1) > ThisWeek4HHighestClose ){
         ThisWeek4HHighestClose = iClose(Symbol(),BarTimeFrame,1);
      }
      
      
      
         
         ///////////ENTRADAS Ahorita tienes un bull bias.
         if( (OrdersTotal() < 1) && (WeeklyOrder == 0) && 
         (iClose(Symbol(),BarTimeFrame,1) < PrevWeek4HHighestClose)    
         ){
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
         }            
   
         if( (OrdersTotal() < 1) && (WeeklyOrder == 0) &&
         (iClose(Symbol(),BarTimeFrame,1) > PrevWeek4HLowestClose)    
         ){
            OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
         }           
         ///////////ENTRADASFINOrden1
         
         
         ///////////ENTRADAS Ahorita tienes un bear bias.
         if( (IsSecondTradeOpen == 0) && (WeeklyOrder == 0) && 
         (iClose(Symbol(),BarTimeFrame,1) < PrevWeek4HHighestClose)    
         ){
            OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
            WeeklyOrder = 1;
            IsSecondTradeOpen = 1;
         }            
   
         if( (IsSecondTradeOpen == 0) && (WeeklyOrder == 0) &&
         (iClose(Symbol(),BarTimeFrame,1) > PrevWeek4HLowestClose)    
         ){
            OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
            x += 1;
            WeeklyOrder = 1;
            IsSecondTradeOpen = 1;
         }           
         ///////////ENTRADASFIN      
   
       
      
      if( TimeDayOfWeek(TimeCurrent()) < currentWeekDay ){
         PrevWeek4HLowestClose = ThisWeek4HLowestClose;
         PrevWeek4HHighestClose = ThisWeek4HHighestClose;
         
         ThisWeek4HHighestClose = 0;
         ThisWeek4HLowestClose = 1000;
         
         CloseAllOrders();
         WeeklyOrder = 0;
         IsSecondTradeOpen = 0;
      }
      
      
     }
     
     if(AccountProfit() > TakeProfit){
      CloseAllOrders();
      IsSecondTradeOpen = 0;
     }
     
     if(AccountProfit() < StopLoss){
      OrderSelectArray[0] = OrderSelect(OpenOrder[x-1],SELECT_BY_TICKET,MODE_TRADES);
      CloseAllOrders();
      if(OrderType() == OP_BUY){
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,lot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
      } else{
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,lot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
      }
      
      
      IsSecondTradeOpen = 0;
     }
     
     
     currentWeekDay = TimeDayOfWeek(TimeCurrent());
     currentBars = iBars(Symbol(),BarTimeFrame);
   
   Comment(
   "Current Week Day: ",currentWeekDay, "\n",
   "PrevWeekHigh: ", PrevWeek4HHighestClose, "\n",
   "PrevWeekLow: ", PrevWeek4HLowestClose, "\n",
   "ThisWeekHigh: ", ThisWeek4HHighestClose, "\n",
   "ThisWeekLow: ",ThisWeek4HLowestClose, "\n",
   "SPREAD: ", MarketInfo(Symbol(),MODE_SPREAD), "\n",
   "StopLoss: ", StopLoss, "\n"
   );
   
  }
//+------------------------------------------------------------------+
