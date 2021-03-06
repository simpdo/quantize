
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  clrRed
#property  indicator_color2  clrMediumSeaGreen
#property  indicator_color3  clrMediumBlue
#property indicator_level1 80
#property indicator_level3 20

//---- input parameters
extern int       KPeriod=9;
extern int       DPeriod=3;
extern int       JPeriod=3;

double     ind_buffer1[];
double     ind_buffer2[];
double     ind_buffer3[];
double     ind_buffer4[];
double HighesBuffer[];
double LowesBuffer[];

int draw_begin1=0;
int draw_begin2=0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {

//---- 用于计算的两个数据缓存.
   IndicatorBuffers(6);
   SetIndexBuffer(4, HighesBuffer);
   SetIndexBuffer(5, LowesBuffer);
   SetIndexBuffer(3, ind_buffer4);

//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, ind_buffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1, ind_buffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2, ind_buffer3);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("KDJ("+KPeriod+","+DPeriod+","+JPeriod+")");
   SetIndexLabel(0,"K");
   SetIndexLabel(1,"D");
   SetIndexLabel(2,"J");
//----
   draw_begin1=KPeriod+JPeriod;
   draw_begin2=draw_begin1+DPeriod;
   SetIndexDrawBegin(0,draw_begin1);
   SetIndexDrawBegin(1,draw_begin2);
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//----
   if(Bars<=draw_begin2) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=draw_begin1;i++) ind_buffer4[Bars-i]=0;
      for(i=1;i<=draw_begin2;i++) ind_buffer1[Bars-i]=0;
     }
//---- minimums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double min=1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=Low[k];
         if(min>price) min=price;
         k--;
        }
      LowesBuffer[i]=min;
      i--;
     }
//---- maximums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double max=-1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=High[k];
         if(max<price) max=price;
         k--;
        }
      HighesBuffer[i]=max;
      i--;
     }
//---- %K line
   i=Bars-draw_begin1;
   if(counted_bars>draw_begin1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double sumlow=0.0;
      double sumhigh=0.0;
      for(k=(i+JPeriod-1);k>=i;k--)
        {
         sumlow+=Close[k]-LowesBuffer[k];
         sumhigh+=HighesBuffer[k]-LowesBuffer[k];
        }
      if(sumhigh==0.0) ind_buffer4[i]=100.0;
      else ind_buffer4[i]=sumlow/sumhigh*100;
      i--;
     }
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
//   for(i=0; i<limit; i++)
//      ind_buffer3[i]=iMAOnArray(ind_buffer4,Bars,DPeriod,0,MODE_SMMA,i);
   Print("limit="+limit);
   for(i=0; i<limit; i++)
      ind_buffer1[i]=iMAOnArray(ind_buffer4,Bars,JPeriod,0,MODE_SMMA,i);
   for(i=0; i<limit; i++)
      ind_buffer2[i]=iMAOnArray(ind_buffer1,Bars,JPeriod,0,MODE_SMMA,i);
   for(i=0; i<limit; i++)
      ind_buffer3[i]=3*ind_buffer1[i] - 2*ind_buffer2[i];
//----
   return(0);
  }
//+------------------------------------------------------------------+