//+------------------------------------------------------------------+
//|                             2019_01_26-GetRangeMaxCloseArray.mq4 |
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
double MaxInArray(int a){
    double CloseArray[52];
    int SmallArraySize = 4;
    double CloseArray_1[4];
    double Max;
    
    for(int i = 1; i < 52; i++){
      CloseArray[i] = iClose(Symbol(),10080,1+i);
    }
    
    for(int i = a; i < a+4; i++){
      CloseArray_1[i-a] = CloseArray[i];
      ArraySort(CloseArray_1,WHOLE_ARRAY,0,MODE_DESCEND);
      Max = CloseArray_1[0];
    }
    
    return(Max);
}
//+------------------------------------------------------------------+
