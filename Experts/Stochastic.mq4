//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                                                           pansen |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "pansen"
#property link      ""
#property version   "1.00"
#property strict


input double   orderSize=0.01;
input int      lost=300;
input int      buyMagic=18;
input int      sellMagic=19;
input int      maxOrderCnt=1;
input string   sellComment="ea-sell";
input string   buyComment="ea-buy";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{ 
}  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //当前的指标值
   double fastValue = iCustom(NULL, PERIOD_M15, "Stochastic", 5, 3, 3, 0, 0);
   double slowValue = iCustom(NULL, PERIOD_M15, "Stochastic", 5, 3, 3, 1, 0);
   //前一个指标值
   double preFastValue = iCustom(NULL, PERIOD_M15, "Stochastic", 5, 3, 3, 0, 1);
   double preSlowValue = iCustom(NULL, PERIOD_M15, "Stochastic", 5, 3, 3, 1, 1);
   
   printf("fast value %f, slow value %f", fastValue, slowValue);
   
   //不管买入还是卖出信号，先平掉现有的单，在根据信号下单
   if ( isBuySign(fastValue, slowValue, preFastValue, preSlowValue) )
   {
      
      bool flag = findOrder(buyMagic,"ea-buy",OP_BUY);
      if( !flag )
      {
         Print("开多单，平空单,当前单量="+OrdersTotal());
         closeSell(sellComment,sellMagic);
         buy(orderSize,lost,0,buyComment,buyMagic);
      }      
      
      return ;  
   }
   
   if(isSellSign(fastValue, slowValue, preFastValue, preSlowValue))
   {   
      bool flag = findOrder(sellMagic,"ea-sell",OP_SELL);
      if( !flag )
      {
         Print("开空单，平多单");
         closeBuy(buyComment,buyMagic);
         sell(orderSize,lost,0,sellComment,sellMagic);
      }   
   }
}
//+------------------------------------------------------------------+

//买入信号，快线向上穿过慢线
bool isBuySign(double fastValue, double slowValue, double preFastValue, double preSlowValue)
{
   if ( fastValue - slowValue > 0 && preFastValue <= preSlowValue)
      return true;
      
   return false;
}

//卖出信号，快线向下穿过慢线
bool isSellSign(double fastValue, double slowValue, double preFastValue, double preSlowValue)
{
   if ( fastValue - slowValue < 0 && preFastValue >= preSlowValue )
      return true;      
      
   return false;
}

bool findOrder(int magicNumber,string desc,int orderType)
{
    for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         string comment=OrderComment();
         int ma=OrderMagicNumber();
         if(OrderSymbol()==Symbol() && OrderType()==orderType && ma==magicNumber)
            return true;
      }
   }
   return false;
}


void closeBuy(string com,int magic)
{
   int t=OrdersTotal();
   for(int i=t-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderComment()==com && OrderMagicNumber()==magic)
         {
            OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),30,CLR_NONE);
         }
      }
   }
}
void closeSell(string com,int magic)
{
   int t=OrdersTotal();
   for(int i=t-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderComment()==com && OrderMagicNumber()==magic)
         {
            OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),30,CLR_NONE);
         }
      }
   }
}

int buy(double lots,double sl,double tp,string com,int buymagic)
{
   int a=0;
   bool flag=findOrder(buymagic,com,OP_BUY);
   
   if(flag==false)
   {
      if(sl!=0 && tp==0)
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,CLR_NONE);
   
      if(sl==0 && tp!=0)
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,Ask+tp*Point,com,buymagic,0,CLR_NONE);
   
      if(sl==0 && tp==0)
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,com,buymagic,0,CLR_NONE);
   
      if(sl!=0 && tp!=0)
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,CLR_NONE);
   }
   
   return(a);
}

int sell(double lots,double sl,double tp,string com,int sellmagic)
{
   int a=0;
   bool flag=findOrder(sellmagic,com,OP_BUY);
   if(flag==false)
   {
      if(sl==0 && tp!=0)
      {
         a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,Bid-tp*Point,com,sellmagic,0,CLR_NONE);
      }
      
      if(sl!=0 && tp==0)
      {
         a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,CLR_NONE);
      }
      
      if(sl==0 && tp==0)
      {
         a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,0,com,sellmagic,0,CLR_NONE);
      }
      
      if(sl!=0 && tp!=0)
      {
         a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,CLR_NONE);
      }
   }
   
   return(a);
}
