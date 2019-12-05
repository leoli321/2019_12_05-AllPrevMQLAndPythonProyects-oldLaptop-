//+------------------------------------------------------------------+
//|                                   2019_01_18-MACDProbability.mq4 |
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

double MACDOdds(){
   double ProbabilityModifier = 0;
   
   if(iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,2) < 0){
    if(iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,2) < iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,1)){ // Menor porque el valor es menos negativo
      ProbabilityModifier = +15;
    }
   }

   if(iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,2) > 0){
    if(iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,2) > iMACD(Symbol(),10080,12,26,9,PRICE_CLOSE,0,1)){ // Menor porque el valor es menos negativo
      ProbabilityModifier = -15;
    }
   }
   
   
   return(ProbabilityModifier);
}