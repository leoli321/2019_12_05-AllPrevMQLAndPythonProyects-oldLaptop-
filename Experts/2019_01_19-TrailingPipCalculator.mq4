//+------------------------------------------------------------------+
//|                             2019_01_19-TrailingPipCalculator.mq4 |
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
/*
   //NOTA: SMA y ATR deben de tener mismo periodo y mismo timeframe
   NOTA: ESTE DEBE DE SER VISTO COMO PARTE DEL CODIGO DE PROBABILISTIC TRADE

*/

double TrailPips(){
   int SMAATR_Timeframe = 1440;
   int SMAATR_Period = 20;
   double SMA;
   SMA = iMA(Symbol(),SMAATR_Timeframe,SMAATR_Period,0,MODE_SMA,PRICE_CLOSE,0);
   double Distance;
   double ATR;

   Distance = MathAbs(SMA - iClose(Symbol(),SMAATR_Timeframe,0));
   ATR = iATR(Symbol(),SMAATR_Timeframe,SMAATR_Period,0);   
   //TrailingPips = (iHigh(NULL,10080,iHighest(NULL,10080,NULL,10,0)) - iLow(NULL,10080,iLowest(NULL,10080,NULL,10,0))) * TrailingPipModifier ;   
   
   TrailingPips = Distance + ATR*2;
   
   return(TrailingPips);
   
 }