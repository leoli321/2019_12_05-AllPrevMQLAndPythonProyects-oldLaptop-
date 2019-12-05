//+------------------------------------------------------------------+
//|                              2019_01_23-RandomNumberModified.mq4 |
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

double ModifiedRandNumber(){

      MathSrand((GetTickCount() + TimeLocal()) * MathRand()%100 );
      Random_number = MathRand()%100;  
      SMAFast = iMA(Symbol(),SMATimeFrame,FastSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
      SMAMid = iMA(Symbol(),SMATimeFrame,MidSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
      SMALong = iMA(Symbol(),SMATimeFrame,LongSMAPeriod,0,MODE_SMA,PRICE_CLOSE,1);
      MACD = iMACD(Symbol(),SMATimeFrame,12,16,9,PRICE_CLOSE,MODE_MAIN,1);
      MACDPrev = iMACD(Symbol(),SMATimeFrame,12,16,9,PRICE_CLOSE,MODE_MAIN,2);
      Stochastic = iStochastic(Symbol(),SMATimeFrame,10,6,6,MODE_SMA,0,MODE_MAIN,1);
      BandsUpper = iBands(Symbol(),SMATimeFrame,20,2,0,PRICE_CLOSE,MODE_UPPER,1);
      BandsLower = iBands(Symbol(),SMATimeFrame,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
      
      if(iClose(Symbol(),SMATimeFrame,1) < SMAFast){Random_number = Random_number + SMAFastModifier; SMAFastMod = +SMAFastModifier;}
      if(iClose(Symbol(),SMATimeFrame,1) > SMAFast){Random_number = Random_number - SMAFastModifier; SMAFastMod = -SMAFastModifier;}
      if(MACD > MACDPrev){ Random_number = Random_number + MACDModifier; MACDMod = +MACDModifier; }
      if(MACD < MACDPrev){ Random_number = Random_number - MACDModifier; MACDMod = -MACDModifier; }
      if(iClose(Symbol(),SMATimeFrame,1) < SMAMid){Random_number = Random_number + SMAMidModifier; SMAMidMod = +SMAMidModifier;}
      if(iClose(Symbol(),SMATimeFrame,1) > SMAMid){Random_number = Random_number - SMAMidModifier; SMAMidMod = -SMAMidModifier;}
      
      if(Stochastic > 80){Random_number = Random_number - StochasticModifier; StochasticMod = - StochasticModifier;  }
      if(Stochastic < 20){Random_number = Random_number + StochasticModifier; StochasticMod = + StochasticModifier;  }
      
      if(   iClose(Symbol(),SMATimeFrame,1) > BandsUpper  ){ Random_number = Random_number - BandsModifier;}
      if(   iClose(Symbol(),SMATimeFrame,1) < BandsLower  ){ Random_number = Random_number + BandsModifier;}
      
      if(   (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain1 == "BUY"){   Random_number = Random_number - ActualPositionModifier;   }
      if(   (OrderSelect(TicketMain1,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain1 == "SELL"){   Random_number = Random_number + ActualPositionModifier;   }
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain2 == "BUY"){   Random_number = Random_number - ActualPositionModifier;   }
      if(   (OrderSelect(TicketMain2,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain2 == "SELL"){   Random_number = Random_number + ActualPositionModifier;   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain3 == "BUY"){   Random_number = Random_number - ActualPositionModifier;   }
      if(   (OrderSelect(TicketMain3,SELECT_BY_TICKET,MODE_TRADES) == true) && OrderDirectionMain3 == "SELL"){   Random_number = Random_number + ActualPositionModifier;   }
                

      
      return(Random_number);
            
}