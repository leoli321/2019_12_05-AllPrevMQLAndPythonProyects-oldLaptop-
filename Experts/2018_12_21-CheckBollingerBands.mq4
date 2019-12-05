//+------------------------------------------------------------------+
//|                               2018_12_21-CheckBollingerBands.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "2018_12_21-BootCampModuleCloseOrders.mq4"
#include "GetOpenTradesThisPairBootcamp.mq4"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void CheckBollingerBandTrade(){
   int BollingerPeriod = 20;
   double BollingerDeviation = 2;


   double LowerBB=iBands(NULL,BolTimeFrame,BollingerPeriod,BollingerDeviation,0,0,MODE_LOWER,1);
   double UpperBB=iBands(NULL,BolTimeFrame,BollingerPeriod,BollingerDeviation,0,0,MODE_UPPER,1);
   
   double PrevLowerBB=iBands(NULL,BolTimeFrame,BollingerPeriod,BollingerDeviation,0,0,MODE_LOWER,5);
   double PrevUpperBB=iBands(NULL,BolTimeFrame,BollingerPeriod,BollingerDeviation,0,0,MODE_UPPER,5);
   
   
   if((Low[1]>LowerBB)&&(Low[2]<PrevLowerBB)){
      if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int buyticket = OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,(Ask*TakeProfitLong),NULL,0,0,Green);
      }
   }

   if((High[1]<UpperBB)&&(High[2]>PrevUpperBB)){
      if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int sellticket = OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,(Bid*TakeProfitShort),NULL,0,0,Red);
         }
   }

}

#include "2018_12_21-BootCampModuleCloseOrders.mq4"
extern int MaxLoss = 200; 
extern double TakeProfitShort = 0.99;
extern double TakeProfitLong = 1.01;
extern int BolTimeFrame = 60;
#include "CheckForNewCandle.mq4"

void OnTick()
  {
  
  Comment("OpenOrderThisPair: "+GetOpenTradesThisPairBootCamp(Symbol()));
  
   if(NewCandleOnChart()==true){
      CheckBollingerBandTrade();
   }
   
   if(AccountEquity() < (AccountBalance()-MaxLoss)){
      CloseAllOrdersThisPair();
   }
  }
//+------------------------------------------------------------------+
