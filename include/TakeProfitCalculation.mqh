//+------------------------------------------------------------------+
//|                                        TakeProfitCalculation.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <GlobalNamespace.mqh>
#include <ClientData.mqh>
#include <CompanyData.mqh>
#include <EmailLegalDisclaimer.mqh>

double TakeProfitCalcuation(){

   //---
   //The TakeProfitPrice variable declaration. This will be used to calculate the tp value on new orders.
   TakeProfitPrice =  NormalizeDouble(((pipStopLoss * RewardFactor) * Point),Digits);
   //---
   
   //---
   //Adjusted Take Profit Price on Init. This will check to see if the RewardFactor has changed. If this is difference, it will recalcuated the new tp value.
   if(OrderSelect(OpenPositions, SELECT_BY_POS, MODE_TRADES)){
   
      if(OrderTakeProfit() != (OrderOpenPrice() - TakeProfitPrice) || (OrderTakeProfit() != OrderOpenPrice() + TakeProfitPrice)){
      
         Print("A new Reward Factor has been implemented");
         
         Expires  =  0; 
         
         if(OrderType() == 0){
                     
            ModifiedTakeProfitPrice =  OrderOpenPrice() + TakeProfitPrice;
         
         } else if (OrderType() == 1) {
         
            ModifiedTakeProfitPrice =  OrderOpenPrice() - TakeProfitPrice;
         }   
      
         if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ModifiedTakeProfitPrice,Expires,Blue)){
         
            SendMail("Order Modification Failure Notification" + HeaderInformation,"Dear "+ClientName+"\n\nThis is a notification to confirm that the order #"+string(TicketReference)+" has failed to be modified in accordance to the error code #."+string(GetCurrentErrorCode)+"\n\nIf you need any further assistence, please send a message to "+CompanyRaiseTicket+"\n\nYours sincerely\n\n"+CompanyName+"\n\n"+EmailLegalDisclaimer());
            
            Print("Order #"+string(TicketReference)+" has not beem modfied. Please refer to error #"+string(GetCurrentErrorCode));
         
         } else {
         
            Print("Order #"+string(TicketReference)+" has been successfully modified to a new TP value of "+string(MarketOrderTakeProfit));
         
            SendMail("Order Modification Notification" + HeaderInformation,"Dear "+ClientName+"\n\nThis is a notification to confirm that the order #"+string(TicketReference)+" has been successfully modified.\n\nIf you need any further assistence, please send a message to "+CompanyRaiseTicket+"\n\nYours sincerely\n\n"+CompanyName+"\n\n"+EmailLegalDisclaimer());
         
         }
      
      }
      
      return ModifiedTakeProfitPrice;
            
   } 
   
   return TakeProfitPrice;

}

   
   

