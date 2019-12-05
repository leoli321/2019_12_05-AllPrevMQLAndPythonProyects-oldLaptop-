//+------------------------------------------------------------------+
//|                                2019_02_02-SupAndResLessLines.mq4 |
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

SupportsAndResistancesArray(TotalCandles,CandleInterval){
   
   for(i = 0; i < (TotalCandles/CandleInterval); i++){
      HighIndex = iHighest(Symbol(),10080,MODE_CLOSE,CandleInterval,CandleInterval*i);
      HighArray[i] = iClose(Symbol(),10080,HighIndex); 
   }
   
}

void OnTick()
  {
   
   
   if( DayBars < iBars(Symbol(),1440) )   {
   

      
   }//END PHARENTESIS
   
   DayBars = iBars(Symbol(),1440);

  } // END ON TICK

   
//+------------------------------------------------------------------+
