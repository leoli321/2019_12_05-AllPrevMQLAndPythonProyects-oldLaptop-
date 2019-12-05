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
double Random_number;
double SMAFast;
double SMAMid;
double MACD;
double MACDPrev;

int MidSMAPeriod = 20;
int SMATimeFrame = 1440;
int FastSMAPeriod = 8;

int MainOrderClose1;
int MainOrderClose2;
int MainOrderClose3;

double extern SMAFastModifier = 20;
double extern MACDModifier = 35;
double extern SMAMidModifier = 25;
double SMAFastMod;
double MACDMod;
double SMAMidMod;
double extern LotSize = .01;
double extern EquityTarget = 15;
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
      
      //BUYS
      if(   (MainOrderProfit1 < -50) && (OrderDirectionMain1 == "BUY") && (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         TicketMain2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
      }
      
      if(   (MainOrderProfit1 < -100) && (OrderDirectionMain1 == "BUY") && (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         TicketMain3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
      }
      
      //SELLS 
      if(   (MainOrderProfit1 < -50) && (OrderDirectionMain1 == "SELL") && (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         TicketMain2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);    
      }
      
      if(   (MainOrderProfit1 < -100) && (OrderDirectionMain1 == "SELL") && (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == false)  ){ 
         TicketMain3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      }
      
      
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit2 = OrderProfit() + OrderCommission() + OrderSwap();   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true)){   MainOrderProfit3 = OrderProfit() + OrderCommission() + OrderSwap();   }                  

      
      
      MainProfit = MainOrderProfit1 + MainOrderProfit2 + MainOrderProfit3;   
            
      if ( MainProfit  > EquityTarget){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain1 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}                 
      }  
      
      if ( MainProfit  < -300 ){
         if( OrderDirectionMain1 == "BUY") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Bid,3,NULL); TicketMain1 = NULL; MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose1 =  OrderClose(TicketMain1,LotSize,Ask,3,NULL);TicketMain1 = NULL;  MainOrderProfit1 = NULL;}
         if( OrderDirectionMain1 == "BUY") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Bid,3,NULL);  TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose2 =  OrderClose(TicketMain2,LotSize,Ask,3,NULL); TicketMain2 = NULL; MainOrderProfit2 = NULL;}
         if( OrderDirectionMain1 == "BUY") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Bid,3,NULL); TicketMain3 = NULL;  MainOrderProfit3 = NULL;}
         if( OrderDirectionMain1 == "SELL") { MainOrderClose3 =  OrderClose(TicketMain3,LotSize,Ask,3,NULL); TicketMain3 = NULL; MainOrderProfit3 = NULL;}                 
      }           
    
   }
      
      //Trade Si hay trend esto es experimental /////////////////////////////////////////////////////////////
      if (  (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true) ){
         SMAForTrade = iMA(Symbol(),SMATimeFrame,TradeSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
         SMAForTradePrev = iMA(Symbol(),SMATimeFrame,TradeSMAPeriod,0,MODE_SMA,PRICE_CLOSE,2);
         
         if(   (OrderSelect(TicketSMATrend,SELECT_BY_TICKET,MODE_TRADES) == false)   ){
            if(   (SMAForTrade - SMAForTradePrev) > 0 ){ 
               TicketSMATrend = OrderSend(Symbol(),OP_BUY,LotSize*3,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               SMATradeDirection = "BUY"; 
             }
            if(   (SMAForTrade - SMAForTradePrev) < 0 ){ 
               TicketSMATrend = OrderSend(Symbol(),OP_SELL,LotSize*3,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               SMATradeDirection = "SELL";
             }
         }
         
         if( (SMATradeDirection == "BUY") && ((SMAForTrade - SMAForTradePrev) < 0)    ){  CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Bid,3,NULL);  TicketSMATrend  = NULL;  }
         if( (SMATradeDirection == "SELL") && ((SMAForTrade - SMAForTradePrev) > 0)    ){  CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Ask,3,NULL);  TicketSMATrend  = NULL;  }
         
         if( ((OrderSelect(TicketSMATrend,SELECT_BY_TICKET,MODE_TRADES) == true))     ){  
            SMAOrderProfit =  OrderProfit() + OrderSwap() + OrderCommission();
            if( (SMAOrderProfit < -300) && SMATradeDirection == "BUY"  ){ CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Bid,3,NULL);  TicketSMATrend  = NULL;  }
            if( (SMAOrderProfit < -300) && SMATradeDirection == "SELL"  ){ CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Ask,3,NULL);  TicketSMATrend  = NULL;  }
            }
      }     
      //Trade Si hay trend esto es experimental /////////////////////////////////////////////////////////////
      
   
  }
//+------------------------------------------------------------------+
