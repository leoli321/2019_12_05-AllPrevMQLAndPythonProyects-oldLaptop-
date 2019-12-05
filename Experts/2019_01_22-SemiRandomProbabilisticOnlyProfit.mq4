//+------------------------------------------------------------------+
//|                 2019_01_22-SemiRandomProbabilisticOnlyProfit.mq4 |
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

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

int SMATimeFrame = 1440;
int FastSMAPeriod = 5;
int MidSMAPeriod = 20;

int TicketFast1;
int CloseOrderFast1;
string OpenTicketFast1 = "FALSE";
string OrderDirectionFast1;
double OrderPriceFast1;
string StopPlacedFast = "FALSE";

int TicketFast2;
int CloseOrderFast2;
string OpenTicketFast2 = "FALSE";
string OrderDirectionFast2;
double OrderPriceFast2;

int TicketFast3;
int CloseOrderFast3;
string OpenTicketFast3 = "FALSE";
string OrderDirectionFast3;
double OrderPriceFast3;

double StopFast;
int FastBarsStop;

double Random_number;
double MACD;
double MACDPrev;
double SMAFast;
double SMAMid;

double extern SMAFastModifier = 20;
double extern MACDModifier = 35;
double extern SMAMidModifier = 25;
double SMAFastMod;
double MACDMod;
double SMAMidMod;
double extern LotSize = .01;
double extern EquityTarget = 15;

int TicketSMATrend; 
string SMATradeSwitch = "OFF";
double SMAForTrade;
double SMAForTradePrev;
int TradeSMAPeriod = 10;
string SMATradeDirection;
int CloseOrderSMA;
string SMAOrderOpen = "FALSE";

int SelectTicketFast1;
int SelectTicketFast2;
int SelectTicketFast3;
double MainOrderProfit1;
double MainOrderProfit2;
double MainOrderProfit3;
double MainProfit;


