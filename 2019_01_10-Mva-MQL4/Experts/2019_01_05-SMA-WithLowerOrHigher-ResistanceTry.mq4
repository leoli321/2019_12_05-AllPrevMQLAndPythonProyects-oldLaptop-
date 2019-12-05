//+------------------------------------------------------------------+
//|               2019_01_05-SMA-WithLowerOrHigher-ResistanceTry.mq4 |
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
double SMA_Array[20];
double ArraySum;

void OnTick()
  {  
      
      for(int i = 0; i <= 19; i ++){
         SMA_Array[i] = High[i];
         
         ArraySum = ArraySum + SMA_Array[i];
      }
      
      double ArrayAverage = ArraySum/ArraySize(SMA_Array);
      
      Comment("ArrayAverage: ",ArrayAverage,"\n",
      "Current High: ",High[0],"\n",
       "SMA_Array Size: ",ArraySize(SMA_Array));
       
      ArraySum = 0;


  }
//+------------------------------------------------------------------+
