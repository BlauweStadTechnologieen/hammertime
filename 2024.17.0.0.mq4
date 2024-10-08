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
//    // <Module description>
//       <ModuleName>();   
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
//---
//These manage the permanant buttons located at the bottom right corner of the chart.
#include <PermChartObjectsFluidAttr.mqh>
#include <PermChartObjectsStaticAttr.mqh>
//---
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
//#include <TakeProfitCalculation.mqh>
#include <CompanyData.mqh>
#include <FunctionsModule.mqh>
//---


int OnInit(){

   //---
   //This is the Product Licence Key, not the CustomerNumber
   //if(!ValidLicence(ProductLicenceKey)) return(INIT_FAILED);
   //--- 
   
   ChartData();
   
   //---
   //Reset Logging Systems....
   ResetLastError();
   
   Print("Resetting Error Logging Systems...");
   
   GetLastError();
   GetCurrentErrorCode = 0;
   
   if(GetLastError()  != 0){
   
      DiagnosticMessaging("Error Logging Systems Not Reset","There was an error in resetting the logging system on system initialisation.\n\nThe last error code still remained at "+string(GetLastError())+" The error logging system should not be reset");
      
   } else {
   
      Print("Error Logging Systems Successfully Reset");
   
   }
   //---
   
   //---
   //Message Sent Flag
   MessageSent = False;
   //---
   
   GetMarketInfo_PerSymbol(Symbol(), false);
   fEvents(MODE_INIT);
   
   eaName                  =  WindowExpertName();
   symbol                  =  Symbol(); 
   BarTime                 =  Time[0];
   mqlTime                 =  Hour();
   
   if(OperationMode == 1){ // if initialised in TestMode
      
      //---
      //Initiating LoopTest
      LoopTester("OnInit");
      //---
      
      Print("Your Unique Chart Identifier is ",UniqueChartIdentifier);
      
      TesterUCID();
      
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
      
      if(TotalOpenOrders > 0){
      
         for(int i = TotalOpenOrders - 1; i >=0; i--){
         
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
                           
               if(OrderMagicNumber() == UniqueChartIdentifier){
               
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//Local Declaration

   string timeWithMinutes = TimeToStr(TimeLocal(),TIME_DATE | TIME_SECONDS);
      
      Comment(timeWithMinutes);
   
   
   tickvalue                     =  MarketInfo(Symbol(),MODE_TICKVALUE);
   ExchangeRate                  =  1/tickvalue;
   eaName                        =  WindowExpertName();
   currentBid                    =  MarketInfo(Symbol(),MODE_BID);
   currentAsk                    =  MarketInfo(Symbol(),MODE_ASK);
   entryPriceBid                 =  MarketInfo(Symbol(),MODE_BID);
   //entryPriceAsk                 =  MarketInfo(Symbol(),MODE_ASK);
   spread                        =  int(NormalizeDouble((Ask - Bid)/Point,0)); 
   totalSpread                   =  spread * tickvalue * LotSize;
   symbol                        =  OrderSymbol();
   marginBuffer                  =  1000;
   positionCommission            =  OrderCommission();
   positionProfit                =  OrderProfit();
   StopLoss                      =  OrderStopLoss();
   accountBalance                =  AccountBalance();
   accountCurrency               =  AccountCurrency();     
   totalCommission               =  (OrderCommission() * OrderCommission());
   totalCommissionSqrd           =  sqrt(totalCommission);
   mqlTime                       =  Hour();
   currentOpenPrice              =  iOpen(Symbol(),0,0);  
   hammerHeadOpen                =  iOpen(Symbol(),0,1);                                              /*See Diagram notes_to_the_ea*/
   hammerHeadClose               =  iClose(Symbol(),0,1);
   hammerHeadM                   =  NormalizeDouble(sqrt(MathPow(hammerHeadClose - hammerHeadOpen,2)),Digits);
   hammerBody                    =  hammerHeadM / Point;
   retracementCandleOpen         =  iOpen(Symbol(),0,2);
   retracementCandleClose        =  iClose(Symbol(),0,2);
   retracementCandle             =  sqrt(MathPow(retracementCandleClose - retracementCandleOpen,2));
   highM                         =  iHigh(Symbol(),0,1);
   lowM                          =  iLow(Symbol(),0,1);
   initialTrendBullCandle        =  (iClose(Symbol(),0,3) - iOpen(Symbol(),0,3));                     
   initialTrendBearCandle        =  (iOpen(Symbol(),0,3) - iClose(Symbol(),0,3));
   lastErrorCode                 =  IntegerToString(GetLastError());
   trendFast                     =  iMA(NULL,0,Period_TrendFast,0, AM_TrendFast,Applied_Price,1);
   trendSlow                     =  iMA(NULL,0,Period_TrendSlow,0,AM_TrendSlow,Applied_Price,1);
   momentumSlow                  =  iMA(NULL,0,Period_MomentumSlow,0,AM_MomentumSlow,Applied_Price,1);
   momentumFast                  =  iMA(NULL,0,Period_MomentumFast,0,AM_MomentumFast,Applied_Price,1);
   momentumFastCurrent           =  iMA(NULL,0,Period_MomentumFast,0,AM_MomentumFast,Applied_Price,1);
   momentumFastPrevious          =  iMA(NULL,0,Period_MomentumFast,0,AM_MomentumFast,Applied_Price,3);
   engulfingOpen                 =  iOpen(Symbol(),0,1);
   engulfingClose                =  iClose(Symbol(),0,1);
   engulfingCandleHigh           =  iHigh(Symbol(),0,1);
   engulfingCandleLow            =  iLow(Symbol(),0,1);
   pullbackOpen                  =  iOpen(Symbol(),0,2);
   pullbackClose                 =  iClose(Symbol(),0,2);
   pullbackHigh                  =  iHigh(Symbol(),0,2);
   pullbackLow                   =  iLow(Symbol(),0,2);
   initialClose                  =  iClose(Symbol(),0,3);
   initialOpen                   =  iOpen(Symbol(),0,3);
   initial                       =  sqrt(MathPow(initialClose - initialOpen,2));
   engulfingCandle               =  sqrt(MathPow(engulfingOpen - engulfingClose,2));
   pullbackCandle                =  sqrt(MathPow(pullbackOpen - pullbackClose,2));
   pullbackCandleMinimum         =  100 * Point;
   strTempSuspension             =  StringSubstr(EnumToString((NO_TRADE)TempSuspension),0);
   
   //---
   //***PRECIDENCE ORDERING***
   //Margin Management  
   OrderMarginRequirement        =  NormalizeDouble(LotSize * MarketInfo(Symbol(),MODE_MARGINREQUIRED),2);
   CurrentFreeMargin             =  AccountFreeMargin();
   RemainingMargin               =  (CurrentFreeMargin  - OrderMarginRequirement);
   //---
   
   //---
   //Account Information
   AccountNumber                 =  IntegerToString(AccountNumber(),0);
   BrokerAccountNumber           =  AccountNumber();
   //---
   
   ClosePosition                 =  true;
   BuyMod                        =  true;
   SellMod                       =  true;
   NewBar                        =  (NewBar(Symbol(),PERIOD_CURRENT));
   
   //---
   //***PRECIDENCE ORDERING***
   //Transaction Cost Calculations
   MarketSpread                  =  NormalizeDouble((Ask - Bid)/Point,0); 
   ExecutionSpreadCharge         =  NormalizeDouble(MarketSpread * tickvalue * LotSize,2); 
   OrderSwapCharge               =  sqrt(MathPow(OrderSwap(),2));
   BrokerCommission              =  sqrt(MathPow(OrderCommission(),2));
   //---
   
   //---
   //Active Order Variables
   OpeningPrice                  =  OrderOpenPrice();
   TicketReference               =  OrderTicket();
   MarketEntryPrice              =  OrderOpenPrice();
   MarketExitPrice               =  OrderClosePrice();
   //TotalOpenOrders               =  OrdersTotal();
   PositionGrossProfit           =  OrderProfit(); //Without swaps or comms but including spread
   PositionNetProfit             =  NormalizeDouble(PositionGrossProfit - BrokerCommission - OrderSwapCharge,2);
   GetCurrentErrorCode           =  GetLastError();
   SpotAsk                       =  Ask;
   SpotBid                       =  Bid;
   CurrentHigh                   =  iHigh(NULL,0,0);
   CurrentLow                    =  iLow(NULL,0,0);
   CurrentBarOpenPrice           =  iOpen(NULL,0,0);
   //MidPointOpen                  =  iOpen(Symbol(),0,4); 
   //MidPointClose                 =  iClose(Symbol(),0,4);
   //MidPoint                      =  (MidPointOpen + MidPointClose)/2;
   AutomationAllowed             =  IsTradeAllowed();
   PendingExpiration             =  Period() * 60;
   CandleOpenTime                =  Time[0];
   isJPYPresent                  =  StringFind(Symbol(),"JPY",0);
   isGPBAUDPresent               =  StringFind(Symbol(),"GBPAUD",0);
   isEURAUDPresent               =  StringFind(Symbol(),"EURAUD",0);
   isCurrencyPresent             =  (isJPYPresent >= 0 || isGPBAUDPresent >= 0 || isEURAUDPresent >= 0);
   CurrentChart                  =  ChartID();
            
   //+----------------------------------------------------------------------------------------------------------------------+
                                                                                 
   double   OpenClose[2];                                                          
                                                                                 
      OpenClose[0] = hammerHeadOpen;                                              
         
      OpenClose[1] = hammerHeadClose;                                              
                                                                                 
      highestOC = NormalizeDouble(OpenClose[ArrayMaximum(OpenClose,WHOLE_ARRAY,0)],Digits); //Short Positions                     
               
      lowestOC = NormalizeDouble(OpenClose[ArrayMinimum(OpenClose,WHOLE_ARRAY,0)],Digits); //Long Positions
            
   //+----------------------------------------------------------------------------------------------------------------------+

   ChartData();
   
   MqlDateTime timeLocStruct;
               
   TimeToStruct(TimeLocal(), timeLocStruct);
                     
   //+----------------------------------------------------------------------------------------------------------------------+
   
   for(int i = TotalOpenOrders - 1; i >= 0; i--){
      
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            
         if(OrderMagicNumber() == UniqueChartIdentifier){
            
            ChartButtonFluidAttributes(clrGreen,clrCrimson,clrGray);
         
         } else {
         
            continue;
            
         }   
         
      } else {
         
         DiagnosticMessaging("Order Selection Error","We were unable to select the order from the ledger");
         
         break;
   
      }
      
   }   
   
   if(OperationMode == 1){
   
      ChartButtonFluidAttributes(clrGreen,clrCrimson,clrGray);
      
   } 
   
   if(BarTime != Time[0]){

      if(TotalOpenOrders == 0){
         
         if(trendFast < trendSlow && momentumFast < momentumSlow){
         
            if(NewBar){
                
                if (
                    
                     (hammerHeadM != 0 && retracementCandle != 0)
                        
                        &&((hammerHeadM / retracementCandle) < hammerHeadPct)
                        
                           &&(hammerHeadM / (highestOC - lowM) <= hammerHandlePct) 
                              
                              &&((initialTrendBearCandle / retracementCandle) <= retracePercentage)
                              
                                 &&(retracementCandleClose > retracementCandleOpen)
                                                           
                )  {
                         
                      if(timeLocStruct.hour >= startingHour && timeLocStruct.hour < endingHour){  
                        
                        if(MarketSpread <= MaximumSpread){
                        
                           if(marginBuffer <= RemainingMargin){
                           
                              if(TimeCurrent() < Time[0] + (Period() * 60)){
                              
                                 if(AccountEquity() / OrderMarginRequirement * 100 >= brokerMarginLevel){
                                 
                                    if(breakeven * Point >=  stopLoss){
                                    
                                       if(RSq >= minRSquared && RSq <= maxRSquared){
                                       
                                          if(OperationMode == 2){ 
                                          
                                             if(TempSuspension  != 2 && NoTradeReason ==4){
                                             
                                                if(AutomationAllowed){
                                             
                                                   if(StDev >= MinimumStandardDeviation && StDev <= MaximumStandardDeviation){
                                                   
                                                      if(isCurrencyPresent){
                                                       
                                                         if(hammerBody >= minimumHammerBody){
                                                         
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
                        
                      else {
                     
                        RunDiagnostics();
                     
                      }
                     
                   } 
            
            }
      
         } 
   
      }
            
   }
   
   if(BarTime != Time[0]){ 
      
      if(TotalOpenOrders == 0){
                  
         if(trendFast > trendSlow && momentumFast > momentumSlow){
         
            if(NewBar){
      
               if (
                       
                     (hammerHeadM != 0 && retracementCandle != 0)
                     
                        &&((hammerHeadM / retracementCandle) < hammerHeadPct)
                     
                           &&(hammerHeadM / (highM - lowestOC) <= hammerHandlePct)
                      
                              &&((initialTrendBullCandle / retracementCandle) <= retracePercentage)
                              
                                 &&(retracementCandleClose < retracementCandleOpen)
                                                           
               )   {
      
                      if(timeLocStruct.hour >= startingHour && timeLocStruct.hour < endingHour){   
                        
                        if(MarketSpread <= MaximumSpread){
                        
                           if(marginBuffer <= RemainingMargin){
                                                                                       
                              if(TimeCurrent() < Time[0] + (Period() * 60)){
                              
                                 if(AccountEquity() / OrderMarginRequirement * 100 >= brokerMarginLevel){
                                 
                                    if(breakeven * Point >= stopLoss){
            
                                       if(RSq >= minRSquared && RSq <= maxRSquared){
                                       
                                          if(OperationMode == 2){
                                           
                                             if(TempSuspension  != 2 && NoTradeReason == 4){
                                                                                                                                                                                                               
                                                if(AutomationAllowed){
                                                
                                                   if(StDev >= MinimumStandardDeviation && StDev <= MaximumStandardDeviation){
                                                   
                                                      if(isCurrencyPresent){
                                                      
                                                         if(hammerBody >= minimumHammerBody){
                                                         
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
                     
                      else {
                     
                        RunDiagnostics();
                     
                      }
            
                   }
         
            } 
         
         } 
      
      }
      
   }
      
   //---
   //The following sets out the breakeven module, where the pips can be set in the extern variables.
   //This also includes message and functions modules, includes the manual market and pending orders
   //& carious declarations & calculations.
   //---
   
   ordersTotal = OrdersTotal();
   
   for(int s=ordersTotal-1; s>=0; s--){
   
      if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES)){
   
         RefreshRates();
      
         if(OrderTicket() > 0)
         
            if(OrderSymbol() == Symbol()){
          
            double   ask         = Ask;
            double   targetAsk   = 0;
            double   aNewSLPrice = NormalizeDouble(OrderOpenPrice(),Digits);
            
               if(broker_stop_level > breakeven)
            
                  targetAsk = OrderOpenPrice() - ((broker_stop_level+1) * Point);
            
                  else
            
                  targetAsk = OrderOpenPrice() - ((breakeven+broker_stop_level+1) * Point);
                  double   aCurrentSL  =  NormalizeDouble(OrderStopLoss(),Digits);
                  int      aTicket     =  OrderTicket();
            
                     if(OrderType() == OP_SELL)
                     
                        if(ask < targetAsk)
                     
                           if(Symbol()==OrderSymbol())
                     
                              if(DoubleToStr(aNewSLPrice,Digits) != DoubleToStr(aCurrentSL,Digits)){
            
                                 PrintFormat("SellMod OrderOpenPrice %7.5f Ask %7.5f aNewSLPrice %7.5f",OrderOpenPrice(),ask,aNewSLPrice);
               
                                    SellMod = OrderModify(aTicket,OrderOpenPrice(),aNewSLPrice,OrderTakeProfit(),0,sellcolor);
            
                                       if(!SellMod){
                                       
                                          DiagnosticMessaging("Order Modification Error","Unfortunately there was an error in modifying Order #"+string(aTicket));
                                            
                                       }
                                                
                              }
            
            }
                  
      }
      
   }
      
   ordersTotal = OrdersTotal();
   
   for(int b=ordersTotal-1; b>=0; b--){
   
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES)){
      
         RefreshRates();
         
            if(OrderTicket() > 0)
            
               if(OrderSymbol() == Symbol()){
      
                  double   bid         = Bid;
                  double   targetBid   = 0;
                  double   aNewSLPrice =  NormalizeDouble(OrderOpenPrice(),Digits);
            
                     if(broker_stop_level > breakeven)
            
                        targetBid = OrderOpenPrice() + ((broker_stop_level+1) * Point);
      
                        else
      
                        targetBid = OrderOpenPrice() + ((breakeven+broker_stop_level+1) * Point);
      
                        double   aCurrentSL  =  NormalizeDouble(OrderStopLoss(),Digits);
                        int      aTicket     =  OrderTicket();
            
                           if(OrderType() == OP_BUY)
                           
                              if(bid > targetBid)
                           
                                 if(Symbol()==OrderSymbol())
                           
                                    if(DoubleToStr(aNewSLPrice,Digits) != DoubleToStr(aCurrentSL,Digits)){
         
                                       PrintFormat("BuyMod OrderOpenPrice %7.5f Bid %7.5f aNewSLPrice %7.5f",OrderOpenPrice(),bid,aNewSLPrice);
                  
                                          BuyMod = OrderModify(aTicket,OrderOpenPrice(),aNewSLPrice,OrderTakeProfit(),0,buycolor);
                                    
                                             if(!BuyMod){
                                             
                                                DiagnosticMessaging("Order Modification Error","Unfortunately there was an error in modifying Order #"+string(aTicket));
                                             
                                             }
                  

                                    }
            
               }
      
      }
   
   }

   fEvents(MODE_WORK);

  }
  
/*-----------------------------------------------------------------------------------------*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
         
            for(int i = 0; i < CloseAllPositions; i++){
            
               Print("Loop commenced...");
               
                  if(OrderSelect(CloseAllPositions, SELECT_BY_POS, MODE_TRADES)){
                                                
                     Print("Position selected...");
                     
                        if(OrderSymbol() == Symbol()){
                        
                           if(OrderMagicNumber() == UniqueChartIdentifier){
                           
                              if(OrderType() == OP_BUY){
                           
                                 ClosePositionOnCommand(Bid); i--;
                                                                                       
                              } else if (OrderType() == OP_SELL){
                              
                                 ClosePositionOnCommand(Ask); i--;
                                                            
                              }
                           
                           } else {
                           
                              continue;
                           
                           }
                        
                        } else {
                        
                           break;
                        
                        }
                  
                  } else {
                  
                     PrintTransactionEvent("There was an error in "+string(CloseAllPositions)+" selecting the order from the ledger when attempting to close your position");
                     
                     break;
                  
                  }
            
            }

      }
      
      if(sparam == ChartID_Breakeven){
      
         for(int ModifyAllPositions = TotalOpenOrders -1; ModifyAllPositions >= 0; ModifyAllPositions--){
         
            if(OrderSelect(ModifyAllPositions, SELECT_BY_POS, MODE_TRADES)){
            
               if(OrderSymbol() != Symbol() && OrderMagicNumber() != UniqueChartIdentifier){
               
                  Print("Moving to next order...");
                  
                     continue;
               
               } else {
               
                  if(OrderStopLoss() != OrderOpenPrice()){
                     
                     double NewSLPrice = OrderOpenPrice();
                     
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),NewSLPrice,OrderTakeProfit(),0,clrNONE)){
                           
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
            
              PrintTransactionEvent("There was an error in "+string(ModifyAllPositions)+" selecting the order from the ledger when attempting to modify your position to breakeven price.");
                            
              break;
            
            }
      
         }

      }

      if(sparam == ChartID_ModifyTakeProfit){
      
         for(int ModifyAllPositions = TotalOpenOrders - 1; ModifyAllPositions >= 0; ModifyAllPositions --){
         
            if(OrderSelect(ModifyAllPositions, SELECT_BY_POS, MODE_TRADES)){
            
               if(OrderMagicNumber() != UniqueChartIdentifier && OrderSymbol() != Symbol()){
               
                  continue;
               
               } else {
               
                  if(OrderType() == OP_BUY){
                  
                     NewTP =  OrderTakeProfit() + (tpIncrement * Point);
                     
                  } else if (OrderType() == OP_SELL){
                  
                     NewTP =  OrderTakeProfit() - (tpIncrement * Point);
                  
                  }
                  
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NewTP,0,clrNONE)){
                     
                     DiagnosticMessaging("Error in Changing your TakeProfit Price","Unfortunately there was an error in changing the TakeProfit price for order #"+string(OrderTicket()));
                        
                        Print("Error Code after TP change failure "+string(GetLastError()));
                              
                           break;
                  
                  } else {
                     
                     PopupMessaging("Order Successfully Modified","The order #"+string(OrderTicket())+" has been successfully modified",MB_OK | MB_ICONINFORMATION);
                                       
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
             
   if(!OrderClose(OrderTicket(),LotSize,ClosurePrice,300,clrBlueViolet)){
   
      DiagnosticMessaging("Position Closure Error","There was an error in closing position #"+string(TicketReference));
      
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
void fEvents(ENUM_FUNCTION_MODE enMode)
  {
   if(enMode == MODE_INIT)
     {
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
