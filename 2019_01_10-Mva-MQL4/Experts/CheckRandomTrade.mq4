//+------------------------------------------------------------------+
//|                                             CheckRandomTrade.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void CheckRandomTrade(){

   if (CalculateRandomNumber()==0){
       if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int buyticket = OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,(Ask*TakeProfitLong),NULL,0,0,Green);
      }
   }


   if (CalculateRandomNumber()==1){
      if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int sellticket = OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,(Bid*TakeProfitShort),NULL,0,0,Red);
      }
   }
}