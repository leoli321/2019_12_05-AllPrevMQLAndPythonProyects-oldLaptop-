//+------------------------------------------------------------------+
//|                          2019_01_17-BollingerBandProbability.mq4 |
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

double BollingerOdds(){
   double ProbabilityModifier = 0;
   if(iClose(Symbol(),10080,2) < iBands(Symbol(),10080,20,2,0,PRICE_CLOSE,MODE_LOWER,2)){
      if(iClose(Symbol(),10080,1) > iBands(Symbol(),10080,20,2,0,PRICE_CLOSE,MODE_LOWER,1)){
         ProbabilityModifier = 25;
      }
   }
   
   if(iClose(Symbol(),10080,2) > iBands(Symbol(),10080,20,2,0,PRICE_CLOSE,MODE_UPPER,2)){
      if(iClose(Symbol(),10080,1) < iBands(Symbol(),10080,20,2,0,PRICE_CLOSE,MODE_UPPER,1)){
         ProbabilityModifier = -25;
      }
   }   
   
   return(ProbabilityModifier);
}