//+------------------------------------------------------------------+
//|                                               RunDiagnostics.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <GlobalNamespace.mqh>
#include <CompanyData.mqh>
#include <ClientData.mqh>
#include <CheckLicence-001.mqh>
#include <FileWrite.mqh>
#include <FunctionsModule.mqh>

string FooterNotes = LegalFooterDisclaimer();

void DiagnosticMessaging(string ErrorMessageSubject, string ErrorMessageExplaination){

   //If DEBUG is on
   if(OperationMode == 1){
   
      if(!MessageSent){
   
         if(GetCurrentErrorCode == 0){
         
            GetCurrentErrorCode = 999999;
            
            Print("You have received a #"+string(GetCurrentErrorCode)+" code because you have either configured the software in a way that goes against certain parameters, or the Error Logging System has failed to reinitialise");
            
         }
               
         Print(ErrorMessageExplaination + " Please quote error #"+string(GetCurrentErrorCode)+" and contact us at "+CompanyEngineeringTicket);
         
         SendMail(ErrorMessageSubject+" (Error #"+string(GetCurrentErrorCode)+") "+HeaderInformation,"Dear "+ClientName+"\n\n"+ErrorMessageExplaination+"\n\nA copy of this message, along with error code "+string(GetCurrentErrorCode)+" has also been sent to the logging console of your Terminal\n\n"+CompanyHelpInstructions+"\n\n"+FooterNotes);
         
         GetCurrentErrorCode = 0;
         
         ResetLastError(); 
         
         MessageSent = True;
      
      }
   
   }
   
   return;
   
}

void TransactionMessage(string TransactionMessageSubject, string TransactionMessageBody){

   Print(TransactionMessageBody);
   
   if(SendTransactionMessages == 1){
   
      SendMail(TransactionMessageSubject+HeaderInformation,"Dear "+ClientName+"\n\n"+TransactionMessageBody+"\n\n"+CompanySignOff+"\n\n"+FooterNotes);

   }

   return;

}

void PrintStuff(string PrintMessage, int MessageID){

   Print(PrintMessage+" MessageID: "+string(MessageID));

}

void TesterUCID(){

   Print("Your UCID is from the external page is ",UniqueChartIdentifier);

   return;

}

int PopupMessaging(string BoxHeader, string MessageText, int Flags){

   //Req params:
   //BoxHeader: string, "BoxHeader"
   //MessageText: string, "MessageText"
   //Flags: int, MessageBox flags 
   
   return MessageBox(MessageText, BoxHeader+" "+HeaderInformation, Flags);

}

void ObjectNotFoundMessage(string ChartObject){

   SendMail("Object Error ("+string(GetCurrentErrorCode)+") "+HeaderInformation,"Dear "+ClientName+"\n\nUnfortunately, the the chart object "+ChartObject+" has not been found. Please check this again.\n\nIf you have any further issues, please contact "+CompanyEngineeringTicket+" & report error#"+string(GetCurrentErrorCode)+"\n\nYours sincerely\n\n"+CompanyName+"\n\n"+FooterNotes);

   //Please delete when PriceDataAttr.mqh is delated.

}
 
void PosLiquidationConfirmation(){

      int i = 0;
      
      if(stcOrdOldArr[i].type <= 1)
               //we can't use profit and close price, lots and commentary (for partial close) from the dOrdOldArr, because we need their after close values
               if(OrderSelect(stcOrdOldArr[i].ticket, SELECT_BY_TICKET))
                 {
                  string sKindOfExit = "";
                  if((OrderType() == OP_BUY && OrderClosePrice() <= stcOrdOldArr[i].sl) || (OrderType() == OP_SELL && OrderClosePrice() >= stcOrdOldArr[i].sl && stcOrdOldArr[i].sl > 0) || StringFind(OrderComment(), "[sl]") >= 0)
                     sKindOfExit = " at StopLoss"; //close by sl
                  else
                     if((OrderType() == OP_BUY && OrderClosePrice() >= stcOrdOldArr[i].tp && stcOrdOldArr[i].tp > 0) || (OrderType() == OP_SELL && OrderClosePrice() <= stcOrdOldArr[i].tp) || StringFind(OrderComment(), "[tp]") >= 0)
                        sKindOfExit = " at TakeProfit"; //close be tp
                     else
                       { }         //ordinary close
                           
                                 if(SendTransactionMessages == 1){
                                 
                                           //filenameMode  =  3;
                                           //myURL         =  closing_filewrite_function();
                                    //string disclaimer    =  email_disclaimers();
                                    
                                    SendMail(HeaderInformation+"Trade Notification Email for #"+IntegerToString(OrderTicket()),"Order #"+IntegerToString(OrderTicket())+" has been closed "+sKindOfExit+" on the account "+AccountName()+" "+AccountServer()+
                                    "\n"+
                                    "\nThe order exit price for this trade is "+DoubleToStr(OrderClosePrice(),_Digits)+" with a net - as per the account ledger - "+(OrderProfit()>=0?"profit":"loss")+" of "+accountCurrency+DoubleToStr((OrderProfit() + OrderCommission() + OrderSwapCharge),2)+
                                    "\n"+
                                    "\nThere is also a swap "+(OrderSwapCharge > 0 ? "income":"charge")+" of "+accountCurrency+DoubleToStr(OrderSwapCharge,2)+" which is included in profit/loss above"+
                                    "\n"+
                                    "\nAn additional cost of this trade is your lovely commission charge of "+accountCurrency+DoubleToStr(OrderCommission(),2)+
                                    "\n"+
                                    "\n======================="+
                                    "\n"+
                                    "\nThis is the URL link to the chart screenshot."+
                                    "\n"+ 
                                    "\n"+FooterNotes);
                                    
                                 }
                        
                                 else {
                                 
                                    Print("Close Confirmation Email has been turned off for testing purposes.");
                                 
                                 }
                                 
                                 DeletePositionCartObjects();
                                 
                                 SendNotification("Ticket #"+IntegerToString(OrderTicket())+" has closed with a "+(OrderProfit()>=0?"profit":"loss")+" of "+DoubleToStr(OrderProfit(),2)); 
   
                                    //filewrite_function();
                                 
                                 
                 
                 }

               else
               
                 { }   //order not found

            if(stcOrdOldArr[i].type > 1) { }       //pending order is deleted

      
      WriteFile(string(BrokerAccountNumber),"Closed-Positions");        
}

int Function(int a, int b){ //comment

   return a * b;

}

