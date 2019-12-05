//+------------------------------------------------------------------+
//|                        2019_01_09-RandomWithTrailingStopLoss.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
int BuyOrSell = 0;
extern double Stp = 1.03;
extern double TProfit = 1.01;
extern double LotSize = .01;
int Ticket;
int Ticket2;
int CloseOrder;
string OpenTicket = "FALSE";
double OrderPrice = 0;
string OrderDirection = "NULL";
string StopLoss = "NULL";
extern double MaxLoss = 1.07;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   BuyOrSell = MathRand()%2;
   if(OpenTicket == "FALSE"){
   
      Print("Enter Open Ticket = FALSE: ", OpenTicket, " Also MRand: ", BuyOrSell);
      
      if(BuyOrSell == 0){
         Ticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
         OpenTicket = "TRUE";      
         OrderPrice = Bid;  
         OrderDirection = "SELL"; 
         
         Print("Enter it sold. OT:", OpenTicket, " OP: ", OrderPrice, " OD: ", OrderDirection);
      }
      
      if(BuyOrSell == 1){
         Ticket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);    
         OpenTicket = "TRUE";    
         OrderPrice = Ask;
         OrderDirection = "BUY";    
         
         Print("Enter it Buy. OT:", OpenTicket, " OP: ", OrderPrice, " OD: ", OrderDirection);
      }
   }
   
   if(OpenTicket == "TRUE"){
      //SELL 
      if(OrderDirection == "SELL"){
         if(StopLoss == "NULL"){
            if( (OrderPrice * Stp) < Ask ){
               Ticket2 = OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               OrderPrice = Bid;
               StopLoss = "NEXT";
            }
            
            if( (OrderPrice/(TProfit*TProfit)) > Ask){
               CloseOrder = OrderClose(Ticket,LotSize,Ask,3,NULL);
               OpenTicket = "FALSE";
            }
        }
        
        if(StopLoss == "NEXT"){
            if((OrderPrice/(TProfit*TProfit)) > Ask){
              CloseOrder = OrderClose(Ticket,LotSize,Ask,3,NULL);
              CloseOrder = OrderClose(Ticket2,LotSize,Ask,3,NULL);   
              Print("Stop Loss: ", StopLoss);      
              StopLoss = "NULL";
              }
            if((OrderPrice * MaxLoss) < Ask ){
              CloseOrder = OrderClose(Ticket,LotSize,Ask,3,NULL);
              CloseOrder = OrderClose(Ticket2,LotSize,Ask,3,NULL);   
              Print("Stop Loss: ", StopLoss);      
              StopLoss = "NULL";
            }
        }
        
      }
      
      //BUY
      if(OrderDirection == "BUY"){
         if(StopLoss == "NULL"){
            if( (OrderPrice / Stp) > Bid ){
               Ticket2 = OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               OrderPrice = Ask;
               StopLoss = "NEXT";
            }
            
            if( (OrderPrice * (TProfit*TProfit)) < Bid){
               CloseOrder = OrderClose(Ticket,LotSize,Bid,3,NULL);
               OpenTicket = "FALSE";          
            }
         }
         
        if(StopLoss == "NEXT"){
            if((OrderPrice*(TProfit*TProfit)) < Bid){ //Close with profit
              CloseOrder = OrderClose(Ticket,LotSize,Bid,3,NULL);
              CloseOrder = OrderClose(Ticket2,LotSize,Bid,3,NULL);   
              Print("Stop Loss: ", StopLoss);      
              StopLoss = "NULL";
              Print("Stop Loss after: ", StopLoss);
              }
            if((OrderPrice / MaxLoss) > Ask ){
              CloseOrder = OrderClose(Ticket,LotSize,Ask,3,NULL);
              CloseOrder = OrderClose(Ticket2,LotSize,Ask,3,NULL);   
              Print("Stop Loss: ", StopLoss, "For loss");      
              StopLoss = "NULL";  
              }       
        
        
        }
         
      }      

   }
   
   
  }
//+------------------------------------------------------------------+
