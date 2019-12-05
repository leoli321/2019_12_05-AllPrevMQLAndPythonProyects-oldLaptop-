//+------------------------------------------------------------------+
//|                                              CheckPriceRange.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void CheckPriceRange(){

if (Symbol()=="USDCAD"){

   double MaxUpperPrice = 1.43520;
   double MinLowerPrice = 1.18520;
   
   if (Ask > MinLowerPrice && Ask < MaxUpperPrice){PriceIsInRange = "buysell"; }
   
   if (Ask > MaxUpperPrice) { PriceIsInRange = "sellonly"; }
   
   if (Ask < MinLowerPrice) { PriceIsInRange = "buyonly"; }

}

}