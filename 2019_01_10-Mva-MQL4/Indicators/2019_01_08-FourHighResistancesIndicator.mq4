//+------------------------------------------------------------------+
//|                      2019_01_08-FourHighResistancesIndicator.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot High1
#property indicator_label1  "High1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot High2
#property indicator_label2  "High2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrOrangeRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot High3
#property indicator_label3  "High3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot High4
#property indicator_label4  "High4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrGold
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- indicator buffers
double         High1Buffer[];
double         High2Buffer[];
double         High3Buffer[];
double         High4Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,High1Buffer);
   SetIndexBuffer(1,High2Buffer);
   SetIndexBuffer(2,High3Buffer);
   SetIndexBuffer(3,High4Buffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int LineTimeFrame = 1440;
double FirstHigh;
double SecondHigh;
double ThirdHigh;
double FourthHigh;

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
   
   int HighShift1 = iHighest(NULL,LineTimeFrame,NULL,20,0);
   int HighShift2 = iHighest(NULL,LineTimeFrame,NULL,40,20);
   int HighShift3 = iHighest(NULL,LineTimeFrame,NULL,60,40);
   int HighShift4 = iHighest(NULL,LineTimeFrame,NULL,80,60);
   
   FirstHigh = iHigh(NULL,LineTimeFrame,HighShift1);
   SecondHigh = iHigh(NULL,LineTimeFrame,HighShift2);
   ThirdHigh = iHigh(NULL,LineTimeFrame,HighShift3);
   FourthHigh = iHigh(NULL,LineTimeFrame,HighShift4);
   
   Comment(FirstHigh,"\n"," Sec: ", SecondHigh,"\n", " third: ", ThirdHigh,"\n", " Fourth: ", FourthHigh);
   
   for(int i = 0; i < uncalculatedBar; i++){
      High1Buffer[i] = FirstHigh;
      High2Buffer[i] = SecondHigh;
      High3Buffer[i] = ThirdHigh;
      High4Buffer[i] = FourthHigh;
   }
   
   

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
