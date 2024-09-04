 //+------------------------------------------------------------------+
//|                                              marketExecution.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//#define __SLEEP_AFTER_EXECUTION_FAIL 500

#include <GlobalNamespace.mqh>
#include <RunMarketExecution.mqh> 
#include <RunFailedExecution.mqh>
#include <MessagesModule.mqh> 

bool UserInitSellOrder(){

   if(PendingOrderOption == 1){
 
      int orderMode = MessageBox("Would you like to place a Market (Spot Price) Order?",emailHeaderSubject+"Order Execution Mode",MB_YESNOCANCEL | MB_ICONQUESTION);
     
         //---
         //A market order will be executed and a MON will be sent
         if(orderMode == IDYES){ 
         //---
         
            ExecuteMarketOrder(0);
   
         } else if (orderMode == IDNO){ //Yes, I would like to place a Pending Order. This will generate a PON.
         
            static int  tryouts              =  0;
            double      stoplevel            =  _Point*MarketInfo(_Symbol, MODE_STOPLEVEL);
            double      freezelevel          =  _Point*MarketInfo(_Symbol, MODE_FREEZELEVEL);
            double      op                   =  NormalizeDouble(Open[0],_Digits);
         
            if(op>=Close[0]){
         
               //---
               //MessagesModule.mqh
               InvalidPendingOrderPrice(); 
               //---
                             
                  return false;
               
            }  
            
            while (true){
            
               RefreshRates();
               
                  op=NormalizeDouble(Open[0],_Digits);
            
                     if(CurrentBarOpenPrice>=Close[0]-stoplevel){
                     
                        InvalidPendingOrderPrice(); 
                        
                           return false;
            
                     }
         
                     //-- modify -------------------------------------------------------
               
                     ResetLastError();
                     
                     PendingOrderStopLoss    =  op + (pipStopLoss * Point);
                     PendingOrderTakeProfit  =  op - ((pipStopLoss * RewardFactor) * Point);
                     
                        int success = OrderSend(Symbol(),OP_SELLSTOP,LotSize,op,0,PendingOrderStopLoss,PendingOrderTakeProfit,"CFPO",Period(),CandleOpenTime + PendingExpiration,sellcolor);
         
                     //-- error check --------------------------------------------------
               
                     if(success == -1){
                        
                        tryouts++;
                        
                           if(tryouts>=10){
                           
                              tryouts=0;
                           
                                 Print("<!>___",__LINE__," OrderSend failed with Error: " + (string)GetLastError());
                                 
                                    RunFailedExecution();
                                    
                                       return false;
                                 
                           }  else  {
                           
                              Print("<!>___",__LINE__," OrderSend error " + (string)GetLastError() + ", retry #"+(string)tryouts+" of 10");
                              
                                 continue;
                              
                          }
                          
                     } else {
                     
                        //---
                        ////UserInitExecution.mqh
                        PendingConfMessage(); 
                        //---
                        
                           Print("This has been successfully Executed by the UserInitExecution module");
                           
                              Print("<!>___",__LINE__," OrderSend success");
                              
                                 eaCode = 5; //eaCode converted to 5 in prepared for when the order is convered froma pending to a market.
                        
                                    printf("The eaCode as been convered to %d", eaCode);//This is a temporary print confirmation
                                 
                                       break;
                                          
                     }
                     
            break;
                     
            }  //while loop
         
         } else if (orderMode == IDCANCEL) { //If user presses "Cancel".
         
            //---
            //MessagesModule.mqh
            OrderCancelled();
            //---
            
   
         } 
      
   } else { //If pending order option has been switched off, this will revert to a Market Order. This will generate a MON.
      
      //---
      //This is the return code of a short market (spot price) order
      ReturnCode = 202312300;
      //---
            
         //---
         //The eaCode will tell the algo to send a manually executed MON.         
         eaCode = 3;
         //
         
            //---
            //This will attempt to run a spot market execution, which will return either a success or a failed execution.            
            RunMarketExecution(); 
            //---
      
               //---
               //MessagesModule.mqh
               PendingOrderOptionNotAvail();
               //
      
   }
   
   return true;
   
}
      
