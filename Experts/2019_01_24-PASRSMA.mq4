//+------------------------------------------------------------------+
//|                                           2019_01_24-PASRSMA.mq4 |
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

int DayTimeframe = 1440;
int WeekTimeframe = 10080;
int FastMaPeriod = 10;
int SlowMaPeriod = 40;

double LotSizeMaster = 0.03;
double LotSizeWeek = 0.02;
double LotSizeDay = 0.01;
double MACDLotVolume = 0.02;

double MaxIndividualEquityLoss = -40;

double DayFastSMA;
double WeekFastSMA;
double DaySlowSMA;
double WeekSlowSMA;
double WeekIADX;
double DayIADX;
double WeekMACD;
double PrevWeekMACD;
double PrevWeekFASTSMA;


int OpenMasterSMATicketBUY;
int OpenMasterSMATicketSELL;
int CloseMasterSMATicketBUY;
int CloseMasterSMATicketSELL;

int OpenWeekSMATicketBUY;
int OpenWeekSMATicketSELL;
int CloseWeekSMATicketBUY;
int CloseWeekSMATicketSELL;

int OpenDaySMATicketBUY;
int OpenDaySMATicketSELL;
int CloseDaySMATicketBUY;
int CloseDaySMATicketSELL;

int WeekMACDTicketBUY;
int WeekMACDTicketSELL;
int CloseWEEKMACDTicketBUY;
int CloseWEEKMACDTicketSELL;



