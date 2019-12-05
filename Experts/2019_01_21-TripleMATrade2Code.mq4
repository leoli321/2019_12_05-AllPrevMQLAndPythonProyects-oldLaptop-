//+------------------------------------------------------------------+
//|                                2019_01_21-TripleMATrade1Code.mq4 |
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

   if(OpenTicket2 == "FALSE"){
      //BUY
      if(NormalizedSlope2 > 0.05){
         if( (SMA2- PrevSMA2) > 0){
            Ticket2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket2 = "TRUE";      
            OrderDirection2 = "BUY"; 
            OrderPrice2 = Ask;
         } 
      }  
      //SELL
      if(NormalizedSlope2 > 0.05){
         if( (SMA2- PrevSMA2) < 0){
            Ticket2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket2 = "TRUE";      
            OrderDirection2 = "SELL"; 
            OrderPrice2 = Bid;
         } 
      }        
   }
   
   
   if(OpenTicket2 == "TRUE"){
      //CloseBUY
      if(OrderDirection2 == "BUY"){
         if( (SMA2 - PrevSMA2) < 0){  //(SMA - PrevSMA) < 0 
            CloseOrder2 = OrderClose(Ticket2,LotSize,Bid,3,NULL);
            OpenTicket2 = "FALSE"; 
         }
      }
      
      //CloseSELL
      if(OrderDirection2 == "SELL"){
         if( (SMA2 - PrevSMA2) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder2 = OrderClose(Ticket2,LotSize,Ask,3,NULL);
            OpenTicket2 = "FALSE"; 
         }
      }         
   }