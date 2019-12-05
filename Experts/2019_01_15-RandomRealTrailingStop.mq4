//+------------------------------------------------------------------+
//|                                  2019_01_15-RealTrailingStop.mq4 |
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
int BuyOrSell = 0;
int Ticket;
int Ticket2;
int CloseOrder;
string OpenTicket = "FALSE";
string OrderDirection = "NULL";
int TickShift = 0;
extern double LotSize = .01;
double ClosePrice;
double TrailingPips = .01;
double HighestPrice;
double LowestPrice;


void OnTick()
  {
   TrailingPips = iHigh(NULL,1440,iHighest(NULL,1440,NULL,10,0)) - iLow(NULL,1440,iLowest(NULL,1440,NULL,10,0));
   
   BuyOrSell = MathRand()%2;
   
   if(OpenTicket == "FALSE"){
      
      if(BuyOrSell == 0){
         Ticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OpenTicket = "TRUE";      
         OrderDirection = "SELL"; 
         LowestPrice = Bid;
         ClosePrice = LowestPrice + (TrailingPips); 
         
         
      }
      
      if(BuyOrSell == 1){
         Ticket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
         OpenTicket = "TRUE";    
         OrderDirection = "BUY";    
         HighestPrice = Ask;
         ClosePrice = HighestPrice - (TrailingPips);
         
       }
   }
    
  
  if(OpenTicket == "TRUE"){
       //Sell
       if(OrderDirection == "SELL"){
         if(LowestPrice  > Ask){
            LowestPrice = Ask;
            ClosePrice = LowestPrice + (TrailingPips);
         }
         if(Ask > ClosePrice){
            CloseOrder = OrderClose(Ticket,LotSize,Ask,3,NULL);
            OpenTicket = "FALSE";
         }
             
       } 
       //Buy
       if(OrderDirection == "BUY"){
         if(HighestPrice < Bid){
            HighestPrice = Bid;
            ClosePrice = HighestPrice - (TrailingPips);
         }
         if(Bid < ClosePrice){
            CloseOrder = OrderClose(Ticket,LotSize,Bid,3,NULL);
            OpenTicket = "FALSE";
         }
         
       }
  
  }
  
  
  Comment("THE CLOSE PRICE IS: ", ClosePrice);
   
  }
//+------------------------------------------------------------------+
