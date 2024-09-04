//+------------------------------------------------------------------+
//|                                                      manStat.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <GlobalNamespace.mqh>

void PermChartObjectsFluidAttr(){

ObjectSetString(0,"manBuy", OBJPROP_TEXT,"Market/Pending "+DoubleToString(SpotAsk,Digits)); 

   ObjectSetString(0,"manSell", OBJPROP_TEXT,"Market/Pending "+DoubleToString(SpotBid,Digits));
   
      if(MarketSpread <= 9){
      
         ObjectSetString(0,"spread", OBJPROP_TEXT,"0"+string(MarketSpread)); 
      
      } else {
      
         ObjectSetString(0,"spread", OBJPROP_TEXT,string(MarketSpread));
      
      }

}


