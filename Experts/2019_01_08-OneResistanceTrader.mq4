//+------------------------------------------------------------------+
//|                               2019_01_08-OneResistanceTrader.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int highestValuePosition;
double highestValue;
extern double Stp = 1.03;
extern double TProfit = 1.01;
extern double LotSize = .1;
int sellticket;
void OnTick()
  {
   
      highestValuePosition = iHighest(NULL,1440,NULL,30,1);
      highestValue = iHigh(Symbol(),1440,highestValuePosition);
      
      Print("highest value: ", highestValue);
      if(OrdersTotal() < 1){
            if(highestValue < Bid){
              sellticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);
              Print("Highest Value LOOP: ", highestValue);
            }
         }
   
  }
//+------------------------------------------------------------------+