void OnTick()
  {
   
   SelectTicketFast1 = OrderSelect(TicketFast1,SELECT_BY_TICKET,MODE_TRADES);
   MainOrderProfit1 = OrderProfit();
   SelectTicketFast2 = OrderSelect(TicketFast2,SELECT_BY_TICKET,MODE_TRADES);
   MainOrderProfit2 = OrderProfit();
   SelectTicketFast3 = OrderSelect(TicketFast3,SELECT_BY_TICKET,MODE_TRADES);
   MainOrderProfit3 = OrderProfit();
   MainProfit = MainOrderProfit1 + MainOrderProfit2 + MainOrderProfit3;
   
   if(OpenTicketFast1 == "FALSE"){
   
      Random_number = MathRand()%100;
      SMAFast = iMA(Symbol(),SMATimeFrame,FastSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
      SMAMid = iMA(Symbol(),SMATimeFrame,MidSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
      MACD = iMACD(Symbol(),SMATimeFrame,12,16,9,PRICE_CLOSE,MODE_MAIN,1);
      MACDPrev = iMACD(Symbol(),SMATimeFrame,12,16,9,PRICE_CLOSE,MODE_MAIN,2);
      
      
      if(iClose(Symbol(),SMATimeFrame,1) < SMAFast){Random_number = Random_number + SMAFastModifier; SMAFastMod = +SMAFastModifier;}
      if(iClose(Symbol(),SMATimeFrame,1) > SMAFast){Random_number = Random_number - SMAFastModifier; SMAFastMod = -SMAFastModifier;}
      if(MACD > MACDPrev){ Random_number = Random_number + MACDModifier; MACDMod = +MACDModifier; }
      if(MACD < MACDPrev){ Random_number = Random_number - MACDModifier; MACDMod = -MACDModifier; }
      if(iClose(Symbol(),SMATimeFrame,1) < SMAMid){Random_number = Random_number + SMAMidModifier; SMAMidMod = +SMAMidModifier;}
      if(iClose(Symbol(),SMATimeFrame,1) > SMAMid){Random_number = Random_number - SMAMidModifier; SMAMidMod = -SMAMidModifier;}
      
      
      if(Random_number > 50){ 
         TicketFast1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OpenTicketFast1 = "TRUE";      
         OrderDirectionFast1 = "BUY";      
      }
      if(Random_number < 50){ 
         TicketFast1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OpenTicketFast1 = "TRUE";      
         OrderDirectionFast1 = "SELL";       
      }      
      
   }
   
   if(OpenTicketFast1 == "TRUE"){
      Print("OpenTicketFast1 = TRUE");
      //Agregar a posicion
      if(   (MainOrderProfit1 < -50)  && (OpenTicketFast2 == "FALSE" ) ){
         Print("OpenTicketFast2 = FALSE");
         if(Random_number > 50){ 
            TicketFast2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicketFast2 = "TRUE";      
            OrderDirectionFast2 = "BUY";        
         }
         if(Random_number < 50){ 
            TicketFast2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicketFast2 = "TRUE";      
            OrderDirectionFast2 = "SELL";        
         }           
         
      }
      if(   (MainOrderProfit1 < -100)  && (OpenTicketFast3 == "FALSE" ) ){
         Print("OpenTicketFast3 = FALSE");
         if(Random_number > 50){ 
            TicketFast3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicketFast3 = "TRUE";      
            OrderDirectionFast3 = "BUY"; 
            OrderPriceFast3 = Ask;        
            SMATradeSwitch = "ON";  
         }
         if(Random_number < 50){ 
            TicketFast3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            OpenTicketFast3 = "TRUE";      
            OrderDirectionFast3 = "SELL"; 
            OrderPriceFast3 = Bid;
            SMATradeSwitch = "ON";         
         }           
         
      }      
      
      //Stop si ya hay profit


      if( (MainProfit > EquityTarget) && (OrderDirectionFast1 == "BUY") ){
         CloseOrderFast1 = OrderClose(TicketFast1,LotSize,Bid,3,NULL);
         CloseOrderFast2 = OrderClose(TicketFast2,LotSize,Bid,3,NULL);
         CloseOrderFast3 = OrderClose(TicketFast3,LotSize,Bid,3,NULL);
         OpenTicketFast1 = "FALSE";
         OpenTicketFast2 = "FALSE";
         OpenTicketFast3 = "FALSE";
         SMATradeSwitch = "OFF";
      } 

      if( (MainProfit > (EquityTarget)) && (OrderDirectionFast1 == "SELL") ){
         CloseOrderFast1 = OrderClose(TicketFast1,LotSize,Ask,3,NULL);
         CloseOrderFast2 = OrderClose(TicketFast2,LotSize,Ask,3,NULL);
         CloseOrderFast3 = OrderClose(TicketFast3,LotSize,Ask,3,NULL);
         OpenTicketFast1 = "FALSE";
         OpenTicketFast2 = "FALSE";
         OpenTicketFast3 = "FALSE";
         SMATradeSwitch = "OFF";
      }       
   
   }
   
      //Trade Si hay trend esto es experimental /////////////////////////////////////////////////////////////
      if (  SMATradeSwitch == "ON"){
         SMAForTrade = iMA(Symbol(),SMATimeFrame,TradeSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
         SMAForTradePrev = iMA(Symbol(),SMATimeFrame,TradeSMAPeriod,0,MODE_SMA,PRICE_CLOSE,2);
         
         if(SMAOrderOpen == "FALSE"){
            if(   (SMAForTrade - SMAForTradePrev) > 0 ){ 
               TicketSMATrend = OrderSend(Symbol(),OP_BUY,LotSize*3,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               SMATradeDirection = "BUY";
               SMAOrderOpen = "TRUE";
             }
            if(   (SMAForTrade - SMAForTradePrev) < 0 ){ 
               TicketSMATrend = OrderSend(Symbol(),OP_SELL,LotSize*3,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               SMATradeDirection = "SELL";
               SMAOrderOpen = "TRUE";
             }
         }
         
         if( (SMATradeDirection == "BUY") && ((SMAForTrade - SMAForTradePrev) < 0)    ){  CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Bid,3,NULL);  SMAOrderOpen = "FALSE";  }
         if( (SMATradeDirection == "SELL") && ((SMAForTrade - SMAForTradePrev) > 0)    ){  CloseOrderSMA = OrderClose(TicketSMATrend,LotSize*3,Ask,3,NULL);  SMAOrderOpen = "FALSE";  }
         
      }     
      //Trade Si hay trend esto es experimental /////////////////////////////////////////////////////////////
   
   Comment ("MainProfit: ", MainProfit, "\n", "Equity: ", AccountEquity(),
   "\n", "MathRand: ", Random_number, "\n",
   "MACDMod: ", MACDMod,"\n", "FASTSMAMod: ", SMAFastMod, "\n", "MidSMAMod: ", SMAMidMod) ;
   
  }
//+------------------------------------------------------------------+
