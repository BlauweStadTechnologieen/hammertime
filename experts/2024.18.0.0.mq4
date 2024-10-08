//+------------------------------------------------------------------+
//|                           Stop! Hammer Time Can't Touch This.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
//|   Copyright (C) 2011-2022, Blue City Capital Investments Limited |
//|                                   developers@bluecitycapital.com |

//---
// There will be descrptions for each module declared, and the formatting
// will be as follows:
//
//    //---
//    //   ##<ModuleName>();##
//    //   <Module description>
//    //---
//
// All variables and module names are named to the Pascal naming convention, unless otherwise requried.
// by the nature of coding language convention.
//
// MON = Msrket Order Notification
// PON = Pending Order Notification
// TNM = Trade Notification Message
// TNE = Trade Notification Email
//---

//---
//PROPERTY FUNCTIONS
#property strict
#property version "224.153"
#property description "Blue City Capital Technologies, Inc"
#property description "8 The Green Dover Kent County Delaware 19901"
#property copyright "Copyright 2011-2024 | Blue City Capital Technologies, Inc"
#property link "https://www.bluecitycapital.com"
#property script_show_inputs
//---

//---
//DEFINE FUNCTIONS
#define  __STRATEGY_MAGIC 1001000000
#define  __SLEEP_AFTER_EXECUTION_FAIL 400
#define  LIC_TRADE_MODES   {ACCOUNT_TRADE_MODE_CONTEST, ACCOUNT_TRADE_MODE_REAL, ACCOUNT_TRADE_MODE_DEMO}
#define  LIC_PRIVATE_KEY   "4238-6600-8341-4193-7156" 
#define  LIC_EXPIRES_DAYS  365
#define  LIC_EXPIRES_START D'2024.01.03'

#define  KEY_ENTER 13
#define  KEY_N 78
#define  KEY_D 68
//---
//---
//INCLUDE FUNCTIONS
#include <stdlib.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
#include <GlobalNamespace.mqh>
#include <CheckLicence-001.mqh>
//---
//These manage the buttons present when a position is executed
#include <ChartButtonStaticAttrs.mqh>
#include <ChartButtonFluidAttrs.mqh>
//---
//This controls the price data displayed on the bottom left orner of the chart.
//#include <PriceDataAttr.mqh>
#include <ChartData.mqh>
//---
#include <PriceChannelModule.mqh>
#include <RunDiagnostics.mqh> 
#include <RunMarketExecution.mqh>
#include <MessagesModule.mqh>
#include <CompanyData.mqh>
#include <OnTickVariables.mqh>
#include <OnInitVariables.mqh>
#include <FunctionsModule.mqh>
//---

