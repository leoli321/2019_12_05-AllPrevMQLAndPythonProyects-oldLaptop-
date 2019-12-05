//+------------------------------------------------------------------+
//|                                     2019_01_21-TripleMATrade.mq4 |
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


int Ticket1;
int CloseOrder1;
int Ticket2;
int CloseOrder2;
int Ticket3;
int CloseOrder3;

string OpenTicket1 = "FALSE";
string OrderDirection1 = "NULL";
string OpenTicket2 = "FALSE";
string OrderDirection2 = "NULL";
string OpenTicket3 = "FALSE";
string OrderDirection3 = "NULL";

double OrderPrice1;
double OrderPrice2;
double OrderPrice3;

double StopOrder1;
double StopOrder2;
double StopOrder3;

extern double LotSize = .01;
string SMACrossOrder = "NULL";
extern int SMAPeriod1 = 2;
extern int SMAPeriod2 = 20;
extern int SMAPeriod3 = 50;
void OnTick()
  {
//---

   double PrevSMA1 = iMA(Symbol(),1440,SMAPeriod1,0,MODE_SMA,PRICE_CLOSE,2);
   double SMA1 = iMA(Symbol(),1440,SMAPeriod1,0,MODE_SMA,PRICE_CLOSE,1);
   
   double PrevSMA2 = iMA(Symbol(),1440,SMAPeriod2,0,MODE_SMA,PRICE_CLOSE,2);
   double SMA2 = iMA(Symbol(),1440,SMAPeriod2,0,MODE_SMA,PRICE_CLOSE,1);

   double PrevSMA3 = iMA(Symbol(),1440,SMAPeriod3,0,MODE_SMA,PRICE_CLOSE,2);
   double SMA3 = iMA(Symbol(),1440,SMAPeriod3,0,MODE_SMA,PRICE_CLOSE,1);
   
   double NormalizedSlope1 = (MathAbs(SMA1 - PrevSMA1)/SMA1) * 100;
   double NormalizedSlope2 = (MathAbs(SMA2 - PrevSMA2)/SMA2) * 100;
   double NormalizedSlope3 = (MathAbs(SMA3 - PrevSMA3)/SMA3) * 100;
   
   /// SMA1
   //////////////////////////////////////////////////////////
   if(OpenTicket1 == "FALSE"){
      //BUY
      if(NormalizedSlope1 > 0.05){
            if( (SMA1- PrevSMA1) > 0){
               Ticket1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,(Ask-Bid)*5,NULL,NULL,NULL,NULL,NULL);
               OpenTicket1 = "TRUE";      
               OrderDirection1 = "BUY"; 
               OrderPrice1 = Ask;
            } 
      }  
      //SELL
      if(NormalizedSlope1 > 0.05){
            if( (SMA1- PrevSMA1) < 0){
               Ticket1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,(Ask-Bid)*5,NULL,NULL,NULL,NULL,NULL);
               OpenTicket1 = "TRUE";      
               OrderDirection1 = "SELL"; 
               OrderPrice1 = Bid;
            }         
      }
   }
   
   
   if(OpenTicket1 == "TRUE"){
      //CloseBUY
      if(OrderDirection1 == "BUY"){
         if( (SMA1 - PrevSMA1) < 0){  //(SMA - PrevSMA) < 0 
            CloseOrder1 = OrderClose(Ticket1,LotSize,Bid,3,NULL);
            OpenTicket1 = "FALSE"; 
         }
         //StopLossOnceWeGotProfit.

      }
      
      //CloseSELL
      if(OrderDirection1 == "SELL"){
         if( (SMA1 - PrevSMA1) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder1 = OrderClose(Ticket1,LotSize,Ask,3,NULL);
            OpenTicket1 = "FALSE"; 
         }
         if(   (Ask - (Ask - Bid)* 2) < OrderPrice1 ) {  StopOrder1 = OrderPrice1 - (Ask - Bid); }
         if(   (Ask > (StopOrder1)) && (Ask < OrderPrice1)  ){
            CloseOrder1 = OrderClose(Ticket1,LotSize,Bid,3,NULL); 
            OpenTicket1 = "FALSE";  
            
         }         
      }         
   }
   
   ///SMA2
   //////////////////////////////////////////////////////////////////////
   if(OpenTicket2 == "FALSE"){
      //BUY
      if(NormalizedSlope2 > 0.05){
         if( (SMA2- PrevSMA2) > 0){
            Ticket2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,(Ask-Bid)*7,NULL,NULL,NULL,NULL,NULL);
            OpenTicket2 = "TRUE";      
            OrderDirection2 = "BUY"; 
            OrderPrice2 = Ask;
         } 
      }  
      //SELL
      if(NormalizedSlope2 > 0.05){
         if( (SMA2- PrevSMA2) < 0){
            Ticket2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,(Ask-Bid)*7,NULL,NULL,NULL,NULL,NULL);
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
         if(   (Bid + (Ask - Bid)* 5) > OrderPrice2 ) {  StopOrder2 = OrderPrice2 + (Ask - Bid)*2; } //Aqui cambie el multiplo de ask y bid
         if(   (Bid < (StopOrder2)) && (Bid > OrderPrice2)  ){
            CloseOrder2 = OrderClose(Ticket2,LotSize,Bid,3,NULL);   
            
         }         
      }
      
      //CloseSELL
      if(OrderDirection2 == "SELL"){
         if( (SMA2 - PrevSMA2) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder2 = OrderClose(Ticket2,LotSize,Ask,3,NULL);
            OpenTicket2 = "FALSE"; 
         }
         if(   (Ask - (Ask - Bid)* 5) < OrderPrice2 ) {  StopOrder2 = OrderPrice2 - (Ask - Bid)*2; } //Aqui cambie el multiplo de ask y bid
         if(   (Ask > (StopOrder2)) && (Ask < OrderPrice2)  ){
            CloseOrder2 = OrderClose(Ticket2,LotSize,Bid,3,NULL);   
         }          
      }         
   }
   
   ///SMA3
   /////////////////////////////////////////////////////////////////   
   if(OpenTicket3 == "FALSE"){
      //BUY
      if(NormalizedSlope3 > 0.05){
         if( (SMA3- PrevSMA3) > 0){
            Ticket3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,(Ask-Bid)*10,NULL,NULL,NULL,NULL,NULL);
            OpenTicket3 = "TRUE";      
            OrderDirection3 = "BUY"; 
            OrderPrice3 = Ask;
         } 
      }  
      //SELL
      if(NormalizedSlope3 > 0.05){
         if( (SMA3- PrevSMA3) < 0){
            Ticket3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,(Ask-Bid)*10,NULL,NULL,NULL,NULL,NULL);
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
         if(   (Bid + (Ask - Bid)* 10) > OrderPrice3 ) {  StopOrder3 = OrderPrice3 + (Ask - Bid)*4; } //Aqui cambie el multiplo de ask y bid
         if(   (Bid < (StopOrder3)) && (Bid > OrderPrice3)  ){
            CloseOrder3 = OrderClose(Ticket3,LotSize,Bid,3,NULL);   
            
         }          
      }
      
      //CloseSELL
      if(OrderDirection3 == "SELL"){
         if( (SMA3 - PrevSMA3) > 0 ){   //if( (SMA - PrevSMA) > 0 )
            CloseOrder3 = OrderClose(Ticket3,LotSize,Ask,3,NULL);
            OpenTicket3 = "FALSE"; 
         }
         
         if(   (Ask - (Ask - Bid)* 10) < OrderPrice3 ) {  StopOrder3 = OrderPrice3 - (Ask - Bid)*4; } //Aqui cambie el multiplo de ask y bid
         if(   (Ask > (StopOrder3)) && (Ask < OrderPrice3)  ){
            CloseOrder3 = OrderClose(Ticket3,LotSize,Bid,3,NULL);   
         }          
      }         
   }   
      
   
  }
//+------------------------------------------------------------------+
