//+------------------------------------------------------------------+
//|                    2019_09_07-CombiningEverythingToGetThat51.mq4 |
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
int OrderSelectArray[3000];
int CloseAllOrders()
{
  int total = OrdersTotal();
  for(int n=total-1;n>=0;n--)
  {
    OrderSelectArray[n] = OrderSelect(n, SELECT_BY_POS);
    int type   = OrderType();

    bool result = false;
    
    switch(type)
    {
      //Close opened long positions
      case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                          break;
      
      //Close opened short positions
      case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                          
    }
    
    if(result == false)
    {
      Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      Sleep(3000);
    }  
  }
  
  return(0);
}
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

double extern lot_size = .01;
int OpenOrder[3000];
int x;
int currentBars;
int BarTimeFrame = 1440;

double month1High;
double month1Low;

double iAC3;
double iAC2;
double iAC1;
double iAO2;
double iAO1;

int iACDir;
int iAODir;
int iACOn = 0;
int iAOOn = 0;
int tradeCount = 0;
int winCount = 0;
int iACDay = 0;
int iAODay = 0;

double currentLot_size = lot_size;
double TP;
double extern LotTPRatio = 1000;
int extern SMAPeriod = 26;
double SMA;
void OnTick()
  {
//---
      if(currentBars < iBars(Symbol(),BarTimeFrame)){
         
         SMA = iMA(Symbol(),10080,SMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
         TP = currentLot_size*LotTPRatio;
      
      
         month1High = iHigh(Symbol(),43200,1);
         month1Low = iLow(Symbol(),43200,1);
         
         iAC3 = NormalizeDouble(iAC(Symbol(),1440,3),6);
         iAC2 = NormalizeDouble(iAC(Symbol(),1440,2),6);
         iAC1 = NormalizeDouble(iAC(Symbol(),1440,1),6);
         
         iAO2 = NormalizeDouble(iAO(Symbol(),1440,2),6);
         iAO1 = NormalizeDouble(iAO(Symbol(),1440,1),6);
         
         if( MathAbs(iAC2) > MathAbs(iAC3) && MathAbs(iAC2) > MathAbs(iAC1)){
            iACOn = 1;
            iACDay = 0;
            Print("AC ONNN");
            if(iAC2 > 0){
               iACDir = 0;
            }else {iACDir = 1;}
         }else{
            if(iACDay > 2){
               iACOn = 0;
            }
            Print("iACDay: ", iACDay);
            iACDay += 1;
         }
         
         if(iAO2 < 0 && iAO1 > 0){
            Print("AO ONNN");
            iAOOn = 1;
            iAODir = 1;
            iAODay = 0;
         } else if(iAO2 > 0 && iAO1 < 0){
            Print("AO ONNN ");
            iAODay = 0;
            iAOOn = 1;
            iAODir = 0;
         }else{
            if(iAODay > 2){
               iAOOn = 0;
            }
            Print("iAODay: ", iAODay);
            iAODay +=1;
         }
      
      
      } //End of currentBars
      
      if(OrdersTotal() == 0){
         
         if(iAOOn == 1 && iACOn == 1){
            if(iAODir == iACDir){
               
               if(iAODir == 0){
                  if(Bid > SMA){
                     OpenOrder[x] = OrderSend(Symbol(),OP_SELL,currentLot_size,Bid,3,NULL,NULL,NULL,NULL,NULL);
                     x +=1;
                  }
               } else{
                  if(Ask < SMA){
                     OpenOrder[x] = OrderSend(Symbol(),OP_BUY,currentLot_size,Ask,3,NULL,NULL,NULL,NULL,NULL);
                     x +=1;
                  }
               }
            
            }
         
         }
      
      
      } //End of OrdersTotal == 0
      
      if(AccountProfit() > TP){
         CloseAllOrders();
         winCount += 1;
         tradeCount += 1;
         iACOn = 0;
         iAOOn = 0;
      }
      
      if(AccountProfit() < -TP){
         CloseAllOrders();
         tradeCount += 1;         
         iACOn = 0;
         iAOOn = 0;
      }
      
      currentBars = iBars(Symbol(),BarTimeFrame);
   
   
   Comment("iAC1,2,3: ", iAC1," ", iAC2, " ", iAC3, " iACOn: ",iACOn, " iACDir: ",iACDir, "\n",
   "iAO1,2: ", iAO1," ", iAO2, " iAOOn: ", iAOOn, " iAODir: ",iAODir 
   
   );
    
   
   
  }
//+------------------------------------------------------------------+
