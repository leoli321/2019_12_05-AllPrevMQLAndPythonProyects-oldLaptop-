//+------------------------------------------------------------------+
//|                    2018_12_22-GetOpenTradesThisPair-Bootcamp.mq4 |
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
int GetOpenTradesThisPairBootCamp(string CurrencyPair){

int counter=0; //Start counter

for(int i = OrdersTotal()-1; i >= 0; i--){
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES); //selects the order, no idea how it works
   if(OrderSymbol()==CurrencyPair) counter++; //Check if it is the right currency pair
   }
return(counter);

}   
   
   