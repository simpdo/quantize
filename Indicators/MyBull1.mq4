//+------------------------------------------------------------------+
//|                                                      MyBull1.mq4 |
//|                                                           pansen |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "pansen"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1

//--- plot fast
#property indicator_label1  "bull"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot slow
/*#property indicator_label2  "slow"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLime
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot diff
#property indicator_label3  "diff"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot bull
#property indicator_label4  "bull"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrYellow
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1*/

input int calcPeriod = 13;

//--- indicator buffers
double         fastBuffer[];
double         slowBuffer[];
double         diffBuffer[];
double         bullBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(4);
   SetIndexBuffer(0,bullBuffer);
   SetIndexBuffer(1,fastBuffer);
   SetIndexBuffer(2,slowBuffer);
   SetIndexBuffer(3,diffBuffer);   
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
   int limit = rates_total - prev_calculated;
   if (prev_calculated > 0 ) ++limit;
   
   int fastPeriod = round(calcPeriod/2);
   int bullPeriod = round(sqrt(calcPeriod));
   
   for(int i = 0; i < limit; i++)
   {
      fastBuffer[i] = iMA(NULL, 0,fastPeriod , 0, MODE_LWMA, PRICE_CLOSE, i);
      slowBuffer[i] = iMA(NULL, 0, calcPeriod, 0, MODE_LWMA, PRICE_CLOSE, i);
      diffBuffer[i] = fastBuffer[i]*2 - slowBuffer[i];         
   
      printf("time frame %d, fast %f, slow %f, diff %f", i, fastBuffer[i], slowBuffer[i], diffBuffer[i]);
   }
   
   for(int i = 0; i < limit; i++)
   {
      bullBuffer[i] = iMAOnArray(diffBuffer,ArraySize(diffBuffer),bullPeriod,0, MODE_LWMA, i);   
   }
      
   return(rates_total);
  }
//+------------------------------------------------------------------+
