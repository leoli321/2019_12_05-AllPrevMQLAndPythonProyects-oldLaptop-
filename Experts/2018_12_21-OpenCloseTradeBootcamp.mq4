void OpenTrade(int direction){

   if(direction == 0){
      int buyticket = OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,NULL,0,0,Green);
   }
   
   if(direction ==1){
      int sellticket = OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,0,NULL,0,0,Red);
   }

}
