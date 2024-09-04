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

double OrderTransactionCost(double &TransactionCostItem[], int NumberOfItems){

   double ExecutionCost = 0;
      
   for(int i = 0; i < NumberOfItems; NumberOfItems ++){
   
      ExecutionCost += TransactionCostItem[i];
   
   }

   return ExecutionCost;

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

void DeletePairSupensionNotice(){

   ObjectDelete(ChartID_Suspension);

}

void PrintTransactionEvent(string LoggingMessage){

   if (OperationMode == 1){
   
      if(!MessageSent){
      
         Print(LoggingMessage);
         
         MessageSent = True;
         
         //ExpertRemove();
      
      }
   
   }
   
}