int OnInit(){

   MessageSent = False;
 
   OnInitVariables();
   VariableInitialization();
   ChartData();
   ErrorReset();

   GetMarketInfo_PerSymbol(Symbol(), false);
   fEvents(MODE_INIT);
      
   if(DebugMode == 1){  
            
      Print("Generating UCID from OnInit()...");
      Print("Your UCID is "+string(UniqueChartIdentifier));
           
      int ExecuteTestRun = PopupMessaging("Initiate a Test Run","Greetings Grasshopper!\n\nWould you like to initiate test trading position?",MB_YESNO | MB_ICONQUESTION);
      
      if(ExecuteTestRun == 6){
      
         //---
         //if you accept the INITIAL test run confirmation, it will check to ensure that this is a DEMO account
         if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO){
         
            int FinalExecuteTestRunConfirmation = PopupMessaging("Initiating Test Run...","Please confirm that you would like to initiate a test position.",MB_YESNO | MB_ICONWARNING);
         
               if (FinalExecuteTestRunConfirmation == 6){
               
                  //---
                  //If you accept the FINAL confirmation, a test run will execute, complete with confirmation email.
                  ExecuteMarketOrder(1);
                  //---
         
               } else {
              
                  Print ("Cancelled final confirmation");
               
               }
      
         } else {
         
            PopupMessaging("Invalid Account Mode","This feature is compatable only with DEMO accounts. Please switch to a DEMO account before sending a test positon to your broker.", MB_OK | MB_ICONSTOP);
         
         }
   
      } else {
      
         Print("You have cancelled the initial test run");
      
      }
      
      //---
      //If you have turned on transaction emails, a confirmation email will be sent. 
      TransactionMessage("Platform Set to Test Mode","You have set the platform to DEBUG mode. If this was intentional, you can disregard this message.");
      //---
      
      //---
      //The static chart buttons will be drawn
      ChartButtonStaticAttributes();
      //---
   
   } else {
   
      //---
      //This is the Product Licence Key, not the CustomerNumber
      if(!ValidLicence(ProductLicenceKey)) return(INIT_FAILED);
      //--- 
      
      if(PositionsTotal > 0){
      
         for(int i = PositionsTotal - 1; i >=0; i--){
         
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
                           
               if(_OrderMagicNumber == UniqueChartIdentifier){
               
                  ChartButtonStaticAttributes();
               
               } else {
               
                  continue;
               
               }
            
            } else {
            
               DiagnosticMessaging("Order Selection Error OnInit","During the initialization of the system, there was an error in selecting the order(s) from the ledger");
               
               break;
            
            }
         
         }
      
      } else {
      
         DeletePositionCartObjects();
      
      }
   
   }
                  
   if(TempSuspension == 2 && NoTradeReason == 4){
         
      DiagnosticMessaging("Suspension Reason Not Set","You have not set a reason for the temporary suspension.");
      
      return(INIT_FAILED);
   
   } else if (TempSuspension == 1 && NoTradeReason != 4){
   
      DiagnosticMessaging("Suspension Reason Not Reset","You turned off temporary suspension, but you have not reset the reason.");
  
      return(INIT_FAILED);
   
   } else if (TempSuspension == 2 && NoTradeReason != 4){
         
      SuspendedChartObject("Currency Pair Suspended");
      
      TransactionMessage("Suspension Notice","This is a message to confirm that you have suspended the pair "+Symbol());
      
   } else {
   
      DeletePairSupensionNotice();
         
   }

   return(INIT_SUCCEEDED);
         
}


void OnDeinit(const int reason){
  
   ObjectsDeleteAll();
   
}

