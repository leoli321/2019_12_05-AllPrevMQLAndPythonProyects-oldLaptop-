//+------------------------------------------------------------------+
//|                                            SimpleRandomTrade.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "2018_12_21-BootCampModuleCloseOrders.mq4"
#include "GetOpenTradesThisPairBootcamp.mq4"
#include "CheckForNewCandle.mq4"
#include "CreateRandomTrade.mq4"
#include "GetProfitThisCurrency.mq4"
#include "CheckPriceRange.mq4"
#include "SetLotSize.mq4"

string PriceIsInRange = "none";

extern int MaxLoss = 250;
extern double TakeProfitShort = 0.99;
extern double TakeProfitLong = 1.01;
double LotSize = 0.01;

void CheckRandomTrade(){

   if (CalculateRandomNumber()==0){
       if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int buyticket = OrderSend(Symbol(),OP_BUY,SetLotSize(),Ask,3,0,(Ask*TakeProfitLong),NULL,0,0,Green);
      }
   }


   if (CalculateRandomNumber()==1){
      if (GetOpenTradesThisPairBootCamp(Symbol())<10){
         int sellticket = OrderSend(Symbol(),OP_SELL,SetLotSize(),Bid,3,0,(Bid*TakeProfitShort),NULL,0,0,Red);
      }
   }
}


void OnTick()
  {
  
  CheckPriceRange();
   Comment("Price is in range: ",PriceIsInRange, "\n",
   "Profit in this currency pair: ", getProfitThisCurrency(Symbol()),"\n",
      "OpenOrderThisPair: "+GetOpenTradesThisPairBootCamp(Symbol()));
   
   if (NewCandleOnChart()==true){
      CheckRandomTrade();
      }
    
   if(AccountEquity() < (AccountBalance()-MaxLoss)){
      CloseAllOrdersThisPair();
   }
   
  }
//+------------------------------------------------------------------+
