//+------------------------------------------------------------------+
//|                                              FunctionsModule.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <MessagesModule.mqh>
#include <GlobalNamespace.mqh>
#include <ConfirmationMessage.mqh>

double OrderTransactionCost(double &TransactionCostItem[], int NumberOfItems){

   double ExecutionCost = 0;
      
   for(int i = 0; i < NumberOfItems; i++){
   
      ExecutionCost += TransactionCostItem[i];
   
   }

   return ExecutionCost;

}

void VariableInitialization(){

   MessageSent             =  False;
   BarTime                 =  Time[0];

   return;

}

void GetHighestofLowestPrice(){

   double   OpenClose[2]; 
   
   OpenClose[0] = HammerHeadOpen;                                         
      
   OpenClose[1] = HammerHeadClose;                                                
                                                                              
   HighestofOpenOrClose = NormalizeDouble(OpenClose[ArrayMaximum(OpenClose,WHOLE_ARRAY,0)],Digits);                    
            
   LowestOfOpenOrClose = NormalizeDouble(OpenClose[ArrayMinimum(OpenClose,WHOLE_ARRAY,0)],Digits);
   
}

void DislayServerTime(){

   string TimeWithMinutes = TimeToStr(TimeLocal(),TIME_DATE | TIME_SECONDS);
   
   Comment(TimeWithMinutes);

}

void ErrorReset(){

   ResetLastError();
   Print("Resetting Error Logging Systems...");
   GetLastError();
   GetCurrentErrorCode = 0;
   
   if(GetLastError()  != 0){
   
      DiagnosticMessaging("Error Logging Systems Not Reset","There was an error in resetting the logging system on system initialisation.\n\nThe last error code still remained at "+string(GetLastError())+" The error logging system should not be reset");
      
   } else {
   
      Print("Error Logging Systems Successfully Reset");
         
   }

}

int FileNameIDGenerator(int LowerBand, int UpperBand){

   MathSrand(GetTickCount());
   
   return LowerBand + MathRand() % (UpperBand - LowerBand + 1);

}

void DeletePositionCartObjects(){
      
   ObjectDelete(ChartID_CloseButton); 
   ObjectDelete(ChartID_Breakeven);
   ObjectDelete(ChartID_ModifyTakeProfit);
   ObjectDelete(ChartID_PipDisplayFluid); 
   ObjectDelete(ChartID_PipDisplayStatic); 
   ObjectDelete(ChartID_SpreadDisplay);

   return;

}

void ChartIDExtTest(){

   Print("Your Unique Chart Identifier - sourced externally - is ",UniqueChartIdentifier);

}

void DeletePairSupensionNotice(){

   ObjectDelete(ChartID_Suspension);

}

void PrintTransactionEvent(string LoggingMessage){

   if (DebugMode == DebugOn){
   
      if(!MessageSent){
      
         Print(LoggingMessage);
         
         MessageSent = True;
      
      }
   
   }
   
}

void PrintDebugMessage(string DebugMessage){

   if(DebugMode == DebugOn){
   
      if(!MessageSent){
         
         Print(DebugMessage);
         
         MessageSent = True;
      
      }
   
   }

}
