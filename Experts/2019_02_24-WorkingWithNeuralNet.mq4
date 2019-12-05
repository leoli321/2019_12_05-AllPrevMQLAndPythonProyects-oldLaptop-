//+------------------------------------------------------------------+
//|                              2019_02_24-WorkingWithNeuralNet.mq4 |
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


double InputArray[13];
double WeightsArray[13];
double SumArray[13];
double ArraySum = 0;
double ResultsArray[13];

int OrderArray[100];
int OrderCloseInt;

int OnInit()
  {

      WeightsArray[0] = .818;
      WeightsArray[1] = 0.057;
      WeightsArray[2] = 0.996;
      WeightsArray[3] = 0.83;
      WeightsArray[4] = 0.177;
      WeightsArray[5] = 0.196;
      WeightsArray[6] = 0.423;
      WeightsArray[7] = 0.415;
      WeightsArray[8] = 0.322;
      WeightsArray[9] = 0.207;
      WeightsArray[10] = 0.049;
      WeightsArray[11] = 0.83;
      
      
      SumArray[0] = -.269;
      SumArray[1] = -.62;
      SumArray[2] = -1.44;
      SumArray[3] = -.367;
      SumArray[4] = 1.63;
      SumArray[5] = -.84;
      SumArray[6] = -.396;
      SumArray[7] = -0.06;
      SumArray[8] = -0.414;
      SumArray[9] = -1.87;
      SumArray[10] = 1.386;
      SumArray[11] = .418;

      
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

int Timeframe = 1440;
int OrderNum = 0;
double LotSize = .01;
int CurrentBars;
double OrderCloseAskOrBid;
void OnTick()
  {
  
  if(   iBars(Symbol(),Timeframe) > CurrentBars   ){
      
      if (  OrderSelect(OrderArray[OrderNum],SELECT_BY_TICKET,MODE_TRADES) == true ){
            if (OrderType() == OP_BUY){ OrderCloseAskOrBid = Bid;   }
            if (OrderType() == OP_SELL){ OrderCloseAskOrBid = Ask;   }
            
            OrderCloseInt = OrderClose(OrderArray[OrderNum],LotSize,OrderCloseAskOrBid,3,NULL);
            OrderNum = OrderNum + 1;
      }
      
      InputArray[0] = iOpen(Symbol(),Timeframe,3);
      InputArray[1] = iHigh(Symbol(),Timeframe,3);
      InputArray[2] = iLow(Symbol(),Timeframe,3);
      InputArray[3] = iClose(Symbol(),Timeframe,3);
      InputArray[4] = iOpen(Symbol(),Timeframe,2);
      InputArray[5] = iHigh(Symbol(),Timeframe,2);
      InputArray[6] = iLow(Symbol(),Timeframe,2);
      InputArray[7] = iClose(Symbol(),Timeframe,2);
      InputArray[8] = iOpen(Symbol(),Timeframe,1);
      InputArray[9] = iHigh(Symbol(),Timeframe,1);
      InputArray[10] = iLow(Symbol(),Timeframe,1);
      InputArray[11] = iClose(Symbol(),Timeframe,1);   
      
      //Normalize
      double Max = ArrayMaximum(InputArray);
      double Min = ArrayMinimum(InputArray);
      double Slope = (.9-.1)/(Max-Min);
      double Intercept = .9 - (Max*Slope);
      for(int i = 0; i < ArraySize(InputArray); i++){
         InputArray[i] = InputArray[i]*Slope + +Intercept;
      }
      
      ArraySum = 0;
      for(int i = 0; i < 13; i++){
         ResultsArray[i] = MathPow(InputArray[i], WeightsArray[i]) * SumArray[i];
         ArraySum = ArraySum + ResultsArray[i];
      }
      ArraySum = ArraySum / 6;
      double SigmoidX =  1/(1+exp(-ArraySum));
      
      if(ArraySum <= .5){
         OrderArray[OrderNum] = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
        
      }
      if(ArraySum > .5){
         OrderArray[OrderNum] = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      }      
         
      
      }
      
    CurrentBars = iBars(Symbol(),Timeframe);
    
    Comment(ResultsArray[0]);
   
  }
//+------------------------------------------------------------------+
