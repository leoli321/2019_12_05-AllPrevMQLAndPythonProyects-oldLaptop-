//+------------------------------------------------------------------+
//|                           2019_01_23-ThreeDifferentConsensus.mq4 |
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

#include "2019_01_23-RandomNumberModified.mq4"

int TicketMain1;
int TicketMain2;
int TicketMain3;

int SelectTicketMain1;
int SelectTicketMain2;
int SelectTicketMain3;

double MainOrderProfit1;
double MainOrderProfit2;
double MainOrderProfit3;
double MainProfit;

string OpenTicketMain1 = "FALSE";
string OpenTicketMain2 = "FALSE";
string OpenTicketMain3 = "FALSE";

string OrderDirectionMain1;
string OrderDirectionMain2;
string OrderDirectionMain3;

double RandomSeed;
double Random_number;
double SMAFast;
double SMAMid;
double SMALong;
double MACD;
double MACDPrev;
double Stochastic;

int MidSMAPeriod = 20;
int SMATimeFrame = 1440;
int FastSMAPeriod = 5;
int LongSMAPeriod = 60;

int MainOrderClose1;
int MainOrderClose2;
int MainOrderClose3;

double extern SMAFastModifier = 3;
double extern MACDModifier = 10;
double extern SMAMidModifier = 8;
double extern SMALongModifier = 10;
double extern StochasticModifier = 8;
double extern BandsModifier = 6;
double extern ActualPositionModifier= 10;

double SMAFastMod;
double MACDMod;
double SMAMidMod;
double SMALongMod;
double StochasticMod;

double extern LotSize = .01;
double extern EquityTarget = 15;
double extern MaxEquityLoss = -200;
double extern MaxIndividualLoss = -80;

double OrderPrice;

double BandsUpper;
double BandsLower;


void OnTick()
  {
  //ORDER 1
   if(   (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == false)  ){
   
      Random_number = ModifiedRandNumber();
      
          
      if(Random_number > 50){ 
         TicketMain1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
         OrderDirectionMain1 = "BUY";      
         OrderPrice = Ask;
      }
      if(Random_number < 50){ 
         TicketMain1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OrderDirectionMain1 = "SELL";  
         OrderPrice = Bid;     
      }      
      
   }
   
   //ORDER 2
   if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == false)  ){
   
      Random_number = ModifiedRandNumber();
      
          
      if(Random_number > 50){ 
         TicketMain2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
         OrderDirectionMain2 = "BUY";      
         OrderPrice = Ask;
      }
      if(Random_number < 50){ 
         TicketMain2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OrderDirectionMain2 = "SELL";  
         OrderPrice = Bid;     
      }      
      
   }
   
   //ORDER 3
   if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == false)  ){
   
      Random_number = ModifiedRandNumber();
      
          
      if(Random_number > 50){ 
         TicketMain3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
         OrderDirectionMain3 = "BUY";      
         OrderPrice = Ask;
      }
      if(Random_number < 50){ 
         TicketMain3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OrderDirectionMain3 = "SELL";  
         OrderPrice = Bid;     
      }      
      
   }           
      if(   (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit1 = OrderProfit() + OrderCommission() + OrderSwap();   }
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit2 = OrderProfit() + OrderCommission() + OrderSwap();   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit3 = OrderProfit() + OrderCommission() + OrderSwap();   }                  

      if(   (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit1 = OrderProfit() + OrderCommission() ;   }
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit2 = OrderProfit() + OrderCommission() ;   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit3 = OrderProfit() + OrderCommission() ;   }                  

      
      MainProfit = MainOrderProfit1 + MainOrderProfit2 + MainOrderProfit3;     
   
      if (MainOrderProfit1 > EquityTarget){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
                  
      }
      
      if (MainOrderProfit2 > EquityTarget){
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
          
      }    

      if (MainOrderProfit3 > EquityTarget){
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}
      }          
      
      //STOPS
      if (MainOrderProfit1 < MaxIndividualLoss){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
                  
      }
      
      if (MainOrderProfit2 < MaxIndividualLoss){
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
          
      }    

      if (MainOrderProfit3 < MaxIndividualLoss){
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}
      }       
      
      if ( MainProfit  < MaxEquityLoss ){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}                 
      }        
   
  }
//+------------------------------------------------------------------+
