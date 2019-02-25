//+------------------------------------------------------------------+
//|                                                  socket_test.mq4 |
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
#include <socket-library-mt4-mt5.mqh>

void OnStart()
  {
//---
    uchar arrName[];
   StringToCharArray("127.0.0.1", arrName);
   ArrayResize(arrName, ArraySize(arrName) + 1);
   uint addr = inet_addr(arrName);

   uint client = socket(AF_INET, SOCK_STREAM, 0);
   sockaddr server;
   server.family = AF_INET;
   server.port = htons(8080);
   server.address = addr;
  }
//+------------------------------------------------------------------+
