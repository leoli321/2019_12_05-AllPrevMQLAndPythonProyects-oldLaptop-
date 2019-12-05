//+------------------------------------------------------------------+
//|                           2019_01_06-SMAHighAverageIndicator.mq4 |
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
double ArraySum;
double ArrayHigh;
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
double SizeOfArray = 3;
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
   
   for(int i = 0; i < uncalculatedBar; i++){
      
      for(int n = i + 0; (n - i) < SizeOfArray; n++){
         ArrayHigh = iHigh(NULL,NULL,n);
         
         ArraySum = ArraySum + ArrayHigh;  
      }

      double ArrayAverage = ArraySum/SizeOfArray;
      
      SMAHighBuffer[i] = ArrayAverage; 
      
      ArraySum = 0;
   }
   
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
