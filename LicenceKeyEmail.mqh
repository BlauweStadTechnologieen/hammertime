//+------------------------------------------------------------------+
//|                                              LicenceKeyEmail.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <GlobalNameSpace.mqh>
#include <EmailLegalDisclaimer.mqh>
#include <ClientData.mqh>
#include <CompanyData.mqh>


void LicenceKeyEmail(string key){

   SendMail(ClientName +"Here is your your Product License Key.",
   
      "Hello "+ClientName+" & welcome to "+CompanyName+"\n"+
      
      "\nYou will find your Product Licence Key below. It's important that you do not share these keys with anyone."+"\n"+
      
      "\nYour Product Licence Key is: "+key+"\n"+
      
      "\nPlease ensure you have the latest product version."+"\n"+
      
      "\nA new license key will be issued on each new major release of this software. If you are experiencng any issues, please contact our team at hello"+CompanyDomain+
                           
      EmailLegalDisclaimer()
   
   );

}
