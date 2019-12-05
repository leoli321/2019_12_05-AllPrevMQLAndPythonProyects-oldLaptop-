//+------------------------------------------------------------------+
//|                                  2019_01_05-SMAHighIndicator.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot SMAHigh
#property indicator_label1  "SMAHigh"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         SMAHighBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SMAHighBuffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int uncalculatedBar = rates_total - prev_calculated;
   
  // for(int i = 0; i < uncalculatedBar; i++){
    //  SMAHighBuffer[i] = 
  // }
   
      for(int i = 0; i < uncalculatedBar; i++){
      
      double highPrice = iHigh(NULL,NULL,i);
      
      SMAHighBuffer[i] = highPrice;
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
