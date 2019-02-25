//+------------------------------------------------------------------+
//|                                                       socket.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#import "MtSocket.dll"
   int InitSocket();
   int Connect(string host, ushort port);
   int SendData(string data);
   string ReadData();
   int DeinitSocket();
#import

void OnStart()
{
   int result = InitSocket();
   if (result != 0)
   {
      printf("init socket failed, error: %d\n", GetLastError());
      return ;
   }
   
   result = Connect("127.0.0.1", 8080);
   if ( result != 0)
   {
      printf("connect to server failed,result %d, error: %d\n", result, GetLastError());
      return;
   }
   SendData("hello world!");
   string data = ReadData();
   printf("read data: %s", data); 
}
//+------------------------------------------------------------------+