void OnTick(){
   
   NewBar                  =  (NewBar(Symbol(),PERIOD_CURRENT));
   OnTickVariables();
   DislayServerTime();  
   ChartData();
   GetHighestofLowestPrice(); 
   
   MqlDateTime timeLocStruct;
   TimeToStruct(TimeLocal(), timeLocStruct);
   
   //---
   //Places the appropriate chart buttons and date if a posotion to detected.
   //---

   for(int i = PositionsTotal - 1; i >= 0; i--){
      
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            
         if(_OrderMagicNumber == UniqueChartIdentifier){
            
            ChartButtonFluidAttributes(clrGreen,clrCrimson,clrGray);
            
            AutomatedBreakeven();
         
         } else {
         
            continue;
            
         }   
         
      } else {
         
         DiagnosticMessaging("Order Selection Error","We were unable to select the order from the ledger");
          
         break;
   
      }
      
   }   
      
   if(DebugMode == 1){
   
      ChartButtonFluidAttributes(clrGreen,clrCrimson,clrGray);
      
   } 
   
   //---
   //EA commences...
   //---
   
   if(BarTime != Time[0]){

      if(PositionsTotal == 0){
         
         if(TrendFast < TrendSlow && MomentumFast < MomentumSlow){
         
            if(NewBar){
                
                if (
                    
                     (HammerHead != 0 && RetracementCandle != 0)
                        
                        &&((HammerHead / RetracementCandle) < hammerHeadPct)
                        
                           &&(HammerHead / (HighestofOpenOrClose - HammerLowPrice) <= hammerHandlePct) 
                              
                              &&((TrendCommencementCandle / RetracementCandle) <= retracePercentage)
                              
                                 &&(RetracementCandleClose > RetracementCandleOpen)
                                                           
                )  {
                         
                      if(timeLocStruct.hour >= startingHour && timeLocStruct.hour < endingHour){  
                        
                        if(MarketSpread <= (double)MaximumSpread){
                        
                           if(MarginBuffer <= RemainingMargin){
                           
                              if(_TimeCurrent < Time[0] + (Period() * 60)){
                              
                                 if(_AccountEquity / OrderMarginRequirement * 100 >= brokerMarginLevel){
                                    
                                    if(RSq >= (double)minRSquared && RSq <= (double)maxRSquared){
                                    
                                       if(DebugMode == DebugOff){ 
                                       
                                          if(TempSuspension != Temporary_Suspension && NoTradeReason == No_Suspension){
                                          
                                             if(AutomationAllowed){
                                          
                                                if(StDev >= (double)MinimumStandardDeviation && StDev <= (double)MaximumStandardDeviation){
                                                
                                                   if(IsCurrencyVolatile){
                                                    
                                                      if(HammerHead >= (double)minimumHammerBody){
                                                      
                                                         ExecuteMarketOrder(1);
                                                                                                                  
                                                      } else {
                                                      
                                                         RunDiagnostics();
                                                      
                                                      }
                                                   
                                                   } else {
                                                   
                                                      ExecuteMarketOrder(1);
                                                   
                                                   }
                                                
                                                } else {
                                                
                                                   RunDiagnostics();
                                                
                                                }
                                             
                                             } else {
                                             
                                                RunDiagnostics();
                                             
                                             }
                                          
                                          } 
                                          
                                          else { 
                                          
                                             RunDiagnostics();
                                           
                                          }
                                       
                                       }
                                       
                                       else {
                                       
                                          RunDiagnostics();
                                       
                                       }
                                    
                                    } 
                                    
                                    else {
                                    
                                       RunDiagnostics();

                                    }
                                                                                          
                                 } 
                  
                                 else {
                                 
                                    RunDiagnostics();
                                 
                                 }        
                     
                              }
                  
                              else {
                              
                                 RunDiagnostics();
                              
                              }          
                           
                           } 
                  
                           else {
                           
                              RunDiagnostics();
                           
                           }
                     
                        } 
                  
                        else {
                        
                           RunDiagnostics();
                           
                        }
                        
                      }
                        
                      else {
                     
                        RunDiagnostics();
                     
                      }
                     
                   } 
            
            }
      
         } 
   
      }
            
   }
   
   if(BarTime != Time[0]){ 
      
      if(PositionsTotal == 0){ 
                  
         if(TrendFast > TrendSlow && MomentumFast > MomentumSlow){
         
            if(NewBar){
      
               if (
                       
                     (HammerHead != 0 && RetracementCandle != 0)
                     
                        &&((HammerHead / RetracementCandle) < hammerHeadPct)
                     
                           &&(HammerHead / (HammerHighPrice - LowestOfOpenOrClose) <= hammerHandlePct)
                      
                              &&((TrendCommencementCandle / RetracementCandle) <= retracePercentage)
                              
                                 &&(RetracementCandleClose < RetracementCandleOpen)
                                                           
               )   {
      
                      if(timeLocStruct.hour >= startingHour && timeLocStruct.hour < endingHour){   
                        
                        if(MarketSpread <= (double)MaximumSpread){
                        
                           if(MarginBuffer <= RemainingMargin){
                                                                                       
                              if(_TimeCurrent < Time[0] + (Period() * 60)){
                              
                                 if(_AccountEquity / OrderMarginRequirement * 100 >= brokerMarginLevel){
            
                                    if(RSq >= (double)minRSquared && RSq <= (double)maxRSquared){
                                    
                                       if(DebugMode == DebugOff){
                                        
                                          if(TempSuspension != Temporary_Suspension && NoTradeReason == No_Suspension){
                                                                                                                                                                                                            
                                             if(AutomationAllowed){
                                             
                                                if(StDev >= (double)MinimumStandardDeviation && StDev <= (double)MaximumStandardDeviation){
                                                
                                                   if(IsCurrencyVolatile){
                                                   
                                                      if(HammerHead >= (double)minimumHammerBody){
                                                      
                                                         ExecuteMarketOrder(0);
                                                      
                                                      } else {
                                                      
                                                         RunDiagnostics();
                                                      
                                                      }
                                                   
                                                   } else {
                                                   
                                                      ExecuteMarketOrder(0);
                                                                                                            
                                                   }
                                                
                                                } else {
                                                
                                                   RunDiagnostics();
                                                
                                                }
                                                
                                             }  
                                             
                                             else {
                                             
                                                RunDiagnostics();
                                             
                                             }
                                             
                                          } 
                                          
                                          else {
                                          
                                             RunDiagnostics();
                                          
                                          }
                                       
                                       }
                                       
                                       else {
                                       
                                          RunDiagnostics();
                                       
                                       }
                                    
                                    } 
                                    
                                    else{
                                    
                                       RunDiagnostics();
                                    
                                    }
                           
                                 } 
                                 
                                 else {
                                 
                                    RunDiagnostics();
                                                                                 
                                 }
                              
                              } 
                              
                              else {
                        
                                 RunDiagnostics();
                        
                              }
                           
                           }
                           
                           else {
                           
                              RunDiagnostics();  

                           }
                        
                        } 
                        
                        else { 
                     
                           RunDiagnostics();
            
                        }
                        
                      } 
                     
                      else {
                     
                        RunDiagnostics();
                     
                      }
            
                   }
         
            } 
         
         } 
      
      }
      
   }
      
   fEvents(MODE_WORK);

  }
  
