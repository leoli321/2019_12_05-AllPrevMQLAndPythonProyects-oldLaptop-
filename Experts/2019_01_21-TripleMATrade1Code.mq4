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

   if(OpenTicket1 == "FALSE"){
      //BUY
         if( (SMA1- PrevSMA1) > 0){
            Ticket1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket1 = "TRUE";      
            OrderDirection1 = "BUY"; 
            OrderPrice1 = Ask;
         }   
      //SELL
         if( (SMA1- PrevSMA1) < 0){
            Ticket1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicket1 = "TRUE";      
            OrderDirection1 = "SELL"; 
            OrderPrice1 = Bid;
         }         
   }
   
   
   if(OpenTicket1 == "TRUE"){
      //CloseBUY
      if(OrderDirection1 == "BUY"){
         if( (SMA1 - PrevSMA1) < 0){  //(SMA - PrevSMA) < 0 
            CloseOrder1 = OrderClose(Ticket1,LotSize,Bid,3,NULL);
            OpenTicket1 = "FALSE"; 
         }
      }
      
      //CloseSELL
      if(OrderDirection1 == "SELL"){
         if( (SMA1 - PrevSMA1) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder1 = OrderClose(Ticket1,LotSize,Ask,3,NULL);
            OpenTicket1 = "FALSE"; 
         }
      }         
   }
   
