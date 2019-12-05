//+------------------------------------------------------------------+
//|                         2019_01_25-DoubleSameCandleSendOrder.mq4 |
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




int LastTradeBars;
double LotSize = .03;

int Ticket1;
int Ticket2;
int Ticket3;

double Ticket1Profit;
double Ticket2Profit;
double Ticket3Profit;

double MaxTicket1Profit;
double MaxTicket2Profit;
double MaxTicket3Profit;

int Ticket1OrderDirection;
int Ticket2OrderDirection;
int Ticket3OrderDirection;

double Ticket1ClosePrice;
double Ticket2ClosePrice;
double Ticket3ClosePrice;

double TrailingProfit = 40;
double ProfitTarget = 60;

int CloseTicket1;
int CloseTicket2;
int CloseTicket3;

void OnTick()
  {
   
   //TICKET1
   //BUY 
   if ( (iClose(Symbol(),10080,2) < iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket1,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket1 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }
   
   //SELL
   if ( (iClose(Symbol(),10080,2) > iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket1,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket1 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }   
   
   //TICKET2
   //BUY
   if ( (iClose(Symbol(),10080,2) < iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket2,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }
   
   //SELL
   if ( (iClose(Symbol(),10080,2) > iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket2,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }   
   
   //Ticket3
   //BUY
   if ( (iClose(Symbol(),10080,2) < iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket3,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket3 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }
   
   //SELL
   if ( (iClose(Symbol(),10080,2) > iClose(Symbol(),10080,1)) && (iBars(Symbol(),10080) > LastTradeBars) && ( OrderSelect(Ticket3,SELECT_BY_TICKET,MODE_TRADES) == false )) {
      Ticket3 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
      LastTradeBars = iBars(Symbol(),10080);
   }    
   
   
   //CLOSE WITH TRAILINGS.
   if (  OrderSelect(Ticket1,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket1Profit = OrderProfit() ; }
   if (  OrderSelect(Ticket2,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket2Profit = OrderProfit() ; }
   if (  OrderSelect(Ticket3,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket3Profit = OrderProfit() ; }
   
   if (Ticket1Profit > MaxTicket1Profit) {  MaxTicket1Profit = Ticket1Profit; }
   if (Ticket2Profit > MaxTicket2Profit) {  MaxTicket2Profit = Ticket2Profit; }
   if (Ticket3Profit > MaxTicket3Profit) {  MaxTicket3Profit = Ticket3Profit; }
   
   if (  OrderSelect(Ticket1,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket1OrderDirection = OrderType(); }
   if (  OrderSelect(Ticket2,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket2OrderDirection = OrderType(); }
   if (  OrderSelect(Ticket3,SELECT_BY_TICKET,MODE_TRADES) == true   ){ Ticket3OrderDirection = OrderType(); }
   
   if(Ticket1OrderDirection == OP_BUY) { Ticket1ClosePrice = Bid;  } 
   if(Ticket1OrderDirection == OP_SELL){ Ticket1ClosePrice = Ask; }
   if(Ticket2OrderDirection == OP_BUY) { Ticket2ClosePrice = Bid;  } 
   if(Ticket2OrderDirection == OP_SELL){ Ticket2ClosePrice = Ask; }
   if(Ticket3OrderDirection == OP_BUY) { Ticket3ClosePrice = Bid;  } 
   if(Ticket3OrderDirection == OP_SELL){ Ticket3ClosePrice = Ask; }
   
   if( (MaxTicket1Profit - TrailingProfit) > Ticket1Profit) {  
      CloseTicket1 = OrderClose(Ticket1,LotSize,Ticket1ClosePrice,3,NULL);
      Ticket1 = NULL;
      MaxTicket1Profit = 0;
   }
   
   if( (MaxTicket2Profit - TrailingProfit) > Ticket2Profit) {  
      CloseTicket2 = OrderClose(Ticket2,LotSize,Ticket2ClosePrice,3,NULL);
      Ticket2 = NULL;
      MaxTicket2Profit = 0;
   }
   
   if( (MaxTicket3Profit - TrailingProfit) > Ticket3Profit) {  
      CloseTicket3 = OrderClose(Ticket3,LotSize,Ticket3ClosePrice,3,NULL);
      Ticket3 = NULL;
      MaxTicket3Profit = 0;
   }
   
   //ProfitTarget.
    if(Ticket1Profit > ProfitTarget){
         CloseTicket1 = OrderClose(Ticket1,LotSize,Ticket1ClosePrice,3,NULL);
         Ticket1 = NULL;
         MaxTicket1Profit = 0;
    }
    
    if(Ticket2Profit > ProfitTarget){
         CloseTicket2 = OrderClose(Ticket2,LotSize,Ticket1ClosePrice,3,NULL);
         Ticket2 = NULL;
         MaxTicket2Profit = 0;
    }
    
    if(Ticket3Profit > ProfitTarget){
         CloseTicket3 = OrderClose(Ticket3,LotSize,Ticket1ClosePrice,3,NULL);
         Ticket3 = NULL;
         MaxTicket3Profit = 0;
    }     
    
    
       
   
   Comment(MaxTicket1Profit, "\n", MaxTicket2Profit, "\n", MaxTicket3Profit);
         
  }
//+------------------------------------------------------------------+
