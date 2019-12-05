//+------------------------------------------------------------------+
//|                                        GetProfitThisCurrency.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

double getProfitThisCurrency (string pair){
double Profit =0;

for (int i=OrdersTotal()-1; i >= 0; i--)

   if (OrderSelect(i,SELECT_BY_POS)==true)
      if(OrderSymbol() == pair)
         Profit = (OrderProfit()+OrderSwap());

return (Profit);

}