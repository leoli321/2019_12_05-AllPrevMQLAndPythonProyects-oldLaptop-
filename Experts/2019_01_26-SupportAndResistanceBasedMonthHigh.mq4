//+------------------------------------------------------------------+
//|                2019_01_26-SupportAndResistanceBasedMonthHigh.mq4 |
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
//#include "2019_01_26-GetRangeMaxCloseArray.mq4"

double CloseArray[52]; //Semanas hacia atras
int SmallArraySize = 4; //Cantidad de semanas a buscar 
double CloseArray_1[4];
double Max;
/////////////////////
double MaxInArray(int a){

    for(int i = 0; i < 52; i++){
      CloseArray[i] = iClose(Symbol(),10080,1+i);
    }
    
    for(int i = a; i < a+4; i++){
      CloseArray_1[i-a] = CloseArray[i];
      ArraySort(CloseArray_1,WHOLE_ARRAY,0,MODE_DESCEND);
      Max = CloseArray_1[0];
    }
    
    return(Max);
}

//////////////////

double BarLength;
double AverageBarLenght;
int LastTradeBars;

int Ticket_1;
int Ticket_1_Close;
int LastBars;
int Ticket_1_SELL;
int Ticket_1_SELL_Close;
int LastTradeBars_SELL;
double Ticket_1_SELL_LossPrice;
double Ticket_1_SELL_ProfitPrice;
double LotSize = .1;
double Ticket_1_LossPrice;
double Ticket_1_ProfitPrice;
double MaxArray[14];
/*
    int a = 0;
    for(int i = 0; i < 52; i++){
      CloseArray[i] = iClose(Symbol(),10080,1+i);
    }
    
*/

void OnTick()
  {
    if(LastBars < iBars(Symbol(),10080) ){
      for (int i = 1; i < 52; i++){
         BarLength = ( MathAbs(iClose(Symbol(),1440,i) - (iOpen(Symbol(),1440,i))) );
         AverageBarLenght = (BarLength + AverageBarLenght)/i;
      }
      
      
      for(int i = 1; i < 13; i++){ //Build Max array;
         MaxArray[i] = MaxInArray(i*4);   
      }
      
      ArraySort(MaxArray,WHOLE_ARRAY,0,MODE_DESCEND);
      
      for (int i = 0; i < 12; i++){
         if( (MaxArray[i] - AverageBarLenght) < MaxArray[i+1]  ){
            MaxArray[i] = ( MaxArray[i] +  MaxArray[i+1] )/2;
         }
      }
         
         
      for(int i = 0; i < 12; i++){
         if(   (iClose(Symbol(),10080,1) > MaxArray[i]) && (iOpen(Symbol(),10080,1) < MaxArray[i]) && (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == false)    ){ 
            Ticket_1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);  
            LastTradeBars = iBars(Symbol(),10080);
            if(i > 1){ 
               if(MaxArray[i-1] > (MaxArray[i] + AverageBarLenght) ){
                  Ticket_1_ProfitPrice = MaxArray[i-1];
                  Ticket_1_LossPrice = MaxArray[i+2];
               }
            if(i < 2){ 
               if(MaxArray[i] > (MaxArray[i+1] + AverageBarLenght) ){
                  Ticket_1_ProfitPrice = MaxArray[i]+AverageBarLenght*4;
                  Ticket_1_LossPrice = MaxArray[i+2];
               }  
               }          
            }
         }
         
         if(   (iClose(Symbol(),10080,1) < MaxArray[i]) && (iOpen(Symbol(),10080,1) > MaxArray[i]) && (OrderSelect(Ticket_1_SELL,SELECT_BY_TICKET,MODE_TRADES) == false)    ){ 
            Ticket_1_SELL = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);  
            LastTradeBars_SELL = iBars(Symbol(),10080);
            if(i > 1){ 
               if(MaxArray[i-1] > (MaxArray[i] + AverageBarLenght) ){
                  Ticket_1_SELL_ProfitPrice = MaxArray[i+1];
                  Ticket_1_SELL_LossPrice = MaxArray[i-2];
               }
            if(i < 2){ 
               if(MaxArray[i] > (MaxArray[i+1] + AverageBarLenght) ){
                  Ticket_1_SELL_ProfitPrice = MaxArray[i]-AverageBarLenght*4;
                  Ticket_1_SELL_LossPrice = MaxArray[i-2];
               }  
               }          
            }
         }         
      }
      
      if (  (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true) && (iClose(Symbol(),10080,1) > Ticket_1_ProfitPrice) && (iBars(Symbol(),10080) > LastTradeBars)  ){ 
           Ticket_1_Close =  OrderClose(Ticket_1,LotSize,Bid,3,NULL);
           Ticket_1 = NULL;
           Ticket_1_ProfitPrice = NULL;
           Ticket_1_LossPrice = NULL;        
        }
        
      if (  (OrderSelect(Ticket_1,SELECT_BY_TICKET,MODE_TRADES) == true) && (iClose(Symbol(),10080,1) < Ticket_1_LossPrice) && (iBars(Symbol(),10080) > LastTradeBars) ){ 
           Ticket_1_Close =  OrderClose(Ticket_1,LotSize,Bid,3,NULL);
           Ticket_1 = NULL;
           Ticket_1_ProfitPrice = NULL;
           Ticket_1_LossPrice = NULL;
        }     
        
      if (  (OrderSelect(Ticket_1_SELL,SELECT_BY_TICKET,MODE_TRADES) == true) && (iClose(Symbol(),10080,1) < Ticket_1_SELL_ProfitPrice) && (iBars(Symbol(),10080) > LastTradeBars_SELL)  ){ 
           Ticket_1_SELL_Close =  OrderClose(Ticket_1_SELL,LotSize,Ask,3,NULL);
           Ticket_1_SELL = NULL;
           Ticket_1_SELL_ProfitPrice = NULL;
           Ticket_1_SELL_LossPrice = NULL;        
        }
        
      if (  (OrderSelect(Ticket_1_SELL,SELECT_BY_TICKET,MODE_TRADES) == true) && (iClose(Symbol(),10080,1) > Ticket_1_SELL_LossPrice) && (iBars(Symbol(),10080) > LastTradeBars_SELL) ){ 
           Ticket_1_SELL_Close =  OrderClose(Ticket_1_SELL,LotSize,Ask,3,NULL);
           Ticket_1_SELL = NULL;
           Ticket_1_SELL_ProfitPrice = NULL;
           Ticket_1_SELL_LossPrice = NULL;
        }           
           
    }  
    
    LastBars = iBars(Symbol(),10080);
    Comment("Line1: ", MaxArray[0], "\n",
            "Line2: ", MaxArray[1], "\n",
            "Line3: ", MaxArray[2], "\n",
            "Line4: ", MaxArray[3], "\n",
            "Line5: ", MaxArray[4], "\n",
            "Line6: ", MaxArray[5], "\n",
            "Line7: ", MaxArray[6], "\n",
            "Line8: ", MaxArray[7], "\n",
            "Line9: ", MaxArray[8], "\n",
            "Line10: ", MaxArray[9], "\n",
            "Line11: ", MaxArray[10], "\n",
            "Line12: ", MaxArray[11], "\n",
            "Take profit: ", Ticket_1_ProfitPrice, "\n",
            "Take loss: ", Ticket_1_LossPrice, "\n");
    
  }
//+------------------------------------------------------------------+
