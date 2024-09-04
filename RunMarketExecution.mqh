//+------------------------------------------------------------------+
//|                                               RunDiagnostics.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <GlobalNamespace.mqh>
#include <ConfirmationMessage.mqh>
#include <EmailLegalDisclaimer.mqh>
#include <CompanyData.mqh>

//+------------------------------------------------------------------+
//|This module will run the market(spot)execution module, and will
//| return either a successful execution or a failed execution.                                                             |
//+------------------------------------------------------------------+

void ExecuteMarketOrder(int OrderProperty){

   StopLossPrice     =  NormalizeDouble((pipStopLoss * Point),Digits);
   TakeProfitPrice   =  NormalizeDouble(((pipStopLoss * RewardFactor) * Point),Digits);
   
   //---
   //This will verify as to whether the OrderProperty is valid.
   //if the OrderProperty is NOT valid, then an error message will be sent. See below.
   if(OrderProperty <= 5){
   
      //---
      //This will take care of all Market Orders.
      //This will return an eaCode of 1
      if(OrderProperty <= 1){ 
       
         if(OrderProperty == 0){
         
            //If the OrderProperty is set to 0, the following variables will be calculated and instantiated into the OrderSend() statement)
            PriceProperty           =  Ask;
            MarketOrderStopLoss     =  Ask - StopLossPrice;
            MarketOrderTakeProfit   =  Ask + TakeProfitPrice;
            WebColors               =  clrGreen;
            EstimatedProfit         =  ((MarketOrderTakeProfit - Ask)/Point) / ExchangeRate;

            //---

         } else if (OrderProperty == 1){
         
            //---
            //If the OrderProperty is set to 1, the following variables will be calculated and instantiated into the OrderSend() statement)
            PriceProperty           =  Bid;
            MarketOrderStopLoss     =  Bid + StopLossPrice;
            MarketOrderTakeProfit   =  Bid - TakeProfitPrice;
            WebColors               =  clrCyan;
            EstimatedProfit         =  ((Bid - MarketOrderTakeProfit)/Point) / ExchangeRate;

            //---
            
         }
         
         Expires = 0;
         
      }   
      //---

      //---
      //This will take care of all Pending Orders.
      //This will return an eaCode of 4
      if(OrderProperty >= 2){
      
      CurrentBarOpenPrice = Open[0];
      
         //---
         //This will take care of either the BUY_LIMIT or the BUY_STOP order.
         if(OrderProperty == 2 || OrderProperty == 4){
         //---
         
            PriceProperty           =  CurrentBarOpenPrice;
            MarketOrderStopLoss     =  CurrentBarOpenPrice - StopLossPrice; 
            MarketOrderTakeProfit   =  CurrentBarOpenPrice + TakeProfitPrice;
            WebColors               =  clrCornflowerBlue; 
         
         //---
         //This will take care of either the SELL_STOP or the SELL_LIMIT order
         } else if (OrderProperty == 3 || OrderProperty == 5) {
         
            PriceProperty           =  CurrentBarOpenPrice;
            MarketOrderStopLoss     =  CurrentBarOpenPrice + StopLossPrice; 
            MarketOrderTakeProfit   =  CurrentBarOpenPrice - TakeProfitPrice;
            WebColors               =  clrLightSeaGreen;
            
         }
         //---

         Expires = CandleOpenTime + PendingExpiration;
      
      } 
      
      Print("Estimated profit ",accountCurrency+string(EstimatedProfit));
      
      //---
      //As long as the OrderProperty is less than or equal to 5 (the maximum number of order types), an order will attempted to be sent to te broker.
      if(!OrderSend(Symbol(),OrderProperty,LotSize,PriceProperty,100,MarketOrderStopLoss,MarketOrderTakeProfit,StringSubstr(EnumToString((ENUM_ENTITY)Group_Entity),0),int(UniqueChartIdentifier),Expires,WebColors)){
      
      #ifdef __SLEEP_AFTER_EXECUTION_FAIL
            
         Sleep(__SLEEP_AFTER_EXECUTION_FAIL);
            
      #endif 
         
         DiagnosticMessaging("Order Execution Failure","Your broker has made an attempt to place an order. Unfortunately this was unsuccessful");
                  
      } else {
               
         if(OperationMode != 1){
         
            ChartButtonStaticAttributes();
                        
            SendConfirmationEmail(string(BrokerAccountNumber), True);
                     
         } 
                              
      }
      
   } else {
   
      //---
      //If the OrderProperty cannot be deteramined, then an error message will be sent, returning an error code.
      DiagnosticMessaging("Order Execution Error","The type of order could not be determined");
      //---
   }   

   return;

}