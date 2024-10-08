//+------------------------------------------------------------------+
//|                                       diagnostics_hammertime.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <GlobalNamespace.mqh>
#include <ScreenshotCapture.mqh>
#include <ChartData.mqh>

string ExecutionDiagnostics(){
      
      ChartData();
     
      string strHammerBody;
      string strIsMinimumHammerBody          =     StringFormat("Hammer body %0.0f Minimum %0.0f",hammerBody,minimumHammerBody);;
      bool   isMinimumHammerBody; 
      
      switch (isCurrencyPresent){
         
         case 0: //bool returns false
                     
            strHammerBody = "PASS | Minimum hammer body has not been assessed";      
            
               break;
   
         case 1: //bool returns true.
               
            isMinimumHammerBody    =    (hammerBody >= minimumHammerBody);

               strHammerBody       =    (isMinimumHammerBody ? "PASS | " : "FAIL  | ") +  strIsMinimumHammerBody;
      
                  break;
            
         default:
         
               strHammerBody = StringFormat("Unable to be determied. Please see error %d",GetLastError());
               
                  break;
      
      }
      
      
      
      MqlDateTime timeLocStruct;
            
      TimeToStruct(TimeLocal(), timeLocStruct);
      
      bool   isBarTime                    =    (BarTime == Time[0]);
      
      string strBarTime                   =    ("BarTime");
     
      bool   isSpread                     =    (MarketSpread <= MaximumSpread);
      
      string strSpread                    =    "Spread "+string(MarketSpread);
      
      bool   isHammerHead                 =    ((hammerHeadM / retracementCandle) < hammerHeadPct);
      
      string strHammerHead                =    StringFormat("HammerHead %0.2f", hammerHeadM / retracementCandle);
      
      bool   isRSquared                   =    (RSq >= minRSquared && RSq <= maxRSquared ); 

      string strRSquared                  =    StringFormat("R² %0.0f%% Minimum R² %0.0f%% Maximum R² %0.0f%%", RSq, minRSquared, maxRSquared);
      
      bool   isOperatingMode              =    OperationMode == 2;
                           
      string strOperationalMode           =    StringSubstr(EnumToString((TEST_MODE)OperationMode),0);
            
      bool   isMarginBuffer               =    (marginBuffer <= RemainingMargin);
      
      string strMarginBuffer              =    ("Margin Buffer");
      
      bool   isMarginRequired             =    (AccountEquity() / OrderMarginRequirement * 100 >= brokerMarginLevel);
      
      string strMarginRequired            =    StringFormat("Broker Margin Level %0.2f%%", AccountEquity() / OrderMarginRequirement * 100 );
            
      bool   isCandleNotZero              =    (hammerHeadM != 0 && retracementCandle != 0);
      
      string strCandleNotZero             =    ("No Doji Candles Present.");
            
      bool   isTradingHours               =    (timeLocStruct.hour >= startingHour && timeLocStruct.hour < endingHour);
                           
      string strTradingHours              =    StringFormat("Trading Hour %d:00 GMT", timeLocStruct.hour);
            
      bool   isAutomatedOn                =    (IsTradeAllowed());
      
      string strAutomation                =    "Automation";
      
      bool   StandardDeviationLimit       =    (StDev >= MinimumStandardDeviation && StDev <= MaximumStandardDeviation);
                             
      string strStandardDeviationLimit    =    StringFormat("Standard Deviation %0.0fσ Minimum σ %0.0fσ Maximum σ %0.0fσ", StDev, MinimumStandardDeviation, MaximumStandardDeviation);
      
      bool   CurrencyPairSuspended        =    TempSuspension == 1;
      
      string CurrencyPairSuspendedReason  =    StringSubstr(EnumToString((NO_TRADE_REASON)NoTradeReason),0);
      
      bool   IsThereAnExistingPosition    =    (OrdersTotal() < 1);
      
      string IsThereAnExistingPositionString =  "Existing Positions Present";
      
      bool   BreakEvenGreaterThanSL       =    (breakeven * Point >=  stopLoss);
            
      bool   isTrend;
      bool   isMomentum;
      string strTrend;
      string strMomentum;
      bool   isHandle;
      bool   isInitialTrend;
      string strIsHandle;
      string strInitialTrend;
      bool   isRetracement;
      string strRetracement;
      bool   iscandleTail;
      string strCandleTail;
      
      if((OrderType() == OP_SELL) || (trendFast < trendSlow)){
      
         iscandleTail               =     (hammerHeadM / (highM - lowestOC) > candleTail);
                              
         strCandleTail              =     StringFormat("CandleTail %0.2f", hammerHeadM / (highM - lowestOC));
         
         isRetracement              =     (retracementCandleClose > retracementCandleOpen);
         
         strRetracement             =     "Retracement Open "+DoubleToString(retracementCandleOpen,Digits)+" Retracement Close "+DoubleToString(retracementCandleClose,Digits);
         
         isTrend                    =     (trendFast < trendSlow);                
         
         strTrend                   =     ("Trend");
         
         isMomentum                 =     (momentumFast < momentumSlow);  
      
         strMomentum                =     ("Momentum");    
         
         isHandle                   =     (hammerHeadM / (highestOC - lowM) <= hammerHandlePct); 
                     
         strIsHandle                =     StringFormat("Hammer Handle %0.2f", hammerHeadM / (highestOC - lowM));
                  
         isInitialTrend             =     ((initialTrendBearCandle / retracementCandle) <= retracePercentage);
                     
         strInitialTrend            =     StringFormat("Initial Trend %0.2f",initialTrendBearCandle / retracementCandle);
               
      } else if ((OrderType() == OP_BUY) || (trendFast > trendSlow)) {
      
         iscandleTail               =     (hammerHeadM / (highestOC - lowM) > candleTail);
                              
         strCandleTail              =     StringFormat("CandleTail %0.2f", hammerHeadM / (highestOC - lowM));
         
         isRetracement              =     (retracementCandleOpen > retracementCandleClose);
         
         strRetracement             =     "Retracement Open "+DoubleToString(retracementCandleOpen,Digits)+" Retracement Close "+DoubleToString(retracementCandleClose,Digits);
         
         isTrend                    =     (trendFast > trendSlow);                
         
         strTrend                   =     ("Trend");
         
         isMomentum                 =     (momentumFast > momentumSlow);   
      
         strMomentum                =     ("Momentum");  
                        
         isHandle                   =     (hammerHeadM / (highM - lowestOC)  <= hammerHandlePct);
                     
         strIsHandle                =     StringFormat("Hammer Handle %0.2f", hammerHeadM / (highM - lowestOC));
                     
         isInitialTrend             =     ((initialTrendBullCandle / retracementCandle) <= retracePercentage);   
                     
         strInitialTrend            =     StringFormat("Initial Trend %0.2f",initialTrendBullCandle / retracementCandle);
              
      } else {
      
         DiagnosticMessaging("Unable to Determine Order","There was an error to determining the transaction type when the order was selected from the ledger");
      
      }
   
   string diagnostics   = 
      "\n======================="+
      "\n"+
      "\n"+(isSpread                   ? "PASS | " : "FAIL  | ")  +  strSpread+
      "\n"+
      "\n"+(isRSquared                 ? "PASS | " : "FAIL  | ")  +  strRSquared+
      "\n"+
      "\n"+(StandardDeviationLimit     ? "PASS | " : "FAIL | ")   +  strStandardDeviationLimit+
      "\n"+
      "\n"+(isMarginBuffer             ? "PASS | " : "FAIL  | ")  +  strMarginBuffer+
      "\n"+
      "\n"+(isMarginRequired           ? "PASS | " : "FAIL  | ")  +  strMarginRequired+
      "\n"+
      "\n"+(isOperatingMode            ? "PASS | " : "FAIL  | ")  +  strOperationalMode+
      "\n"+
      "\n"+(isAutomatedOn              ? "PASS | " : "FAIL  | ")  +  strAutomation+
      "\n"+
      "\n"+(CurrencyPairSuspended      ? "PASS | " : "FAIL  | ")  +  CurrencyPairSuspendedReason+
      "\n"+
      "\n"+strHammerBody+
      "\n"+
      "\n"+(isTradingHours             ? "PASS | " : "FAIL  | ")  +  strTradingHours+
      "\n"+
      "\n"+(IsThereAnExistingPosition  ? "PASS | " : "FAIL | ")   +  IsThereAnExistingPositionString+
      "\n"+
      "\n"+(BreakEvenGreaterThanSL     ? "PASS | " : "FAIL | " )  +  "Breakeven Greater Than SL"+
      "\n"+
      "\n=======================";      

   return diagnostics;

}

string manualExecution(){

   string diagnostics = "This is a manually exected position.";
   
      return diagnostics;

}

string no_data(){

   lastErrorCode = IntegerToString(GetLastError(),0);
   
      string diagnostics = StringFormat("There has been an error in selecting the appropriate diagnostics data. (Error %s)", lastErrorCode);

         return diagnostics;
}