//---
//##AutomatedBreakeven()##
//This function will determine and assess the status of the position,
//the order type and what to look out for.
//One this has been determined, control will then pass to the AutomatedBreakevenExecution(..)
//module, where it will either return true if the positon has been successfully modifies,
//or false if the position has failed to be modified. If you're in debug mode, you will
//receive a diagnostic message with an error code.
//---
void AutomatedBreakeven(){
      
      double _Ask             =  Ask;
      double _Bid             =  Bid;
      
      if(_OrderOpenPrice != _OrderStopLoss){
      
         double BreakevenPrice   = 0;
         
         if(OrderType() == OP_BUY){
         
            BreakevenPrice = NormalizeDouble(_OrderOpenPrice + (breakeven * Point), Digits);
             
            if(_Bid > BreakevenPrice){
            
               AutomatedBreakevenExecution(_OrderOpenPrice);
            
            }
         
         } else if (OrderType()  == OP_SELL){
         
            BreakevenPrice = NormalizeDouble(_OrderOpenPrice - (breakeven * Point), Digits);
            
            if(_Ask < BreakevenPrice){
            
               AutomatedBreakevenExecution(_OrderOpenPrice);
            
            }
         
         }
         
      }

}


bool AutomatedBreakevenExecution(double ModifiedStopLoss){
 
      _OrderTakeProfit =  OrderTakeProfit();
      WebColors        =  clrDarkGoldenrod;
      
      if(!OrderModify(_OrderTicket,_OrderOpenPrice,ModifiedStopLoss,_OrderTakeProfit,0,WebColors)){
      
         DiagnosticMessaging("Automated Order Modification Error","Unfortunately, there was an error in modifying order #"+string(_OrderTicket));
      
         return false;
      
      }
      
   return true;

}

