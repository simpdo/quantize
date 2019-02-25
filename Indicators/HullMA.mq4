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
#property indicator_label1  "HullUp"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_label2  "HullDown"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2


input int calcPeriod = 13;
input color upColor = clrBlue;
input color downColor = clrRed;

//--- indicator buffers
double         fastBuffer[];
double         slowBuffer[];
double         diffBuffer[];
double         hullBufferUp[];
double         hullBufferDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(5);  
   
   SetIndexBuffer(0,hullBufferUp);
   SetIndexBuffer(1,hullBufferDown);
   SetIndexBuffer(2,fastBuffer);
   SetIndexBuffer(3,slowBuffer);
   SetIndexBuffer(4,diffBuffer);  
   
   SetIndexDrawBegin(0, calcPeriod); 
   SetIndexDrawBegin(1, calcPeriod);   
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
   if (rates_total < calcPeriod)
      return 0;

   int limit = rates_total - prev_calculated;
   if (prev_calculated > 0 ) ++limit;
   
   int fastPeriod = round(calcPeriod/2);
   int hullPeriod = round(sqrt(calcPeriod));
   
   for(int i = 0; i < limit; i++)
   {
      fastBuffer[i] = iMA(NULL, 0,fastPeriod , 0, MODE_LWMA, PRICE_CLOSE, i);
      slowBuffer[i] = iMA(NULL, 0, calcPeriod, 0, MODE_LWMA, PRICE_CLOSE, i);
      diffBuffer[i] = fastBuffer[i]*2 - slowBuffer[i];         
   
      //printf("time frame %d, fast %f, slow %f, diff %f", i, fastBuffer[i], slowBuffer[i], diffBuffer[i]);
   }
   
   for(int i = 0; i < limit; i++)
   {
      hullBufferUp[i] = iMAOnArray(diffBuffer,ArraySize(diffBuffer),hullPeriod,0, MODE_LWMA, i); 
   }
   
   
   
   bool lastIsUp = true;
   for ( int i = 0; i < limit; i++)
   {
      if (i == rates_total - 1)
         break;
         
      if ( hullBufferUp[i] > hullBufferUp[i+1] )
      {
         if(lastIsUp)
            hullBufferDown[i] = EMPTY_VALUE;
         else
            hullBufferDown[i] = hullBufferUp[i];
         lastIsUp = true;
      }
      else
      {
         
         hullBufferDown[i] = hullBufferUp[i];         
         if (!lastIsUp)
             hullBufferUp[i] = EMPTY_VALUE;
         lastIsUp = false;
         
      }
   }
      
   return(rates_total);
  }
//+------------------------------------------------------------------+
