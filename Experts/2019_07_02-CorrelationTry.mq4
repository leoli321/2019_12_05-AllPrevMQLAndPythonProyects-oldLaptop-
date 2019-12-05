//+------------------------------------------------------------------+
//|                                    2019_07_02-CorrelationTry.mq4 |
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

int BarTimeFrame = 240;
double extern lot_size = .1;
double LotSizeArray[3];

bool OpenOrderArray[2];
bool CloseOrderArray[2];

string SymbolNameArray[3];

double SymbolCorrelationArray[3];

double AskOrBidPrice;

int DeclaringArrays = 1;
int currentBars;
bool TradeDirection;

double SymbolsAsks[3];
double SymbolBids[3];

void OnTick()
  {
   
   if(DeclaringArrays == 1){
      SymbolCorrelationArray[0] = 1;
      SymbolCorrelationArray[1] = 0.7;
      SymbolCorrelationArray[2] = 0.2;
      LotSizeArray[0] =lot_size;
      LotSizeArray[1] =.5*lot_size;
      LotSizeArray[2] = 1.8*lot_size;
      SymbolNameArray[0] = "GBPJPY";
      SymbolNameArray[1] = "GBPUSD";
      SymbolNameArray[2] = "USDJPY";
   
      DeclaringArrays = 0;
      }
   
   if(iBars(Symbol(),BarTimeFrame) > currentBars){

      if(OrdersTotal() < 3){
      
         for(int i = 0; i < ArraySize(OpenOrderArray);i++){ 
         
         
            if(SymbolCorrelationArray[i] > 0){
               TradeDirection = OP_SELL; AskOrBidPrice = MarketInfo(SymbolNameArray[i],MODE_BID);
            } else {TradeDirection = OP_BUY; AskOrBidPrice = MarketInfo(SymbolNameArray[i],MODE_ASK);}
            
            
            OpenOrderArray[i] = OrderSend(SymbolNameArray[i],TradeDirection,LotSizeArray[i],AskOrBidPrice,3,NULL,NULL);
         
         
         }
       
      }
   }
   
   
   currentBars = iBars(Symbol(),BarTimeFrame);
   
  }
//+------------------------------------------------------------------+