double Transform(double Value, int Transformation){

   static double pipSize = 0;
   if(pipSize == 0)
      pipSize = Point * (1 + 9 * (Digits == 3 || Digits == 5));

   switch(Transformation){

      case 0:
         return(Value/Point);
      case 1:
         return(Value/pipSize);
      case 2:
         return(Value*Point);
      case 3:
         return(Value*pipSize);
      default:
         return(0);

    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTime(int startHour, int endHour, int startMinute, int endMinute)
  {

   if(startHour < 0 || startHour > 23 || endHour < 0 || endHour > 23 ||
      startMinute < 0 || startMinute > 59 || endMinute < 0 || endMinute > 59)
      return false;

   int startTime = startHour*60 + startMinute;
   int endTime = endHour*60 + endMinute;
   int time = Hour()*60 + Minute();

   if(startTime < endTime)
      return (time >= startTime && time <= endTime);
   else
      if(startTime > endTime)
         return (time >= startTime || time <= endTime);
      else
         return (time == startTime);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewBar(string SYMBOL,ENUM_TIMEFRAMES TIMEFRAME){

   datetime time[1];
   static datetime lastbartime = 0;
   
   if(CopyTime(SYMBOL,TIMEFRAME,0,1,time)<1)
   return(false);
   
   if(time[0]!=lastbartime){
   
      lastbartime = time[0];
      return(true);
   
   }
   
   return(false);

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void GetMarketInfo_PerSymbol(string brokerSymbol, bool showPrint)
  {
   double digits = MarketInfo(brokerSymbol, MODE_DIGITS);

// Broker Ratio
   broker_ratio = 1;
// Adjust for five (5) digit brokers.
   if(digits == 5 || digits == 3)
     {
      broker_ratio = 10;
     }
   if(showPrint)
      Print("Broker Ratio: " + DoubleToStr(broker_ratio,0));

// Broker Minimum permitted amount of a lot.
   broker_lot_min  = MarketInfo(brokerSymbol,MODE_MINLOT);
   if(showPrint)
      Print("Broker Minimum permitted amount of a lot: " + DoubleToStr(broker_lot_min,2));

// Maximum permitted amount of a lot.
   broker_lot_max  = MarketInfo(brokerSymbol,MODE_MAXLOT);
   if(showPrint)
      Print("Broker Maximum permitted amount of a lot: " + DoubleToStr(broker_lot_max,2));

// Step for changing lots.
   broker_lot_step = MarketInfo(brokerSymbol,MODE_LOTSTEP);
   if(showPrint)
      Print("Broker Step for changing lots: " + DoubleToStr(broker_lot_step,5));

// Lot size in the base currency.
   broker_contract = MarketInfo(brokerSymbol,MODE_LOTSIZE);
   if(showPrint)
      Print("Broker Lot size in the base currency: " + DoubleToStr(broker_contract,5));

// Stop level in points.
   broker_stop_level = MarketInfo(brokerSymbol,MODE_STOPLEVEL);
   if(showPrint)
      Print("Broker Stop Level: " + DoubleToStr(broker_stop_level,5));

// Order freeze level in points. If the execution price lies within the range defined by the freeze level, the order cannot be modified, cancelled or closed.
   broker_freeze_level = MarketInfo(brokerSymbol,MODE_FREEZELEVEL);
   if(showPrint)
      Print("Broker Freeze Level: " + DoubleToStr(broker_freeze_level,5));

//Point size in the quote currency. For the current symbol, it is stored in the predefined variable Point.
   broker_point = MarketInfo(brokerSymbol,MODE_POINT)*broker_ratio;
   if(showPrint)
      Print("Broker Point: " + DoubleToStr(broker_point,Digits));
  }
//+------------------------------------------------------------------+
//| forexmts, forexmts@mail.ru, v4.0vs-                              |
//| Order accounting function,                                       |
//| current state is stored in dOrdNewArr array                      |
//| previous state is stored in dOrdOldArr array                     |
//+------------------------------------------------------------------+
void fOrders()
  {
   int iQuant = 0;                          //orders counter initialization

   ArrayResize(stcOrdOldArr, ArraySize(stcOrdNewArr));   //resize old array according to new array size
   ArrayCopy(stcOrdOldArr, stcOrdNewArr);                //save new array to old array
   ArrayResize(stcOrdNewArr, 0);
   ArrayResize(sOrdOldArr, ArraySize(sOrdNewArr));       //resize old array according to new array size
   ArrayCopy(sOrdOldArr, sOrdNewArr);                    //save new array to old array
   ArrayResize(sOrdNewArr, 0);

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol && OrderMagicNumber() == Period())
        {
         if(ArraySize(stcOrdNewArr) <= iQuant)         //add index to array if necessary
           {
            ArrayResize(stcOrdNewArr, iQuant+1, 10);
            ArrayResize(sOrdNewArr, iQuant+1, 10);
           }

         stcOrdNewArr[iQuant].ticket = OrderTicket();          //order ticket
         stcOrdNewArr[iQuant].magic = OrderMagicNumber();     //order magic number
         stcOrdNewArr[iQuant].type = OrderType();            //order type
         stcOrdNewArr[iQuant].lot = OrderLots();            //order volume
         stcOrdNewArr[iQuant].open = OrderOpenPrice();       //order open price
         stcOrdNewArr[iQuant].close = OrderClosePrice();
         stcOrdNewArr[iQuant].profit = OrderProfit()+OrderSwap()+OrderCommission();
         stcOrdNewArr[iQuant].time = OrderOpenTime();
         stcOrdNewArr[iQuant].sl = OrderStopLoss();
         stcOrdNewArr[iQuant].tp = OrderTakeProfit();
         sOrdNewArr[iQuant] = OrderComment();           //order comment

         iQuant++;                                       //order index
        }
     }  //for
   return;
  }
  
//+------------------------------------------------------------------+
//| button config                           |
//+------------------------------------------------------------------+  
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam){

   if(id == CHARTEVENT_OBJECT_CLICK){
   
      if(sparam == ChartID_CloseButton){
                  
         int CloseAllPositions = OrdersTotal();
         
            for(int i = CloseAllPositions - 1; CloseAllPositions >= 0; CloseAllPositions --){
            
               Print("Loop commenced...");
               
                  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
                                                
                     Print("Position selected...");
                     
                        if(_OrderSymbol == CurrentChartSymbol){
                        
                           if(_OrderMagicNumber == UniqueChartIdentifier){
                           
                              if(OrderType() == OP_BUY){
                           
                                 ClosePositionOnCommand(Bid); 
                                                                                       
                              } else if (OrderType() == OP_SELL){
                              
                                 ClosePositionOnCommand(Ask); 
                                                            
                              }
                           
                           } else {
                           
                              continue;
                           
                           }
                        
                        } 
                  
                  } else {
                  
                     PrintTransactionEvent("There was an error in "+string(CloseAllPositions)+" selecting the order from the ledger when attempting to close your position");
                     
                     break;
                  
                  }
            
            }

      }
      
      if(sparam == ChartID_Breakeven){
      
         _OrderTakeProfit = OrderTakeProfit();
         
         for(int ModifyAllPositions = PositionsTotal - 1; ModifyAllPositions >= 0; ModifyAllPositions--){
         
            if(OrderSelect(ModifyAllPositions, SELECT_BY_POS, MODE_TRADES)){
            
               if(_OrderSymbol != CurrentChartSymbol && _OrderMagicNumber != UniqueChartIdentifier){
               
                  Print("Moving to next order...");
                  
                     continue;
               
               } else {
               
                  if(_OrderStopLoss != _OrderOpenPrice){
                     
                     double NewSLPrice = _OrderOpenPrice;
                     
                     if(!OrderModify(_OrderTicket,_OrderOpenPrice,NewSLPrice,_OrderTakeProfit,0,clrNONE)){
                           
                        DiagnosticMessaging("Order Modifiation Error","Unfortunately there was an error in changing your StopLoss price for order #"+string(OrderTicket()));
                              
                           continue;
                  
                     } else {
                     
                        PopupMessaging("Order Successfully Modified","The order #"+string(OrderTicket())+" has been successfully modified.", MB_OK | MB_ICONINFORMATION);
                        
                           Print("Moving onto next order...");
                     
                     }
               
                  } else {
                  
                     PopupMessaging("Position Modification","The order #"+string(OrderTicket())+" has either already been modified, or no new stop loss price was specified.",MB_OK | MB_ICONWARNING);
   
                        Print("Moving onto next order...");
                        
                           continue;
                  
                  }
               
               }
      
            } else {
            
              PrintTransactionEvent("There was an error in "+string(_OrderTicket)+" selecting the order from the ledger when attempting to modify your position to breakeven price.");
                            
              break;
            
            }
      
         }

      }

      if(sparam == ChartID_ModifyTakeProfit){
      
         _OrderTakeProfit = OrderTakeProfit();
         
         for(int ModifyAllPositions = PositionsTotal - 1; ModifyAllPositions >= 0; ModifyAllPositions --){
         
            if(OrderSelect(ModifyAllPositions, SELECT_BY_POS, MODE_TRADES)){
            
               if(_OrderMagicNumber != UniqueChartIdentifier && _OrderSymbol != CurrentChartSymbol){
               
                  continue;
               
               } else {
               
                  if(OrderType() == OP_BUY){
                  
                     NewTP =  _OrderTakeProfit + (TPIncrement * Point);
                     
                  } else if (OrderType() == OP_SELL){
                  
                     NewTP =  _OrderTakeProfit - (TPIncrement * Point);
                  
                  }
                  
                  if(!OrderModify(_OrderTicket,_OrderOpenPrice,_OrderStopLoss,NewTP,0,clrNONE)){
                     
                     DiagnosticMessaging("Error in Changing your TakeProfit Price","Unfortunately there was an error in changing the TakeProfit price for order #"+string(OrderTicket()));
                        
                        Print("Error Code after TP change failure "+string(GetCurrentErrorCode));
                              
                           break;
                  
                  } else {
                     
                     PopupMessaging("Order Successfully Modified","The order #"+string(_OrderTicket)+" has been successfully modified",MB_OK | MB_ICONINFORMATION);
                                       
                  }
               
               }
         
            } else {
               
               PrintTransactionEvent("There was an error in "+string(ModifyAllPositions)+" selecting the order from the ledger when changing the TP price.");
               
               break;
            
            }
            
         }
      
      }
   
   } //CHARTEVENT_OBJECT_CLICK

} //void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)

