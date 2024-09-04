//+------------------------------------------------------------------+
//|                                                      manStat.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <GlobalNamespace.mqh> 

void PermChartObjectsStaticAttr(){
 
   if(ObjectFind("manBuy") < 0){
      
      ObjectCreate(0,"manBuy",OBJ_BUTTON,0,0,0); 
              
         ObjectSetInteger(0,"manBuy",OBJPROP_XDISTANCE,880);
         
            ObjectSetInteger(0,"manBuy",OBJPROP_YDISTANCE,580);
            
               ObjectSetInteger(0,"manBuy", OBJPROP_YSIZE, 40);
               
                  ObjectSetInteger(0,"manBuy", OBJPROP_XSIZE, 200);
            
                     ObjectSetInteger(0,"manBuy", OBJPROP_CORNER,CORNER_LEFT_UPPER);
            
                        ObjectSetInteger(0,"manBuy", OBJPROP_COLOR,clrWhite);
                                                                  
                           ObjectSetInteger(0,"manBuy", OBJPROP_FONTSIZE,10);
                     
                              ObjectSetInteger(0,"manBuy", OBJPROP_BGCOLOR,clrGreen);
                              
                                 ObjectSetInteger(0,"manBuy",OBJPROP_STATE,false); 
   }
                        
   if(ObjectFind("manSell") < 0){   
      
      ObjectCreate(0,"manSell",OBJ_BUTTON,0,0,0); 
              
         ObjectSetInteger(0,"manSell",OBJPROP_XDISTANCE,1150);
         
            ObjectSetInteger(0,"manSell",OBJPROP_YDISTANCE,580);
            
               ObjectSetInteger(0,"manSell", OBJPROP_YSIZE, 40);
               
                  ObjectSetInteger(0,"manSell", OBJPROP_XSIZE, 200);
            
                     ObjectSetInteger(0,"manSell", OBJPROP_CORNER,CORNER_LEFT_UPPER);
            
                        ObjectSetInteger(0,"manSell", OBJPROP_COLOR,clrWhite);
                                                                  
                           ObjectSetInteger(0,"manSell", OBJPROP_FONTSIZE,10);
                     
                              ObjectSetInteger(0,"manSell", OBJPROP_BGCOLOR,clrRed);
                              
                                 ObjectSetInteger(0,"manSell",OBJPROP_STATE,false); 
   }
                               
   if(ObjectFind("spread") < 0){
      
      ObjectCreate(0,"spread",OBJ_LABEL,0,0,0); 
              
         ObjectSetInteger(0,"spread",OBJPROP_XDISTANCE,1100);
         
            ObjectSetInteger(0,"spread",OBJPROP_YDISTANCE,585);
            
               ObjectSetInteger(0,"spread", OBJPROP_YSIZE, 40);
               
                  ObjectSetInteger(0,"spread", OBJPROP_XSIZE, 60);
            
                     ObjectSetInteger(0,"spread", OBJPROP_CORNER,CORNER_LEFT_UPPER);
            
                        ObjectSetInteger(0,"spread", OBJPROP_COLOR,clrBlack);
                                                                  
                           ObjectSetInteger(0,"spread", OBJPROP_FONTSIZE,20);
                           
   }          
}


