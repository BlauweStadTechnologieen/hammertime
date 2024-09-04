#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <GlobalNamespace.mqh>
#include <MessagesModule.mqh>

void ChartButtonStaticAttributes(){

   if(ObjectFind(ChartID_SpreadDisplay) < 0){ //Cannot find the Object.
   
       if(!ObjectCreate(UniqueChartIdentifier,ChartID_SpreadDisplay,OBJ_LABEL,0,0,0 )){ //Cannot create the Object.
   
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_SpreadDisplay);
   
            ResetLastError();
        
       } else { //Create the Object.
      
         ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_XDISTANCE, 20);
            
            ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_XSIZE, 400);
            
               ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_YDISTANCE, 150);
               
                  ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_YSIZE, 100);
                  
                     ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_CORNER,CORNER_LEFT_UPPER);
                                 
                        ObjectSetInteger(UniqueChartIdentifier,ChartID_SpreadDisplay, OBJPROP_FONTSIZE,15);
      
       }

   } // The Object has been found.
      
   if(ObjectFind(ChartID_PipDisplayFluid) < 0){
   
      if(!ObjectCreate(UniqueChartIdentifier,ChartID_PipDisplayFluid, OBJ_TEXT, 0,0,0)){
         
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_PipDisplayFluid);

            ResetLastError();

      } else {
   
         ObjectSetString(UniqueChartIdentifier,ChartID_PipDisplayFluid, OBJPROP_FONT,"Impact");  
         
            ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayFluid, OBJPROP_FONTSIZE,20);
   
      }
   
   } //ObjectFind
         
   if(ObjectFind(ChartID_PipDisplayStatic) < 0){

      if(!ObjectCreate(UniqueChartIdentifier,ChartID_PipDisplayStatic,OBJ_LABEL,0,0,0)){
      
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_PipDisplayStatic);
            
            ResetLastError();
   
      } else {
   
         ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_XDISTANCE, 20);
   
            ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_XSIZE, 400);
   
               ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_YDISTANCE, 100);
   
                  ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_YSIZE, 50);
   
                     ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_CORNER,CORNER_LEFT_UPPER);
                                          
                        ObjectSetString(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_FONT,"Impact");
                     
                           ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_BGCOLOR, clrNONE);
                  
                              ObjectSetInteger(UniqueChartIdentifier,ChartID_PipDisplayStatic, OBJPROP_FONTSIZE,30);

      }

   } // ObjectFind
               
   if(ObjectFind(ChartID_Breakeven) < 0){
   
      if(!ObjectCreate(UniqueChartIdentifier,ChartID_Breakeven,OBJ_BUTTON,0,0,0)){
                         
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_Breakeven);

            ResetLastError();   
   
      }  else {
   
         ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_XDISTANCE, 430);
         
            ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_XSIZE, 100);
     
               ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_YDISTANCE, 40);
     
                  ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_YSIZE, 50);
     
                     ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_CORNER,CORNER_LEFT_UPPER);
      
                        ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_COLOR,clrWhite);
                                                                        
                           ObjectSetInteger(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_FONTSIZE,10);
                           
                              ObjectSetString(UniqueChartIdentifier,ChartID_Breakeven, OBJPROP_TEXT,"Breakeven");  
   
      }
   
   } //ObjectFind
      
   if(ObjectFind(ChartID_ModifyTakeProfit) < 0){
   
      if(!ObjectCreate(UniqueChartIdentifier,ChartID_ModifyTakeProfit,OBJ_BUTTON,0,0,0)){
            
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_ModifyTakeProfit);
 
            ResetLastError();
      
      } else {
      
      ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_XDISTANCE, 540);

         ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_XSIZE, 100);
  
            ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_YDISTANCE, 40);
  
               ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_YSIZE, 50);
  
                  ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
                     ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_COLOR,clrWhite);
                                                                     
                        ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_FONTSIZE,10);
                        
                           ObjectSetInteger(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_BGCOLOR,clrDarkBlue);
                           
                              ObjectSetString(UniqueChartIdentifier,ChartID_ModifyTakeProfit, OBJPROP_TEXT,"Modify TP");   
      } 
   
   } //ObjectFind
               
   if(ObjectFind(ChartID_CloseButton) < 0){
   
      if(!ObjectCreate(UniqueChartIdentifier,ChartID_CloseButton,OBJ_BUTTON,0,0,0 )){
                 
         DiagnosticMessaging("Object Draw Error","There was unfortunately an error when attempting to draw the chart object "+ChartID_CloseButton);
      
            ResetLastError();
   
      } else {
   
         ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_XDISTANCE, 20);
     
            ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_XSIZE, 400);
     
               ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_YDISTANCE, 40);
     
                  ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_YSIZE, 50);
     
                     ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_CORNER,CORNER_LEFT_UPPER);
      
                        ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_COLOR,clrWhite);
                                                                        
                           ObjectSetInteger(UniqueChartIdentifier,ChartID_CloseButton, OBJPROP_FONTSIZE,10);
   
      }
   
   } //ObjectFind
         
}
         

   



