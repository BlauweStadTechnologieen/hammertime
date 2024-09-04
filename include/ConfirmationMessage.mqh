//+------------------------------------------------------------------+
//|                                          ConfirmationMessage.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include <GlobalNamespace.mqh>
#include <ScreenshotCapture.mqh>
#include <ExecutionDiagnostics.mqh>
#include <BrokerData.mqh>
#include <CompanyData.mqh>
#include <FunctionsModule.mqh>
#include <ChartButtonStaticAttrs.mqh>


void SendConfirmationEmail(string ScreenshotName, bool ParamsMet){

   //Required parameter(s):
   //ScrenshotName: "Custom string" OR an integer explicitly converted to a string(integer variable)
   //ParamsMet: True OR False
   
   bool     SelectOrder                         =  OrderSelect(OrdersTotal()-1,SELECT_BY_POS, MODE_TRADES);
   string   ParamDiagnostics                    =  ExecutionDiagnostics();
   string   ConfirmationOrderProperty           =  "Market Order";
   string   FooterNotesForConformationMessage   =  LegalFooterDisclaimer();
   string   ChartURL;
   int      AutoGenID                           =  MathRand()+FileNameIDGenerator(9999,99999);
      
   if (!ParamsMet){
   
      ConfimationEmailCostData  =  "As no order was sent to the broker, cost data is not available.";
      ExecutionSymbol           =  Symbol();
      ChartURL                  =  ScreenShotCaptureURL(ScreenshotName,AutoGenID);
      ConfimationEmailGreeting  =  "A "+ConfirmationOrderProperty+" would have been placed with your broker on the "+ExecutionSymbol+" "+ExecutionTimeframe+"H Chart. However one or more parameters were not met. Check below to see which parameter(s) failed.";
   
   } else {
   
      if(!SelectOrder){
      
         GetCurrentErrorCode        =  GetLastError();
         ConfirmationOrderProperty  =  "Order Error ("+string(GetCurrentErrorCode)+")";
         ConfimationEmailGreeting   =  "Although your broker successfully sent an order to your broker, there was an error with selecting the order from the ledger, therefore we are unable to provide any cost data or screen shot capture services.\n\n"+errorCodeURL+"\n\nPlease contact "+CompanyRaiseTicket+" to raise a support ticket, which can also be done via our website at https://www."+CompanyDomain;
         ConfimationEmailCostData   =  "Cost data is unavailable.(Error #"+string(GetCurrentErrorCode)+")";
         ChartURL                   =  "Screenshot unavailable at this time";
         
         DiagnosticMessaging("Order Select Error on Successful Execution","Although your broker has successfully returned an order transaction, there was an error in selecting the order from the ledger. Ths means that cost data & screen capture services are not available on this occasion.");
      
      } else {
      
         if (OrderType() >= 2){
         
            ConfirmationOrderProperty = "Pending Order";
         
         } 
      
         double ItemizedCosts[4];
         
         ItemizedCosts[0] = OrderMarginRequirement;
         ItemizedCosts[1] = ExecutionSpreadCharge;
         ItemizedCosts[2] = BrokerCommission;
         ItemizedCosts[2] = OrderSwapCharge;
         
         TotalTransactionCost = OrderTransactionCost(ItemizedCosts,ArraySize(ItemizedCosts));
         
         ExecutionSymbol           =  OrderSymbol();
         ConfimationEmailCostData  =  "Initial Investment (Margin Cost) "+AccountCurrency+string(OrderMarginRequirement)+"\n\nSpread Charge: "+AccountCurrency+string(ExecutionSpreadCharge)+"\n\nCommission Charge: "+AccountCurrency+string(BrokerCommission)+"\n\nSwapCharge: "+AccountCurrency+string(OrderSwapCharge)+"\n\nTotal cost for "+string(TicketReference)+" "+AccountCurrency+string(TotalTransactionCost);
         ConfimationEmailGreeting  =  "A "+ConfirmationOrderProperty+" has been successfully placed with your broker on the"+ExecutionSymbol+" "+ExecutionTimeframe+"H Chart at the price of "+ExecutionPrice+"\n\nBelow, you will a cost breakdown for your records, including information pertaining to your broker & their contact details.\n\nIf you have any questions, please raise a ticket with your provider at "+CompanyRaiseTicket;
         ChartURL                  =  ScreenShotCaptureURL(ScreenshotName,TicketReference);
         
         //---
         //Temporaty Test
         double Risk       = OrderOpenPrice()-OrderStopLoss();
         double RiskPow    = MathPow(Risk,2);
         double RiskSqrt   = sqrt(RiskPow);
         double RiskFormat = RiskSqrt/Point;
         
         Print("Test RiskPips: ",RiskFormat);
         
      }
         
   }
   
   if (SendTransactionMessages == 1){
   
      SendMail(ConfirmationOrderProperty+" "+HeaderInformation+" Notification","Dear "+ClientName+"\n\n"+ConfimationEmailGreeting+"\n\n"+ConfimationEmailCostData+"\n\n"+ParamDiagnostics+"\n\nYou can view your screenshot link here:\n\n"+ChartURL+"\n\nEA Version Build: "+eaName+"\n\nYours sincerely\n\n"+CompanyName+"\n\n===========================================================================\nBroker Information\n===========================================================================\n\nBroker Name: "+BrokerName+"\n\nBroker Account Number: "+string(BrokerAccountNumber)+"\n\nAccount Server: "+BrokerAccountServer+"\n\nBroker Contact Address: "+BrokerContactAddress+"\n\nBroker Regulation Information"+BrokerRegData+"\n\nBroker Privacy Policy: "+BrokerPrivacyURL+"\n\nComments & Memos:"+MemoText+"\n\nYou can view the change log & browse all updates: "+GitHubRepo+"\n\nComments:"+FreeTextComment+"\n\n"+FooterNotesForConformationMessage);
      
   } else {
   
      Print("Transactional messages have been turned off.");
   
   }
   
   return;

}