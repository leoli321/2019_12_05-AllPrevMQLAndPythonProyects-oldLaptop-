//+------------------------------------------------------------------+
//|                             2019_01_08-EAFourhighResistances.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int LineTimeFrame = 1440;
double FirstHigh;
double SecondHigh;
double ThirdHigh;
double FourthHigh;
double SoldPrice1;
double SoldPrice2;
double SoldPrice3;
double SoldPrice4;
int DigitRound = 3;
int sellticket1;
int sellticket2;
int sellticket3;
int sellticket4;
double LotSize = 0.01;
double open_T1 = 0;
double open_T2 = 0;
double open_T3 = 0;
double open_T4 = 0;
int loopcount = 0;


void OnTick()
  {
//---
   int HighShift1 = iHighest(NULL,LineTimeFrame,NULL,20,0);
   int HighShift2 = iHighest(NULL,LineTimeFrame,NULL,40,21);
   int HighShift3 = iHighest(NULL,LineTimeFrame,NULL,60,41);
   int HighShift4 = iHighest(NULL,LineTimeFrame,NULL,80,61);
   
   FirstHigh = iHigh(NULL,LineTimeFrame,HighShift1);
   SecondHigh = iHigh(NULL,LineTimeFrame,HighShift2);
   ThirdHigh = iHigh(NULL,LineTimeFrame,HighShift3);
   FourthHigh = iHigh(NULL,LineTimeFrame,HighShift4);
   
   Comment("First: ", FirstHigh,"\n",
   " Sec: ", SecondHigh,"\n", " third: ", ThirdHigh,"\n", " Fourth: ", FourthHigh);
   

      //first
      if (open_T1 == 0){
         if(NormalizeDouble(Bid, DigitRound) == NormalizeDouble(FirstHigh,DigitRound)){ 
            if(Bid > FirstHigh){
               if(iClose(NULL,LineTimeFrame,1) < iClose(NULL,LineTimeFrame,0)){
                  sellticket1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,NULL,NULL,0,0,Red);
                  SoldPrice1 = Bid;
                  open_T1 = Bid;
                  loopcount = loopcount + 1;
                  Print("LoopCount: ", loopcount);
                  
               }
            }
          }
       }
       
      
      //if(SoldPrice1 > 0){ Print("openT1 : ",open_T1); } 
      
      //SECOND
      if(open_T2 < 1){
         if(NormalizeDouble(Bid, DigitRound) == NormalizeDouble(SecondHigh,DigitRound)){ 
            if(Bid > SecondHigh){
               if(iClose(NULL,LineTimeFrame,1) < iClose(NULL,LineTimeFrame,0)){
                  sellticket2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,NULL,NULL,0,0,Red);
                  SoldPrice2 = Bid;
                  open_T2 = 1;
               }
            }
          }
      }
     //Third 
     if(open_T3 < 1){
         if(NormalizeDouble(Bid, DigitRound) == NormalizeDouble(ThirdHigh,DigitRound)){ 
            if(Bid > ThirdHigh){
               if(iClose(NULL,LineTimeFrame,1) < iClose(NULL,LineTimeFrame,0)){
                  sellticket3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,NULL,NULL,0,0,Red);
                  SoldPrice3 = Bid;
                  open_T3 = 1;
               }
            }
          }
      }
      //Fourth 
      if(open_T4 < 1){
         if(NormalizeDouble(Bid, DigitRound) == NormalizeDouble(FourthHigh,DigitRound)){ 
            if(Bid > FourthHigh){
               if(iClose(NULL,LineTimeFrame,1) < iClose(NULL,LineTimeFrame,0)){
                  sellticket4 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
                  SoldPrice4 = Bid;
                  open_T4 = 1;
               }
            }
          }  
      }
    bool OrdersResult;
    //Close 1.
    if(open_T1 == 1){
      if((SoldPrice1 - 0.03) > Ask ){
        OrdersResult = OrderClose(sellticket1,LotSize,Ask,3,clrGreen);    
      }
      
      if((SoldPrice1 + 0.1) < Ask ){
        OrdersResult = OrderClose(sellticket1,LotSize,Ask,3,clrGreen);    
      }
      
      if(NormalizeDouble(SoldPrice2,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket1,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice3,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket1,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice4,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket1,LotSize,Ask,3,clrGreen); 
      }            
      
      open_T1 = 0;
      
    }

    //Close 2.
    if(open_T2 == 1){
      if((SoldPrice2 - 0.03) > Ask ){
        OrdersResult = OrderClose(sellticket2,LotSize,Ask,3,clrGreen);    
      }
      
      if((SoldPrice2 + 0.1) < Ask ){
        OrdersResult = OrderClose(sellticket2,LotSize,Ask,3,clrGreen);    
      }
      
      if(NormalizeDouble(SoldPrice1,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket2,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice3,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket2,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice4,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket2,LotSize,Ask,3,clrGreen); 
      }            
      
      open_T2 = 0;
      
    }    
    
    //Close 3.
    if(open_T3 == 1){
      if((SoldPrice3 - 0.03) > Ask ){
        OrdersResult = OrderClose(sellticket3,LotSize,Ask,3,clrGreen);    
      }
      
      if((SoldPrice3 + 0.1) < Ask ){
        OrdersResult = OrderClose(sellticket3,LotSize,Ask,3,clrGreen);    
      }
      
      if(NormalizeDouble(SoldPrice1,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket3,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice2,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket3,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice4,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket3,LotSize,Ask,3,clrGreen); 
      }            
      
      open_T3 = 0;
      
    }        

    //Close 4.
    if(open_T4 == 1){
      if((SoldPrice4 - 0.03) > Ask ){
        OrdersResult = OrderClose(sellticket4,LotSize,Ask,3,clrGreen);    
      }
      
      if((SoldPrice4 + 0.1) < Ask ){
        OrdersResult = OrderClose(sellticket4,LotSize,Ask,3,clrGreen);    
      }
      
      if(NormalizeDouble(SoldPrice1,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket4,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice2,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket4,LotSize,Ask,3,clrGreen); 
      }
      
      if(NormalizeDouble(SoldPrice3,DigitRound) == NormalizeDouble(Ask,DigitRound)){
         OrdersResult = OrderClose(sellticket4,LotSize,Ask,3,clrGreen); 
      }            
      
      open_T4 = 0;
      
    }    
  }
//+------------------------------------------------------------------+
