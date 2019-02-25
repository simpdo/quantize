//+------------------------------------------------------------------+
//|                                                   TickReport.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

string cookie = NULL;
string headers = NULL;
string url = "http://localhost:8000/tick?";

int OnInit()
{
//--- indicator buffers mapping

//---
return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
   char post[], result[];

   string req = url + "close=" + DoubleToString(close[0]) + "&open=" + DoubleToString(open[0])
             + "&high=" + DoubleToString(high[0]) + "&low=" + DoubleToString(low[0]) + "&Bid=" 
             + DoubleToString(Bid) + "&Ask=" + DoubleToString(Ask);
   int rst = WebRequest("Get", req, "", "", 3000, post, 0, result, headers);
   printf("result: %d", rst);

   return(rates_total);
}
//+------------------------------------------------------------------+
