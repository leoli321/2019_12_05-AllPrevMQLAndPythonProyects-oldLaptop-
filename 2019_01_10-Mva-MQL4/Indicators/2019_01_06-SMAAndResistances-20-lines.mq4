//+------------------------------------------------------------------+
//|                        2019_01_06-SMAAndResistances-20-lines.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 21
#property indicator_plots   21
//--- plot SMAHigh
#property indicator_label1  "SMAHigh"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDarkBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
#property indicator_label2  "Label2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Label3
#property indicator_label3  "Label3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrRosyBrown
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Label4
#property indicator_label4  "Label4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRoyalBlue
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot Label5
#property indicator_label5  "Label5"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrDarkGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot Label6
#property indicator_label6  "Label6"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrRed
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- plot Label7
#property indicator_label7  "Label7"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrDarkGoldenrod
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1
//--- plot Label8
#property indicator_label8  "Label8"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrDarkViolet
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- plot Label9
#property indicator_label9  "Label9"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrRed
#property indicator_style9  STYLE_SOLID
#property indicator_width9  1
//--- plot Label10
#property indicator_label10  "Label10"
#property indicator_type10   DRAW_LINE
#property indicator_color10  clrRed
#property indicator_style10  STYLE_SOLID
#property indicator_width10  1
//--- plot Label11
#property indicator_label11  "Label11"
#property indicator_type11   DRAW_LINE
#property indicator_color11  clrRed
#property indicator_style11  STYLE_SOLID
#property indicator_width11  1
//--- plot Label12
#property indicator_label12  "Label12"
#property indicator_type12   DRAW_LINE
#property indicator_color12  clrRed
#property indicator_style12  STYLE_SOLID
#property indicator_width12  1
//--- plot Label13
#property indicator_label13  "Label13"
#property indicator_type13   DRAW_LINE
#property indicator_color13  clrRed
#property indicator_style13  STYLE_SOLID
#property indicator_width13  1
//--- plot Label14
#property indicator_label14  "Label14"
#property indicator_type14   DRAW_LINE
#property indicator_color14  clrRed
#property indicator_style14  STYLE_SOLID
#property indicator_width14  1
//--- plot Label15
#property indicator_label15  "Label15"
#property indicator_type15   DRAW_LINE
#property indicator_color15  clrRed
#property indicator_style15  STYLE_SOLID
#property indicator_width15  1
//--- plot Label16
#property indicator_label16  "Label16"
#property indicator_type16   DRAW_LINE
#property indicator_color16  clrRed
#property indicator_style16  STYLE_SOLID
#property indicator_width16  1
//--- plot Label17
#property indicator_label17  "Label17"
#property indicator_type17   DRAW_LINE
#property indicator_color17  clrRed
#property indicator_style17  STYLE_SOLID
#property indicator_width17  1
//--- plot Label18
#property indicator_label18  "Label18"
#property indicator_type18   DRAW_LINE
#property indicator_color18  clrRed
#property indicator_style18  STYLE_SOLID
#property indicator_width18  1
//--- plot Label19
#property indicator_label19  "Label19"
#property indicator_type19   DRAW_LINE
#property indicator_color19  clrRed
#property indicator_style19  STYLE_SOLID
#property indicator_width19  1
//--- plot Label20
#property indicator_label20  "Label20"
#property indicator_type20   DRAW_LINE
#property indicator_color20  clrRed
#property indicator_style20  STYLE_SOLID
#property indicator_width20  1
//--- plot Label21
#property indicator_label21  "Label21"
#property indicator_type21   DRAW_LINE
#property indicator_color21  clrRed
#property indicator_style21  STYLE_SOLID
#property indicator_width21  1
//--- indicator buffers
double         SMAHighBuffer[];
double         Label2Buffer[];
double         Label3Buffer[];
double         Label4Buffer[];
double         Label5Buffer[];
double         Label6Buffer[];
double         Label7Buffer[];
double         Label8Buffer[];
double         Label9Buffer[];
double         Label10Buffer[];
double         Label11Buffer[];
double         Label12Buffer[];
double         Label13Buffer[];
double         Label14Buffer[];
double         Label15Buffer[];
double         Label16Buffer[];
double         Label17Buffer[];
double         Label18Buffer[];
double         Label19Buffer[];
double         Label20Buffer[];
double         Label21Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SMAHighBuffer);
   SetIndexBuffer(1,Label2Buffer);
   SetIndexBuffer(2,Label3Buffer);
   SetIndexBuffer(3,Label4Buffer);
   SetIndexBuffer(4,Label5Buffer);
   SetIndexBuffer(5,Label6Buffer);
   SetIndexBuffer(6,Label7Buffer);
   SetIndexBuffer(7,Label8Buffer);
   SetIndexBuffer(8,Label9Buffer);
   SetIndexBuffer(9,Label10Buffer);
   SetIndexBuffer(10,Label11Buffer);
   SetIndexBuffer(11,Label12Buffer);
   SetIndexBuffer(12,Label13Buffer);
   SetIndexBuffer(13,Label14Buffer);
   SetIndexBuffer(14,Label15Buffer);
   SetIndexBuffer(15,Label16Buffer);
   SetIndexBuffer(16,Label17Buffer);
   SetIndexBuffer(17,Label18Buffer);
   SetIndexBuffer(18,Label19Buffer);
   SetIndexBuffer(19,Label20Buffer);
   SetIndexBuffer(20,Label21Buffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+


double ArraySum;
double ArrayHigh;
double SizeOfArray = 3;

int Stp = 0;
int IfCount = 0;
int Set = 0;
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
   
   int ResistanceFrame = 20; 
   
   double LocalHigh0 = 0;
   double LocalHigh1 = 0;
   double LocalHigh2 = 0;
   double LocalHigh3 = 0;
   double LocalHigh4 = 0;
   double LocalHigh5 = 0;
   double LocalHigh6 = 0;
   double LocalHigh7 = 0;
     
   int LineMultiplier0 = 0;
   int LineMultiplier1 = 1;
   int LineMultiplier2 = 2;
   int LineMultiplier3 = 3;
   int LineMultiplier4 = 4;
   int LineMultiplier5 = 5;
   int LineMultiplier6 = 6;
   int LineMultiplier7 = 7;
   
   //line 0
   for(int q = ResistanceFrame * LineMultiplier0; q < ResistanceFrame + (ResistanceFrame * LineMultiplier0); q++){
      if(LocalHigh0 < SMAHighBuffer[q]){
         LocalHigh0 = SMAHighBuffer[q];
      }
   }
      
   // 1 line  CAMBIAR EL LineMultiplier'NUMERO' < ese num cambias. Y el LocalHigh'NUMERO'
   for(int q = ResistanceFrame * LineMultiplier1; q < ResistanceFrame + (ResistanceFrame * LineMultiplier1); q++){
      if(LocalHigh1 < SMAHighBuffer[q]){
         LocalHigh1 = SMAHighBuffer[q];
      }
   }

   // 2
   for(int q = ResistanceFrame * LineMultiplier2; q < ResistanceFrame + (ResistanceFrame * LineMultiplier2); q++){
      if(LocalHigh2 < SMAHighBuffer[q]){
         LocalHigh2 = SMAHighBuffer[q];
      }
   }

   // 3 line
   for(int q = ResistanceFrame * LineMultiplier3; q < ResistanceFrame + (ResistanceFrame * LineMultiplier3); q++){
      if(LocalHigh3 < SMAHighBuffer[q]){
         LocalHigh3 = SMAHighBuffer[q];
      }
   }      

   // 4 line
   for(int q = ResistanceFrame * LineMultiplier4; q < ResistanceFrame + (ResistanceFrame * LineMultiplier4); q++){
      if(LocalHigh4 < SMAHighBuffer[q]){
         LocalHigh4 = SMAHighBuffer[q];
      }
   }

   // 5 line
   for(int q = ResistanceFrame * LineMultiplier5; q < ResistanceFrame + (ResistanceFrame * LineMultiplier5); q++){
      if(LocalHigh5 < SMAHighBuffer[q]){
         LocalHigh5 = SMAHighBuffer[q];
      }
   }

   // 6 line
   for(int q = ResistanceFrame * LineMultiplier6; q < ResistanceFrame + (ResistanceFrame * LineMultiplier6); q++){
      if(LocalHigh6 < SMAHighBuffer[q]){
         LocalHigh6 = SMAHighBuffer[q];
      }
   }         

/*
   //line 0
   for(int w = 0; w < uncalculatedBar; w++){
      Label2Buffer[w] = LocalHigh0;
   }
   
   //line 1
   for(int w = 0; w < uncalculatedBar; w++){
      Label3Buffer[w] = LocalHigh1;
   }
      
   //line 2
   for(int w = 0; w < uncalculatedBar; w++){
      Label4Buffer[w] = LocalHigh2;
   }
*/  
   //line 3
   for(int w = 0; w < uncalculatedBar; w++){
      Label5Buffer[w] = LocalHigh3;
   }
  
   //line 4
   for(int w = 0; w < uncalculatedBar; w++){
      Label6Buffer[w] = LocalHigh4;
   }
      
   //line 5
   for(int w = 0; w < uncalculatedBar; w++){
    Label7Buffer[w] = LocalHigh5;
   }
   
   //line 6
   for(int w = 0; w < uncalculatedBar; w++){
      Label8Buffer[w] = LocalHigh6;
   }
   
   int VisibleBars = WindowBarsPerChart();
   
   //Comment(VisibleBars);
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
