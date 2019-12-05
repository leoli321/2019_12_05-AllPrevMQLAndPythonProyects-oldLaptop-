//+------------------------------------------------------------------+
//|                            2018_01_08-RandomEntryManySymbols.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern double Stp = 1.03;
extern double TProfit = 1.01;
extern double LotSize = .1;

int BuyOrSellCADCHF = 0;
int BuyOrSellCADJPY = 0;
int BuyOrSellCHFJPY = 0;
int BuyOrSellEURCAD = 0;
int BuyOrSellEURCHF = 0;
int BuyOrSellEURGBP = 0;
int BuyOrSellEURJPY = 0;
int BuyOrSellEURUSD = 0;
int BuyOrSellGBPCAD = 0;
int BuyOrSellGBPCHF = 0;
int BuyOrSellGBPJPY = 0;
int BuyOrSellGBPUSD = 0;
int BuyOrSellUSDCAD = 0;
int BuyOrSellUSDCHF = 0;
int BuyOrSellUSDJPY = 0;

int CADCHFTicket;
int CADJPYTicket;
int CHFJPYTicket;
int EURCADTicket;
int EURCHFTicket;
int EURGBPTicket;
int EURJPYTicket;
int EURUSDTicket;
int GBPCADTicket;
int GBPCHFTicket;
int GBPJPYTicket;
int GBPUSDTicket;
int USDCADTicket;
int USDCHFTicket;
int USDJPYTicket;


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
       BuyOrSellCADCHF = MathRand()%2;
       BuyOrSellCADJPY = MathRand()%2;
       BuyOrSellCHFJPY = MathRand()%2;
       BuyOrSellEURCAD = MathRand()%2;
       BuyOrSellEURCHF = MathRand()%2;
       BuyOrSellEURGBP = MathRand()%2;
       BuyOrSellEURJPY = MathRand()%2;
       BuyOrSellEURUSD = MathRand()%2;
       BuyOrSellGBPCAD = MathRand()%2;
       BuyOrSellGBPCHF = MathRand()%2;
       BuyOrSellGBPJPY = MathRand()%2;
       BuyOrSellGBPUSD = MathRand()%2;
       BuyOrSellUSDCAD = MathRand()%2;
       BuyOrSellUSDCHF = MathRand()%2;
       BuyOrSellUSDJPY = MathRand()%2;
       
       if(OrdersTotal() < 16){
         //CADCHF
         if(BuyOrSellCADCHF == 0){ CADCHFTicket = OrderSend("CADCHF",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellCADCHF == 1){ CADCHFTicket = OrderSend("CADCHF",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }
         
         //CADJPY
         if(BuyOrSellCADJPY == 0){ CADJPYTicket = OrderSend("CADJPY",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellCADJPY == 1){ CADJPYTicket = OrderSend("CADJPY",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }
         
         //CHFJPY
         if(BuyOrSellCHFJPY == 0){ CHFJPYTicket = OrderSend("CHFJPY",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellCHFJPY == 1){ CHFJPYTicket = OrderSend("CHFJPY",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }         
         
         //EURCAD
         if(BuyOrSellEURCAD == 0){ EURCADTicket = OrderSend("EURCAD",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellEURCAD == 1){ EURCADTicket = OrderSend("EURCAD",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }    
 
          //EURCHF
         if(BuyOrSellEURCHF == 0){ EURCHFTicket = OrderSend("EURCHF",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellEURCHF == 1){ EURCHFTicket = OrderSend("EURCHF",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }   
         
         //EURGBP
         if(BuyOrSellEURGBP == 0){ EURGBPTicket = OrderSend("EURGBP",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellEURGBP == 1){ EURGBPTicket = OrderSend("EURGBP",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }   
         
         //EURJPY
         if(BuyOrSellEURJPY == 0){ EURJPYTicket = OrderSend("EURJPY",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellEURJPY == 1){ EURJPYTicket = OrderSend("EURJPY",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }            
         
         //EURUSD
         if(BuyOrSellEURUSD == 0){ EURUSDTicket = OrderSend("EURUSD",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellEURUSD == 1){ EURUSDTicket = OrderSend("EURUSD",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }    
         
         //GBPCAD
         if(BuyOrSellGBPCAD == 0){ GBPCADTicket = OrderSend("GBPCAD",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellGBPCAD == 1){ GBPCADTicket = OrderSend("GBPCAD",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }   
         
         //GBPCHF
         if(BuyOrSellGBPCHF == 0){ GBPCHFTicket = OrderSend("GBPCHF",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellGBPCHF == 1){ GBPCHFTicket = OrderSend("GBPCHF",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); } 
         
         //GBPJPY
         if(BuyOrSellGBPJPY == 0){ GBPJPYTicket = OrderSend("GBPJPY",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellGBPJPY == 1){ GBPJPYTicket = OrderSend("GBPJPY",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }     
        
         //GBPUSD
         if(BuyOrSellGBPUSD == 0){ GBPUSDTicket = OrderSend("GBPUSD",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellGBPUSD == 1){ GBPUSDTicket = OrderSend("GBPUSD",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }   
         
         //USDCAD
         if(BuyOrSellUSDCAD == 0){ USDCADTicket = OrderSend("USDCAD",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellUSDCAD == 1){ USDCADTicket = OrderSend("USDCAD",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }  
         
         //USDCHF
         if(BuyOrSellUSDCHF == 0){ USDCHFTicket = OrderSend("USDCHF",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellUSDCHF == 1){ USDCHFTicket = OrderSend("USDCHF",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }            
         
         //USDJPY
         if(BuyOrSellUSDJPY == 0){ USDJPYTicket = OrderSend("USDJPY",OP_SELL,LotSize,Bid,3,Bid*Stp,Bid/TProfit,NULL,NULL,NULL,NULL);}
         if(BuyOrSellUSDJPY == 1){ USDJPYTicket = OrderSend("USDJPY",OP_BUY,LotSize,Ask,3,Ask/Stp,Ask*TProfit,NULL,NULL,NULL,NULL); }            
                            
   }
  }
//+------------------------------------------------------------------+