void ClosePositionOnCommand(double ClosurePrice){
             
   if(!OrderClose(_OrderTicket,LotSize,ClosurePrice,300,clrBlueViolet)){
   
      DiagnosticMessaging("Position Closure Error","There was an error in closing position #"+string(_OrderTicket));
      
   } else {
   
      WriteFile(string(BrokerAccountNumber),"ClosedPositions");
            
         DeletePositionCartObjects();
   
   }
   
}

void LoopTester(string EventHandler){

   Print("Initiating Test Loop on ",EventHandler);
   
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
   
      Print("Starting loop to process orders...");
      
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      
         Print("Order ", i, " Ticket Number: ", OrderTicket());
         
      } else {
      
         Print("Failed to select order at index ", i, " | Error: ", GetLastError());
      
      }
   }
   
   Print("Starting test loop for 4 Open Orders");
   
   for(int i = 4 - 1; i >= 0; i--){
   
      Print("Position #", i);
   
   }
   
   for(int i = 0; i < 4; i++){
   
      Print("Reverse position with decrement #", i);
   
   }
   
   // Print the end of the loop
   Print("Test Loop completed on ",EventHandler);


}

bool SuspendedChartObject(string ObjectTextDisplay){

   ObjectCreate(0,ChartID_Suspension,OBJ_LABEL,0,0,0 );
                
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_XDISTANCE, 20);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_XSIZE, 400);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_YDISTANCE, VerticalDistance + 90);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_YSIZE, 100);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_COLOR,clrRed);
   
   ObjectSetInteger(0,ChartID_Suspension, OBJPROP_FONTSIZE,ChartObjectFontSize);

   if(!ObjectSetString(0,ChartID_Suspension, OBJPROP_TEXT,ObjectTextDisplay)){
   
      DiagnosticMessaging("Chart Object Not Found","There has been an error in finding the relevant chart object");
      
            return false; 
   
   }
      
   return true;

}