bool UserInitBuyOrder(){
   
   if(PendingOrderOption == 1){ 
                  
      int orderMode = MessageBox("Would you like to place a Market (Spot Price) Order?",emailHeaderSubject+"Order Execution Mode",MB_YESNOCANCEL | MB_ICONQUESTION);
   
         if(orderMode == IDYES){ //Yes, I would like to place a Market Order. This will generate a MON.
         
            ExecuteMarketOrder(1);
                  
         } else if (orderMode == IDNO) { 
                        
            static   int   tryouts     =  0;
            double         stoplevel   =  _Point*MarketInfo(_Symbol, MODE_STOPLEVEL);
            double         freezelevel =  _Point*MarketInfo(_Symbol, MODE_FREEZELEVEL);
            double         op          =  NormalizeDouble(Open[0],_Digits);
                        
            if(op<=Close[0]){
   
               InvalidPendingOrderPrice();
               
                  return false;
               
            }
            
            //--- executing the changes
            while(true){
         
               RefreshRates();
               
                  op=NormalizeDouble(Open[0],_Digits);
               
                     if(op<=Close[0]+stoplevel){
                  
                        InvalidPendingOrderPrice();  
                                         
                           return false;
                 
                     }
         
               //-- modify -------------------------------------------------------
               
               ResetLastError();
               PendingOrderStopLoss    = op - (pipStopLoss *  Point);
               PendingOrderTakeProfit  = op + ((pipStopLoss * RewardFactor) * Point);
               
                  int success = OrderSend(Symbol(),OP_BUYSTOP,LotSize,op,0,PendingOrderStopLoss,PendingOrderTakeProfit,"CFPO",Period(),CandleOpenTime + PendingExpiration,buycolor);
         
               //-- error check --------------------------------------------------
               
               if(success == -1){
                  
                  tryouts++;
                  
                     if(tryouts>=10){ 
                        
                        tryouts=0;
                        
                           Print("<!>___",__LINE__," OrderSend failed with Error: " + (string)GetLastError());
                        
                              RunFailedExecution(); //RunFailedExecutio
                              
                                 return false;
                              
                     } else {
                     
                        Print("<!>___",__LINE__," OrderSend error " + (string)GetLastError() + ", retry #"+(string)tryouts+" of 10");
                        
                           continue;
                        
                     }
                  
               } else {
               
                  //---
                  //UerInitExecution.mqh
                  PendingConfMessage(); 
                  //---
                                    
                     Print("<!>___",__LINE__," OrderSend success");
                     
                        eaCode = 5; //eaCode converted to 5 in prepared for when the order is convered froma pending to a market.
                     
                           printf("The eaCode as been convered to %d", eaCode);
                           
                              break;
                        
               }
               
               break;
               
            }
  
         } else if (orderMode == IDCANCEL) { //If user presses "Cancel".
         
            OrderCancelled();
         
         }
   
   } else { //If pending order option has been switched off
   
      //---
      //This is the return code of a long market (spot price) order
      ReturnCode = 202312301;
      //---
      
         eaCode = 3;
         
            RunMarketExecution();
         
               PendingOrderOptionNotAvail();
   
         
   
   }
   
   return true;
      
}

void PendingConfMessage(){

   if(OrderSelect(OrdersTotal()-1, SELECT_BY_POS,MODE_TRADES)){
   
      if(OrderType() >= 2){
      
         eaCode = 4;
      
            MasterConfirmationEmailTemplate();
            
               PrintFormat("The type of order is %d",OrderType());
               
                  PrintFormat("The open price for the order is %f", OrderOpenPrice());
                
      }
   
   }
   
   MessageBox("A pending order was successfully placed on the "+Symbol()+" A PON has been sent.",emailHeaderSubject+"Pending Order Notifiction",MB_OK | MB_ICONINFORMATION);

      Print("A pending order has been placed successfully");

         return;

}



