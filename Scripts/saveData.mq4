//+------------------------------------------------------------------+
//|                                                     saveData.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int file = FileOpen("abc.csv", FILE_CSV|FILE_WRITE, ',');
   if (file < 0)
   {
      Print("Error code ",GetLastError());
      return ;
   }
   Print(""+ Bars);
   for(int i = 0; i < Bars; i++)
   {
      FileWrite(file, Time[i],Close[i]);
   }
   FileClose(file);
}
//+------------------------------------------------------------------+
