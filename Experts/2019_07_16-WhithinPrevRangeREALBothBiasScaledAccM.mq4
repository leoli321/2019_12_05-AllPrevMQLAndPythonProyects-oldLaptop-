//+------------------------------------------------------------------+
//|                            2019_07_12-WhitinPrevCandleRanges.mq4 |
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

///La idea es que tomes una semana? Un periodod de tiempo de 4hCandles, y si 
///Luego se rompe el rango compras o vendes en la direccion que se haya roto
//(Tambien puedes hacer lo contrario y apostar en la direccion contraria.



void OnTick()
  {

   
  }
//+------------------------------------------------------------------+
