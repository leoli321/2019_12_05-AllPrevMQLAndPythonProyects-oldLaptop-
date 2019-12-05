//+------------------------------------------------------------------+
//|                                            CreateRandomTrade.mq4 |
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
int CalculateRandomNumber(){

   MathSrand(GetTickCount()); //initialize random (With seed?)
   
   double RandomNumber = MathRand()%2; //Create 1 or 0 random number
   
   return RandomNumber;
   
   
}