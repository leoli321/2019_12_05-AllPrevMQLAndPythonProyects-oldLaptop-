//+------------------------------------------------------------------+
//|                                2019_01_21-TripleMATrade3Code.mq4 |
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
   if(OpenTicket3 == "FALSE"){
      //BUY
      if(NormalizedSlope3 > 0.05){
         if( (SMA3- PrevSMA3) > 0){
            Ticket3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket3 = "TRUE";      
            OrderDirection3 = "BUY"; 
            OrderPrice3 = Ask;
         } 
      }  
      //SELL
      if(NormalizedSlope3 > 0.05){
         if( (SMA3- PrevSMA3) < 0){
            Ticket3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket3 = "TRUE";      
            OrderDirection3 = "SELL"; 
            OrderPrice3 = Bid;
         } 
      }        
   }
   
   
   if(OpenTicket3 == "TRUE"){
      //CloseBUY
      if(OrderDirection3 == "BUY"){
         if( (SMA3 - PrevSMA3) < 0){  //(SMA - PrevSMA) < 0 
            CloseOrder3 = OrderClose(Ticket3,LotSize,Bid,3,NULL);
            OpenTicket3 = "FALSE"; 
         }
      }
      
      //CloseSELL
      if(OrderDirection3 == "SELL"){
         if( (SMA3 - PrevSMA3) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder3 = OrderClose(Ticket3,LotSize,Ask,3,NULL);
            OpenTicket3 = "FALSE"; 
         }
      }         
   }