//+------------------------------------------------------------------+
//| forexmts, forexmts@mail.ru, v4.0vs-                              |
//| Events function,                                                 |
//| detects changes in orders list                                   |
//+------------------------------------------------------------------+
void fEvents(ENUM_FUNCTION_MODE enMode){
   
   if(enMode == MODE_INIT){
   
      fOrders();
      
      return;
      
     }

   if(enMode == MODE_WORK){
      
      bool bFoundFlag;
      fOrders();
      //existing orders check
      for(int i = 0; i < ArraySize(stcOrdOldArr); i++)  //search all orders from the old array
        {
         bFoundFlag = false;
         for(int j = 0; j < ArraySize(stcOrdNewArr); j++) //.. in the new array
           {
            if(stcOrdOldArr[i].ticket == stcOrdNewArr[j].ticket)  //found by ticket
              {
               if(stcOrdOldArr[i].type != stcOrdNewArr[j].type) { } //but the type has changed
               if(stcOrdOldArr[i].sl != stcOrdNewArr[j].sl) { }  //SL was changed
               if(stcOrdOldArr[i].tp != stcOrdNewArr[j].tp) { }  //TP was changed

               bFoundFlag = true;
               break;                              //stop searching in the new array
              }
           }

         if(bFoundFlag == false)                  //order wasn't found
           {
            if(bFoundFlag == false) {                 //order wasn't found
           
               PosLiquidationConfirmation();
                                                      
           }

           }
        }

     }
  }

//+------------------------------------------------------------------+
