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

void RunDiagnostics(){
                                                            
   if(SendDiagnosticData == 1){

   //---
   //This will include just the diagnostic data if set to false.
   SendConfirmationEmail(string(BrokerAccountNumber), False);
   //---
   
   }

   else {
   
      //---
      //The option to send notification has been stwiched off, and so no notification can be sent.
      //This is regardlss of the settings in the terminal
      Print("Sending Diagnostic Data has been switched off");
      //---
   }

   return;

}
