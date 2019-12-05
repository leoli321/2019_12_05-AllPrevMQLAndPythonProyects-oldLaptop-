//+------------------------------------------------------------------+
//|                          2019_01_08-RandomEntryForComparison.mq4 |
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
extern double Stp = 1.03;
extern double TProfit = 1.01;
extern double LotSize = .1;
int sellticket;
//string WaitForNewBar = "";
void OnTick()
  {

   //if(WaitForNewBar == "TRUE"){
      
   //}
   
   BuyOrSell = MathRand()%2;
   if(OrdersTotal() < 1){
      if(BuyOrSell == 0){
         sellticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);
         WaitForNewBar == "TRUE";         
      }
      
      if(BuyOrSell == 1){
         sellticket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL);    
         WaitForNewBar == "TRUE";        
      }
   }
  }
//+------------------------------------------------------------------+
