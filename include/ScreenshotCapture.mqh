//+------------------------------------------------------------------+
//|                                           screenshot_capture.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <GlobalNamespace.mqh>
#include <EmailLegalDisclaimer.mqh>
#include <MessagesModule.mqh>
#include <CompanyData.mqh>

string ScreenShotCaptureURL(string FileNamePrefix, int ScreenShotID){
   
   //---
   //The 'ScreenShotID' will either be the Ticket derived from the OrderTicket() function, or the 'AutoGenID'
   string   ChartFileName  = FileNamePrefix+string(ScreenShotID)+".png";
   bool     ScreenShot     = ChartScreenShot(0,ChartFileName,1600,700,ALIGN_RIGHT);
   string   ChartImageURL  = "https://bluecitycapitalmedia.blob.core.windows.net/charts/"+ChartFileName;
  
   if (!ScreenShot) 
      DiagnosticMessaging("Screen Capture Error","Unfortunately there was an error in capturing the chart." ); 
   return ChartImageURL;

}


