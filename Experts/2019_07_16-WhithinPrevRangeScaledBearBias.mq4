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
double extern Scale = 5;
double extern lot_size = .1;
double extern TakeProfit = 75;
double extern StopLossMultiplier = 1;
int WeeklyOrder = 0;

double StopLoss;// = -TakeProfit * StopLossMultiplier;
double OriginalLotSize = .1;
double OriginalTakeProfit = TakeProfit;

double currentAccountBalance;
int PreviousAccountBalanceReached = 0;
int IsSecondTradeOpen = 0;


double ScaledLot_size = lot_size * Scale;
double ScaledTakeProfit = TakeProfit * Scale;
double ScaledStopLoss = -ScaledTakeProfit * StopLossMultiplier;

double OriginalAccountBalance = AccountBalance(); //EscalamientoLineal. // I could make this an extern for rolling scaling.
double currentAccountBalanceRatio;
double currentLot_size;
double currentTakeProfit;
double currentStopLoss;
double extern CounterTradeMultiplier = 1;


int firstTickSetPrevPeriod = 0;

double PrevPeriodLowestClose = 0;
double PrevPeriodHighestClose = 0;



void OnTick()
  {
  
       if(firstTickSetPrevPeriod == 0){
      PrevPeriodHighestClose = iHigh(Symbol(),BarTimeFrame,iHighest(Symbol(),BarTimeFrame,MODE_HIGH,180,0));
      PrevPeriodLowestClose = iLow(Symbol(),BarTimeFrame,iLowest(Symbol(),BarTimeFrame,MODE_LOW,180,0));
      firstTickSetPrevPeriod = 1;
   }
  
  
   if (AccountBalance() > OriginalAccountBalance){
        currentAccountBalanceRatio = AccountBalance()/OriginalAccountBalance;
        currentLot_size = ScaledLot_size * currentAccountBalanceRatio;
        currentTakeProfit = ScaledTakeProfit * currentAccountBalanceRatio;
        currentStopLoss = ScaledStopLoss * currentAccountBalanceRatio;
   } else{  
            currentLot_size = ScaledLot_size;
            currentTakeProfit = ScaledTakeProfit;
            currentStopLoss = ScaledStopLoss;
    }
  
     if(currentBars < iBars(Symbol(),BarTimeFrame)){
        StopLoss = currentStopLoss - (MarketInfo(Symbol(),MODE_SPREAD) * Scale * currentAccountBalanceRatio);
        //The higher the sale, the less Market info is relevant?. This is worth explorin.
        //This market info spread shit is a magic number or something?
        //What if to scale it I just tell it to make the same 20 trades, instead of increasing lot_size.
         
         if(iClose(Symbol(),BarTimeFrame,1) < ThisWeek4HLowestClose ){
            ThisWeek4HLowestClose = iClose(Symbol(),BarTimeFrame,1);
         }
         if(iClose(Symbol(),BarTimeFrame,1) > ThisWeek4HHighestClose ){
            ThisWeek4HHighestClose = iClose(Symbol(),BarTimeFrame,1);
         }
         
         
         
            
            ///////////ENTRADAS Ahorita tienes un bear bias.
            if( (OrdersTotal() < 1) && (WeeklyOrder == 0) &&
            (iClose(Symbol(),BarTimeFrame,1) > PrevWeek4HLowestClose)    
            ){
               OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size*CounterTradeMultiplier ,Bid,3,NULL,NULL,NULL,NULL,NULL);
               x += 1;
               WeeklyOrder = 1;
            }     
                        
            if( (OrdersTotal() < 1) && (WeeklyOrder == 0) && 
            (iClose(Symbol(),BarTimeFrame,1) < PrevWeek4HHighestClose)    
            ){
               OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size*CounterTradeMultiplier ,Ask,3,NULL,NULL,NULL,NULL,NULL);
               x += 1;
               WeeklyOrder = 1;
            }            
      
    
            ///////////ENTRADASFIN      
      
          
         
         if( TimeDayOfWeek(TimeCurrent()) < currentWeekDay ){
            PrevWeek4HLowestClose = ThisWeek4HLowestClose;
            PrevWeek4HHighestClose = ThisWeek4HHighestClose;
            
            ThisWeek4HHighestClose = 0;
            ThisWeek4HLowestClose = 1000;
            
            CloseAllOrders();
            WeeklyOrder = 0;
         }
         
      
     }
     
     if(AccountProfit() > currentTakeProfit){
      CloseAllOrders();
     }
     
     if(AccountProfit() < StopLoss){
      OrderSelectArray[0] = OrderSelect(OpenOrder[x-1],SELECT_BY_TICKET,MODE_TRADES);
      CloseAllOrders();
      if(OrderType() == OP_BUY){
         OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
      } else{
         OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
         x += 1;
      }
      
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
   "StopLoss: ", StopLoss, "\n",
   "Account profit:", AccountProfit(), "\n"
   );
   
  }
//+------------------------------------------------------------------+
