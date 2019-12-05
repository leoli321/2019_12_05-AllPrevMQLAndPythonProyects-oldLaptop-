void CloseAllOrdersThisPair()
{
   for (int i = OrdersTotal(); i >=0; i--){
    if (OrderSelect(1,SELECT_BY_POS)==TRUE){
      if (OrderSymbol() == Symbol()){
         int type = OrderType();
         bool result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Red);
      
      }
           
    }
   
   } 

}