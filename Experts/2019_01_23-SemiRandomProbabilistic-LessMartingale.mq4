//+------------------------------------------------------------------+
//|                    2019_01_22-SemiRandomProbabilistic-Remake.mq4 |
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

double extern SMAFastModifier = 5;
double extern MACDModifier = 15;
double extern SMAMidModifier = 10;
double extern SMALongModifier = 20;
double extern StochasticModifier = 10;

double SMAFastMod;
double MACDMod;
double SMAMidMod;
double SMALongMod;
double StochasticMod;

double extern LotSize = .01;
double extern EquityTarget = 15;
double extern MaxEquityLoss = -200;
double OrderPrice;


double SMAForTrade;
int TradeSMAPeriod = 60;
double SMAForTradePrev;
int TicketSMATrend;
string SMATradeDirection;
int CloseOrderSMA;
double SMAOrderProfit;

void OnTick()
  {
   
   
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
   
   if (  (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == true)  ){
   
      SelectTicketMain1 = OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES);
      MainOrderProfit1 = OrderProfit() + OrderCommission() + OrderSwap();
      MainProfit = MainOrderProfit1 + MainOrderProfit2 + MainOrderProfit3;  


      if( (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         Random_number = ModifiedRandNumber();
         if(Random_number > 50){ TicketMain2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL); OrderDirectionMain2 = "BUY"; }
         if(Random_number < 50){ TicketMain2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);OrderDirectionMain2 = "SELL"; } 
      }
      
      if( (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         Random_number = ModifiedRandNumber();
         if(Random_number > 50){ TicketMain3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);OrderDirectionMain3 = "BUY"; }
         if(Random_number < 50){ TicketMain3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);OrderDirectionMain3 = "SELL"; } 
      }      
      
      
      
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit2 = OrderProfit() + OrderCommission() + OrderSwap();   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit3 = OrderProfit() + OrderCommission() + OrderSwap();   }                  

      
      
      MainProfit = MainOrderProfit1 + MainOrderProfit2 + MainOrderProfit3;   
            
      if ( MainProfit  > EquityTarget){
         Print("Main Profit; ", MainProfit);
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}                 
      }  
      
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
      
      //MAXACCOUNTLOSS
      if ( MainProfit  < MaxEquityLoss ){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}                 
      }  
      
      //MAXINDIVIDUALLOSS  
      if (MainOrderProfit1 < EquityTarget*2){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
                  
      }
      
      if (MainOrderProfit2 < EquityTarget*2){
         if( OrderDirectionMain2 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain2 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
          
      }    
           
      
      if (MainOrderProfit3 < EquityTarget*2){
         if( OrderDirectionMain3 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain3 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}
      }                   
    
   }
   
   Comment("StochasticMOD; ", StochasticMod);
      
   
  }
//+------------------------------------------------------------------+
