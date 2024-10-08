#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <GlobalNamespace.mqh>
#include <ScreenshotCapture.mqh>
#include <CompanyData.mqh>  

string WriteFile(string FileName, string ChartCaptureName){
   
   int   FileHandle = 0;
                                       
   ChartCaptureImageURL = ScreenShotCaptureURL(ChartCaptureName,TicketReference); //Return URL              
                        
   if(!FileIsExist(FileName+".csv", FILE_COMMON)){
   
      FileHandle        = FileOpen(FileName+".csv",FILE_COMMON | FILE_READ | FILE_WRITE,',');
      ExecutionSymbol   = OrderSymbol();
      
      FileSeek(FileHandle,0,SEEK_SET); //Find the beginning of the file to write new data
      
      FileWrite(FileHandle,
      "Symbol",
      "OIN",
      "Market Entry Price",
      "Market Exit Price",
      "Swap Charge"
      "Margin Charge",
      "Commission Charge",
      "Gross Profit",
      "Net Profit",
      "Chart Image"); 
                                             
   } else {
   
      FileHandle = FileOpen(FileName+".csv",FILE_COMMON | FILE_READ | FILE_WRITE,',');
     
      FileSeek(FileHandle,0,SEEK_END); //Find the end of the file to write new data

   }
   
   FileWrite(FileHandle,
   ExecutionSymbol,
   TicketReference,
   MarketEntryPrice,
   MarketExitPrice,
   OrderSwapCharge,
   OrderMarginRequirement,
   BrokerCommission,
   PositionGrossProfit,
   PositionNetProfit,
   ChartCaptureImageURL); 
   
   FileClose(FileHandle); //Close the file
   
   //---
   //DUBUGGING PURPOSES
   Print(ChartCaptureImageURL);
   Print(FileName);
   Print("File Entry Written for #", string(TicketReference));
   //---
   
   if(FileHandle == INVALID_HANDLE){
         
      DiagnosticMessaging("FileWrite Error","There was an error in writing the file entry for the order "+string(TicketReference));
   
   } 


return ChartCaptureImageURL;

}



void ConfirmationEmail(string data, int type){

   SendMail(HeaderInformation+"Testing","Dear User \n\nHello, this is the data "+data);


   return;

}





