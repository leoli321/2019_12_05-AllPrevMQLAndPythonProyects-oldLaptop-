//+------------------------------------------------------------------+
//|                         2019_02_16-CandlestickPatternTrading.mq4 |
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
#include "2019_02_10-CandleStickPatterns.mq4"

int HourBars;
bool BullishCandlePattern = false;
bool BearishCandlePattern = false;
int BullOrderArray[100];
int BearOrderArray[100];
double BullOrderProfitArray[100];
double BearOrderProfitArray[100];
int BullOrderNum = 0;
int BearOrderNum = 0;
int FirstTick = 0;

/*
bool IsHammer = Hammer(60);
bool IsInvertedHammer = InvertedHammer(60);
bool IsBullishEngulfing = BullishEngulfing(60);
bool IsBearishEngulfing = BearishEngulfing(60);
bool IsBullishPiercingLine = BullishPiercingLine(60);
bool IsBearishPiercingLine = BearishPiercingLine(60);
bool IsBullishMorningStar = BullishMorningStar(60);
bool IsBearishMorningStar = BearishMorningStar(60);
bool IsThreeWhiteSoldiers = ThreeWhiteSoldiers(60);
bool IsThreeBlackCrows = ThreeBlackCrows(60);
*/

double Lot_Size = .03;

double StopLossLocksIndex[10];
double StopLossLocksValue[10];
double StopLock;

int BarTimeFrame = 10080;
int Start = 0;

int StopLockNumber = 0;
int StopLockValueNumber = 0;

void OnTick()
  {
   
     if(Start == 0){
         StopLossLocksIndex[0] = 30;
         StopLossLocksIndex[1] = 60;
         StopLossLocksIndex[2] = 90;
         StopLossLocksIndex[3] = 120;
         StopLossLocksIndex[4] = 150;
         StopLossLocksIndex[5] = 180;
         StopLossLocksIndex[6] = 210;
         StopLossLocksIndex[7] = 240;
         
         StopLossLocksValue[0] = -30;
         StopLossLocksValue[1] = 10;
         StopLossLocksValue[2] = 30;
         StopLossLocksValue[3] = 60;
         StopLossLocksValue[4] = 90;
         StopLossLocksValue[5] = 110;
         StopLossLocksValue[6] = 130;
         StopLossLocksValue[7] = 150;
         
         Start = 1;
         }
   
   
   if(   iBars(Symbol(),BarTimeFrame) > HourBars   ){
      bool IsHammer = Hammer(BarTimeFrame);
      bool IsInvertedHammer = InvertedHammer(BarTimeFrame);
      bool IsBullishEngulfing = BullishEngulfing(BarTimeFrame);
      bool IsBearishEngulfing = BearishEngulfing(BarTimeFrame);
      bool IsBullishPiercingLine = BullishPiercingLine(BarTimeFrame);
      bool IsBearishPiercingLine = BearishPiercingLine(BarTimeFrame);
      bool IsBullishMorningStar = BullishMorningStar(BarTimeFrame);
      bool IsBearishMorningStar = BearishMorningStar(BarTimeFrame);
      bool IsThreeWhiteSoldiers = ThreeWhiteSoldiers(BarTimeFrame);
      bool IsThreeBlackCrows = ThreeBlackCrows(BarTimeFrame);
      
      
      if(   (IsBullishEngulfing == true) || (IsHammer == true) || (IsThreeWhiteSoldiers == true) || (IsBullishPiercingLine == true) ||
      (IsBullishMorningStar == true) ){
         BullOrderArray[BullOrderNum] = OrderSend(Symbol(),OP_BUY,Lot_Size,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
         BullOrderNum = BullOrderNum + 1;
         
         /*
         for(int i = 0; i < BearOrderNum; i++){
            int BearOrderClose = OrderClose(BearOrderArray[i],Lot_Size,Ask,3,NULL);
         }        
         BearOrderNum = 0;
         */         
         Print(AccountProfit());
      }
      
      if(   (IsBearishEngulfing == true) || (IsInvertedHammer == true) || (IsThreeBlackCrows == true) || (IsBearishPiercingLine == true) ||
      (IsBearishMorningStar == true) ){
         BearOrderArray[BearOrderNum] = OrderSend(Symbol(),OP_SELL,Lot_Size,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         BearOrderNum = BearOrderNum + 1;
         
         /*
         for(int i = 0; i < BullOrderNum; i++){
            int BullOrderClose = OrderClose(BullOrderArray[i],Lot_Size,Bid,3,NULL);
         }
         
         BullOrderNum = 0;
         */
         Print(AccountProfit());
      }            
      
   
   }
   
   /*
      if(AccountProfit() > 30){
         
         for(int i = 0; i < BullOrderNum; i++){
            int BullOrderClose = OrderClose(BullOrderArray[i],Lot_Size,Bid,3,NULL);
         }
         BullOrderNum = 0;
         
         for(int i = 0; i < BearOrderNum; i++){
            int BearOrderClose = OrderClose(BearOrderArray[i],Lot_Size,Ask,3,NULL);
         }        
         BearOrderNum = 0;
      }   
      
*/
        for(int i = 0; i < BullOrderNum; i++){
               if (  OrderSelect(BullOrderArray[i],SELECT_BY_TICKET,MODE_TRADES) == true   ){
                  BullOrderProfitArray[i] = (OrderProfit() + OrderSwap());
               }
            }
            
        for(int i = 0; i < BearOrderNum; i++){
               if (  OrderSelect(BearOrderArray[i],SELECT_BY_TICKET,MODE_TRADES) == true   ){
                  BearOrderProfitArray[i] = (OrderProfit() + OrderSwap());
               }
            }     
         
      
      if(AccountProfit() > StopLossLocksIndex[StopLockNumber]) {
         StopLockNumber = StopLockNumber + 1;
         StopLockValueNumber = StopLockValueNumber + 1;
      }
      
         if(AccountProfit() < StopLossLocksValue[StopLockValueNumber]){
            for(int i = 0; i < BullOrderNum; i++){
               int BullOrderClose = OrderClose(BullOrderArray[i],Lot_Size,Bid,3,NULL);
            }
            BullOrderNum = 0;
            
            for(int i = 0; i < BearOrderNum; i++){
               int BearOrderClose = OrderClose(BearOrderArray[i],Lot_Size,Ask,3,NULL);
            }        
            BearOrderNum = 0;
            
                   StopLockNumber = 0;
                   StopLockValueNumber = 0;
         }
         
      
         
   
   HourBars = iBars(Symbol(),BarTimeFrame);
   Comment("Stop Loss: ", StopLossLocksValue[StopLockValueNumber], "\n",
   "AccountProfit: ", AccountProfit());
   
  }
//+------------------------------------------------------------------+
