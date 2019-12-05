//+------------------------------------------------------------------+
//|                                                   SetLotSize.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------

double SetLotSize(){

static double LastAccountBalance;

if (LastAccountBalance > AccountBalance()){
   
   if (LotSize == 0.01) 
   LotSize = 0.02;
   
   else if (LotSize == 0.02) 
   LotSize = 0.03;
   
   else if (LotSize == 0.03) 
   LotSize = 0.05; 
   
   else if (LotSize == 0.05) 
   LotSize = 0.08; 
   
   else if (LotSize == 0.08) 
   LotSize = 0.13; 
   
   else if (LotSize == 0.13) 
   LotSize = 0.19; 
   
   else if (LotSize == 0.19) 
   LotSize = 0.27; 
   
   else if (LotSize == 0.27) 
   LotSize = 0.50; 
   
   
}

if (LastAccountBalance < AccountBalance()) { LotSize = 0.01; }

LastAccountBalance = AccountBalance();

return LotSize;

}