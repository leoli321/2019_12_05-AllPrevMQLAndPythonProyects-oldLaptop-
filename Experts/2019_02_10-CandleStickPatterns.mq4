//+------------------------------------------------------------------+
//|                               2019_02_10-CandleStickPatterns.mq4 |
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


bool Hammer(int TimeFrame){
   bool IsHammer = false;
   if( iClose(Symbol(),TimeFrame,2) < iOpen(Symbol(),TimeFrame,2)  ){
      double BodySize = iClose(Symbol(),TimeFrame,1) - iOpen(Symbol(),TimeFrame,1);
      double HighCloseDistance = iHigh(Symbol(),TimeFrame,1) - iClose(Symbol(),TimeFrame,1);
      double LowOpenDistance = iOpen(Symbol(),TimeFrame,1) - iLow(Symbol(),TimeFrame,1);
      
      if(      (BodySize > 0) &&   (   (HighCloseDistance*2) < BodySize )
        &&  ( LowOpenDistance > (BodySize*2) )    ){
            IsHammer = true;      
        }   
   
   }
   
   return(IsHammer);

}

bool InvertedHammer(int TimeFrame){
   bool IsInvertedHammer = false;
   if( iClose(Symbol(),TimeFrame,2) < iOpen(Symbol(),TimeFrame,2)  ){
      double BodySize = iClose(Symbol(),TimeFrame,1) - iOpen(Symbol(),TimeFrame,1);
      double HighCloseDistance = iHigh(Symbol(),TimeFrame,1) - iClose(Symbol(),TimeFrame,1);
      double LowOpenDistance = iOpen(Symbol(),TimeFrame,1) - iLow(Symbol(),TimeFrame,1);
      
      if(      (BodySize > 0) &&   (   (HighCloseDistance) > (BodySize*2) )
        &&  ( LowOpenDistance < (BodySize) )    ){
            IsInvertedHammer = true;      
        }   
   
   }
   
   return(IsInvertedHammer);

}

bool BullishEngulfing(int TimeFrame){
   bool IsBullishEngulfing = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1);
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   if( (Close1 > Open1 ) && (Close2 < Open2) && (Open1 <= Close2) && (Open2 <= Close1)   ){
         IsBullishEngulfing = true;
   }
   
   return IsBullishEngulfing;
}
   

bool BearishEngulfing(int TimeFrame){
   bool IsBearishEngulfing = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   if( (Close1 < Open1 ) && (Close2 > Open2) && (Open1 >= Close2) && (Open2 >= Close1)   ){
         IsBearishEngulfing = true;
   }
   
   return IsBearishEngulfing;
}

bool BullishPiercingLine(int TimeFrame){
   bool IsBullishPiercingLine = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   
   if(   (Open1 < Close1) && (Open1 <= Close2) && 
   ( ((Open2-Close2)*.75 + Close2) <= Close1 ) ){
      IsBullishPiercingLine = true;
   }
   
   return IsBullishPiercingLine;
      
}

bool BearishPiercingLine(int TimeFrame){
   bool IsBearishPiercingLine = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   
   if(   (Open1 > Close1) && (Open1 >= Close2) && 
   ( ((Close2- Open2)*.75 + Open2) >= Close1 ) ){
      IsBearishPiercingLine = true;
   }
   
   return IsBearishPiercingLine;
      
}

bool BullishMorningStar(int TimeFrame){
   bool IsBullishMorningStar = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   double Open3 = iOpen(Symbol(),TimeFrame,3);
   double Close3 = iClose(Symbol(),TimeFrame,3);   
   
   if( (Close3 < Open3)   && ( Close1 > Open1 )  && 
   (  MathAbs(Close2 - Open2) <=  (MathAbs(Close3 - Open3)*0.25 )  )  && (Open2 <= Close3) &&
   (Open1 >= Close2) ){
      IsBullishMorningStar = true;
   } 
      
   return (IsBullishMorningStar);
      
}

bool BearishMorningStar(int TimeFrame){
   bool IsBearishMorningStar = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   double Open3 = iOpen(Symbol(),TimeFrame,3);
   double Close3 = iClose(Symbol(),TimeFrame,3);   
   
   if( (Close3 > Open3)   && ( Close1 < Open1 )  && 
   (  MathAbs(Close2 - Open2) <=  (MathAbs(Close3 - Open3)*0.25 )  )  && (Open2 >= Close3) &&
   (Open1 <= Close2) ){
      IsBearishMorningStar = true;
   } 
      
   return (IsBearishMorningStar);
      
}

bool ThreeWhiteSoldiers(int TimeFrame){

   bool IsThreeWhiteSoldiers = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   double Open3 = iOpen(Symbol(),TimeFrame,3);
   double Close3 = iClose(Symbol(),TimeFrame,3);   
   double Open4 = iOpen(Symbol(),TimeFrame,4); 
   double Close4 = iClose(Symbol(),TimeFrame,4);
   
   if( (Open4 > Close4 )  && (Open3 < Close3) && (Open2 < Close2) && (Open1 < Close1)
   && (Close1 > Close2 > Close3 > Close4)    ){
      IsThreeWhiteSoldiers = true;
   }
   
   return(IsThreeWhiteSoldiers);
   
}


bool ThreeBlackCrows(int TimeFrame){

   bool IsThreeBlackCrows = false;
   double Open1 = iOpen(Symbol(),TimeFrame,1); 
   double Close1 = iClose(Symbol(),TimeFrame,1);
   double Open2 = iOpen(Symbol(),TimeFrame,2);
   double Close2 = iClose(Symbol(),TimeFrame,2);   
   double Open3 = iOpen(Symbol(),TimeFrame,3);
   double Close3 = iClose(Symbol(),TimeFrame,3);   
   double Open4 = iOpen(Symbol(),TimeFrame,4); 
   double Close4 = iClose(Symbol(),TimeFrame,4);
   
   if( (Open4 < Close4 )  && (Open3 > Close3) && (Open2 > Close2) && (Open1 > Close1)
   && (Close1 < Close2 < Close3 < Close4)    ){
      IsThreeBlackCrows = true;
   }
   
   return(IsThreeBlackCrows);
   
}