void OnTick()
  {
  
   DayFastSMA = iMA(Symbol(),DayTimeframe,FastMaPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   PrevWeekFASTSMA = iMA(Symbol(),WeekTimeframe,FastMaPeriod,0,MODE_SMA,PRICE_CLOSE,2);
   WeekFastSMA = iMA(Symbol(),WeekTimeframe,FastMaPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   DaySlowSMA = iMA(Symbol(),DayTimeframe,SlowMaPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   WeekSlowSMA = iMA(Symbol(),WeekTimeframe,SlowMaPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   WeekIADX = iADX(Symbol(),10080,40,PRICE_CLOSE,0,0);
   DayIADX = iADX(Symbol(),1440,40,PRICE_CLOSE,0,0);
   WeekMACD = iMACD(Symbol(),10080,20,40,10,PRICE_CLOSE,0,1);
   PrevWeekMACD = iMACD(Symbol(),10080,20,40,10,PRICE_CLOSE,0,2);
   
   //MASTER;
   //OpenBUY
   if( (iClose(Symbol(),WeekTimeframe,1) > WeekSlowSMA) && ((iClose(Symbol(),WeekTimeframe,1) > WeekFastSMA)) 
         && ((iClose(Symbol(),DayTimeframe,1) > DayFastSMA)) && ((iClose(Symbol(),DayTimeframe,1) > DayFastSMA))  ){
            
            if (  ((OrderSelect(OpenMasterSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 9)   ){
               OpenMasterSMATicketBUY = OrderSend(Symbol(),OP_BUY,LotSizeMaster,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               Print("BUY MASTER");
            }
                       
         }
         
        ///CLOSE BUY
            if (  ((OrderSelect(OpenMasterSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true))&& (  (WeekFastSMA < PrevWeekFASTSMA) )  ){
               CloseMasterSMATicketBUY = OrderClose(OpenMasterSMATicketBUY,LotSizeMaster,Bid,3,NULL);
               OpenMasterSMATicketBUY = NULL;
            }            
   //OPEN SELL
   
   if( (iClose(Symbol(),WeekTimeframe,1) < WeekSlowSMA) && ((iClose(Symbol(),WeekTimeframe,1) < WeekFastSMA)) 
         && ((iClose(Symbol(),DayTimeframe,1) < DayFastSMA)) && ((iClose(Symbol(),DayTimeframe,1) < DayFastSMA))  ){
            
            if (  ((OrderSelect(OpenMasterSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 9)  ){
               OpenMasterSMATicketSELL = OrderSend(Symbol(),OP_SELL,LotSizeMaster,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               Print("SELL MASTER");
            }
                    
         }
         ///CLOSE SELL
            if (  ((OrderSelect(OpenMasterSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true)) && (  (WeekFastSMA > PrevWeekFASTSMA) )  ){
               CloseMasterSMATicketSELL = OrderClose(OpenMasterSMATicketSELL,LotSizeMaster,Ask,3,NULL);
               OpenMasterSMATicketSELL = NULL;
            }           

   //Week;
   //OpenBUY
         if( (iClose(Symbol(),WeekTimeframe,1) > WeekSlowSMA) && ((iClose(Symbol(),WeekTimeframe,1) > WeekFastSMA))  ){
            
            if (  ((OrderSelect(OpenWeekSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 9)  ){
               Print("BUY WEEK");
               OpenWeekSMATicketBUY = OrderSend(Symbol(),OP_BUY,LotSizeWeek,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
            }
            
         
         }
         ///CLOSE BUY
            if (  ((OrderSelect(OpenWeekSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true)) && (  (WeekFastSMA < PrevWeekFASTSMA) )  ){
               CloseWeekSMATicketBUY = OrderClose(OpenWeekSMATicketBUY,LotSizeWeek,Bid,3,NULL);
               OpenWeekSMATicketBUY = NULL;
            }          
   //OPEN SELL
         if( (iClose(Symbol(),WeekTimeframe,1) < WeekSlowSMA) && ((iClose(Symbol(),WeekTimeframe,1) < WeekFastSMA))  ){
            
            if (  ((OrderSelect(OpenWeekSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 9)  ){
               Print("SELL WEEK");
               OpenWeekSMATicketSELL = OrderSend(Symbol(),OP_SELL,LotSizeWeek,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
            }
            
           
         }   
         
         ////CLOSE SELL
            if (  ((OrderSelect(OpenWeekSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true)) && (  (WeekFastSMA > PrevWeekFASTSMA) )  ){
               CloseWeekSMATicketSELL = OrderClose(OpenWeekSMATicketSELL,LotSizeWeek,Ask,3,NULL);
               OpenWeekSMATicketSELL = NULL;
            }            
         
   //Day; //QUE SALGA CUANDO LA FAST CAMBIE DE PENDIENTE; (QUE ENTRE IGUAL).
   //OpenBUY
         if( (iClose(Symbol(),DayTimeframe,1) > DaySlowSMA) && ((iClose(Symbol(),DayTimeframe,1) > DayFastSMA)) ){
            
            if (  ((OrderSelect(OpenDaySMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 15)  ){
               OpenDaySMATicketBUY = OrderSend(Symbol(),OP_BUY,LotSizeDay,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL);
               Print("BUY DAY");
            }
                      
         }         
         //CLOSE BUY
            if (  ((OrderSelect(OpenDaySMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true)) && (  (WeekFastSMA < PrevWeekFASTSMA) )  ){
               CloseDaySMATicketBUY = OrderClose(OpenDaySMATicketBUY,LotSizeDay,Bid,3,NULL);
               OpenDaySMATicketBUY = NULL;
            }              
   //OpenSELL
         if( (iClose(Symbol(),DayTimeframe,1) < DaySlowSMA) && ((iClose(Symbol(),DayTimeframe,1) < DayFastSMA)) ){
            
            if (  ((OrderSelect(OpenDaySMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == false)) && (WeekIADX > 15)  ){
               OpenDaySMATicketSELL = OrderSend(Symbol(),OP_SELL,LotSizeDay,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);
               Print("SELL DAY");
            }
            
       
         }   
         //CLOSE SELL
            if (  ((OrderSelect(OpenDaySMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true)) && (  (WeekFastSMA > PrevWeekFASTSMA) )  ){
               CloseDaySMATicketSELL = OrderClose(OpenDaySMATicketSELL,LotSizeDay,Ask,3,NULL);
               OpenDaySMATicketSELL = NULL;
            }              
         

///STOPS IF EQUITY
   
   if( (OrderSelect(OpenDaySMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < -15 ) ){ CloseDaySMATicketSELL = OrderClose(OpenDaySMATicketSELL,LotSizeDay,Ask,3,NULL); OpenDaySMATicketSELL = NULL;}
   if( (OrderSelect(OpenDaySMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < -15 ) ){ CloseDaySMATicketBUY = OrderClose(OpenDaySMATicketBUY,LotSizeDay,Ask,3,NULL); OpenDaySMATicketBUY = NULL;}
   
   if( (OrderSelect(OpenWeekSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < MaxIndividualEquityLoss ) ){ CloseWeekSMATicketSELL = OrderClose(OpenWeekSMATicketSELL,LotSizeWeek,Ask,3,NULL); OpenWeekSMATicketSELL = NULL;}
   if( (OrderSelect(OpenWeekSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < MaxIndividualEquityLoss ) ){ CloseWeekSMATicketBUY = OrderClose(OpenWeekSMATicketBUY,LotSizeWeek,Ask,3,NULL); OpenWeekSMATicketBUY = NULL;}
   
   if( (OrderSelect(OpenMasterSMATicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < MaxIndividualEquityLoss ) ){ CloseMasterSMATicketSELL = OrderClose(OpenMasterSMATicketSELL,LotSizeMaster,Ask,3,NULL); OpenMasterSMATicketSELL = NULL;}
   if( (OrderSelect(OpenMasterSMATicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < MaxIndividualEquityLoss ) ){ CloseMasterSMATicketBUY = OrderClose(OpenMasterSMATicketBUY,LotSizeMaster,Ask,3,NULL); OpenMasterSMATicketBUY = NULL;}
    
    
    
    
    /*
    //////////////NOW COMES THE MACD PART:
    if(  (PrevWeekMACD < 0) && (WeekMACD > 0) && (WeekIADX < 20) ){
      
      if ( (OrderSelect(WeekMACDTicketBUY,SELECT_BY_TICKET,MODE_TRADES) == false) ) {  WeekMACDTicketBUY = OrderSend(Symbol(),OP_BUY,MACDLotVolume,Ask,3,NULL,NULL,NULL,NULL,NULL,NULL); }
      if( (OrderSelect(WeekMACDTicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true ) ) {  CloseWEEKMACDTicketSELL = OrderClose(WeekMACDTicketSELL,MACDLotVolume,Ask,3,NULL); WeekMACDTicketSELL = NULL; }
    }
    
    if(  (PrevWeekMACD > 0) && (WeekMACD < 0) && (WeekIADX < 20) ){
    
      if ( (OrderSelect(WeekMACDTicketSELL,SELECT_BY_TICKET,MODE_TRADES) == false) ) {   WeekMACDTicketSELL = OrderSend(Symbol(),OP_SELL,MACDLotVolume,Bid,3,NULL,NULL,NULL,NULL,NULL,NULL);  }
      if( (OrderSelect(WeekMACDTicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true ) ) {  CloseWEEKMACDTicketBUY = OrderClose(WeekMACDTicketBUY,MACDLotVolume,Bid,3,NULL); WeekMACDTicketBUY = NULL;    }
    }    
    
    
    if( (OrderSelect(WeekMACDTicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < -50 ) ){ CloseWEEKMACDTicketBUY = OrderClose(WeekMACDTicketBUY,LotSizeDay,Bid,3,NULL); WeekMACDTicketBUY = NULL;}
    if( (OrderSelect(WeekMACDTicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) < -50 ) ){ CloseWEEKMACDTicketSELL = OrderClose(WeekMACDTicketSELL,LotSizeDay,Bid,3,NULL); WeekMACDTicketSELL = NULL;}
        
    if( (OrderSelect(WeekMACDTicketBUY,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) > 50 ) ){ CloseWEEKMACDTicketBUY = OrderClose(WeekMACDTicketBUY,LotSizeDay,Bid,3,NULL); WeekMACDTicketBUY = NULL;}
    if( (OrderSelect(WeekMACDTicketSELL,SELECT_BY_TICKET,MODE_TRADES) == true) && ( (OrderProfit() + OrderSwap() ) > 50 ) ){ CloseWEEKMACDTicketSELL = OrderClose(WeekMACDTicketSELL,LotSizeDay,Bid,3,NULL); WeekMACDTicketSELL = NULL;}
    */
   
   Comment("WeekSlow and Fast MA: ", WeekSlowSMA, "   ", WeekFastSMA, "\n",
            "CLOSE: ", iClose(Symbol(),WeekTimeframe,1));
         
         
  }
//+------------------------------------------------------------------+
