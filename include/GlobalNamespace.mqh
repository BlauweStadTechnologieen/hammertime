#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <CompanyData.mqh>

enum ENUM_SENDDIAG{

   Send_Diag_Data                      =  1, // Send diagnostic data
   Do_Not_Send_Diag_Data               =  2  // Do not send diagnostic data
   

};

enum SEND_TRANSACTION_EMAILS{ 

   Send_Transaction_Messages          =  1, // Send transactional messages
   Do_Not_Send_Transaction_Messages   =  2  // Do not send transactional messages

};

enum PLOT_LINES{

   Yes                                 = 1, // On
   No                                  = 2  // Off

};

enum ENUM_ENTITY{
   
   Blue_City_Capital 	               = 1, // Blue City Capital
   United_Amerigo 	                  = 2, // United Amerigo
   Personal_Account                    = 3  // Personal account
   
};

enum TEST_MODE{

   Test_Mode                           = 1, // On
   Real_Mode                           = 2  // Off

};

enum PREVIOUS_PRICES{
  
   On                                  = 1, // On
   Off                                 = 2  // Off
   
  };

enum NO_TRADE{
  
   No_Temporary_Suspension             = 1, // No Temporary Suspension
   Temporary_Suspension                = 2  // Temporarily Suspended
   
};

enum NO_TRADE_REASON{
  
   Interest_Rate_Decision_Day          = 1, // Interst rate decision day
   Period_Of_Significant_Volatility    = 2, // Period of significant volatility
   Holiday                             = 3, // Holiday season
   No_Suspension                       = 4, // No suspension
   Irratic_Price_Action                = 5, // Irratic price behaviour
   Resistence_in_direction_of_Trade    = 6, // Resistence/support near
   Unfavourable_price_conditions       = 7  // Unfavourable conditions 
   
};

enum PENDING_ORDER_OPTION{

   Pending_Order_Option                =  1, // Option for pending orders
   No_Pending_Order_Option             =  2  // No option for pending orders

};

enum MAX_SPREAD{

   S5                                  =  5,    //5  
   S10                                 =  10,   //10
   S15                                 =  15,   //15
   S20                                 =  20,   //20
   S25                                 =  25,   //25
   S30                                 =  30,   //30
   S35                                 =  35,   //35
   S40                                 =  40    //40

};

enum MinRSQ{

   RSQ10                               =  10,   //10
   RSQ20                               =  20,   //20        
   RSQ30                               =  30,   //30
   RSQ40                               =  40,   //40
   RSQ50                               =  50    //50

};

enum MaxRSQ{

   RSQ60                               =  60,   //60
   RSQ70                               =  70,   //70
   RSQ80                               =  80,   //80
   RSQ90                               =  90,   //90
   RSQ100                              =  100

};

enum MinStandardDeviation{
   
   SD100                               =  100,  //100
   SD200                               =  200,  //200
   SD300                               =  300   //300

};

enum MaxStandardDeviation{
   
   SD400                               =  400,  //400
   SD500                               =  500,  //500
   SD600                               =  600,  //600
   SD700                               =  700,  //700
   SD800                               =  800,  //800
   SD900                               =  900,  //900
   SD1000                              =  1000  //1000

};

enum MaxRewardFactor{

   RewardFactor2  =  2, //2
   RewardFactor3  =  3, //3
   RewardFactor4  =  4, //4
   RewardFactor5  =  5, //5
   RewardFactor6  =  6, //6
   RewardFactor7  =  7, //7
   RewardFactor8  =  8, //8
   RewardFactor9  =  9, //9
   RewardFactor10 =  10 //10

};

enum MaxPipRisk{
   
   MaxPIPRisk100  = 100, //100
   MaxPIPRisk200  = 200, //200
   MaxPIPRisk300  = 300, //300
   MaxPIPRisk400  = 400, //400
   MaxPIPRisk500  = 500  //500
   
};

enum MinimumHammerBody{

   MinimumBody10 =  10, //10
   MinimumBody20 =  20, //20
   MinimumBody30 =  30, //30
   MinimumBody40 =  40, //40
   MinimumBody50 =  50  //50


};

enum ChartObjectFont{

   ChartObjectFontSize5 =  5, //5
   ChartObjectFontSize10 = 10,//10
   ChartObjectFontSize15 = 15,//15
   ChartObjectFontSize20 = 20,//20
   ChartObjectFontSize25 = 25 //25
   
};

enum ChartDataPeriod{

   ChartDataPeriod10 = 10, //10
   ChartDataPeriod20 = 20, //20
   ChartDataPeriod30 = 30, //30
   ChartDataPeriod40 = 40, //40
   ChartDataPeriod50 = 50, //50
   ChartDataPeriod60 = 60, //60
   ChartDataPeriod70 = 70, //70
   ChartDataPeriod80 = 80, //80
   ChartDataPeriod90 = 90, //90
   ChartDataPeriod100 = 100 //100

};

enum ChartDataAveragingMethod{

   SMA =MODE_SMA,  // Simple Moving Average, 
   EMA =MODE_EMA,  // Exponential Moving Average, 
   SMMA=MODE_SMMA, // Smoothed Moving Average, 
   LWMA=MODE_LWMA, // Linear Weighted Moving Average.
   DEMA            // Double Exponential Moving Average.

};

enum Breakeven{

   Breakeven50 =  50,   //50
   Breakeven60 =  60,   //60
   Breakeven70 =  70,   //70
   Breakeven80 =  80,   //80
   Breakeven90 =  90,   //90
   Breakeven100 =  100,  //100
   Breakeven120 =  120,  //120
   Breakeven130 =  130,  //130
   Breakeven140 =  140,  //140
   Breakeven150 =  150,  //150
   Breakeven160 =  160,  //160
   Breakeven170 =  170,  //170
   Breakeven180 =  180,  //180
   Breakeven190 =  190,  //190
   Breakeven200 =  200   //200

};

//Exern Variables//

input    MinRSQ                           minRSquared                      =     20;                                                            // Minimum R²(%)
input    MaxRSQ                           maxRSquared                      =     60;                                                            // Maximum R²(%)
input    MinStandardDeviation             MinimumStandardDeviation         =     100;                                                           // Minimum σ
input    MaxStandardDeviation             MaximumStandardDeviation         =     400;                                                           // Maximum σ 
input    MinimumHammerBody                minimumHammerBody                =     10;  
input    NO_TRADE                         TempSuspension                   =     1;                                                             // Temporarily Suspend Operations
input    NO_TRADE_REASON                  NoTradeReason                    =     4;                                                             // Temporary Suspension Reason
input    MaxRewardFactor                  RewardFactor                     =     4;                                                             // Maximum Reward Factor (1:[Maximum Reward Factor]))
input    MaxPipRisk                       pipStopLoss                      =     100;                                                           // Maximum Pip Risk 
input    Breakeven                        breakeven                        =     120;                                                           // Breakeven 
input    MAX_SPREAD                       MaximumSpread                    =     30;
extern   int                              VerticalDistance                 =     200;
extern   int                              LotSize                          =     8;                                                             // Contract Size
extern   int                              ContractSize                     =     100000;                                                        // Contract Size (Multiple)
extern   int                              tpIncrement                      =     200;                                                           // Order Modify Increment (pips)
extern   string                           FreeTextComment                  =     "";                                                            // FreeTextComment (Optional)
extern   string                           ChartID_CloseButton              =     "Liquidate";                                                   // Close Button Chart Object
extern   string                           ChartID_Breakeven                =     "Breakeven";                                                   // Breakeven Chart Object
extern   string                           ChartID_ModifyTakeProfit         =     "ChangeTPPrice";                                               // Modify TakeProfit Chart Object
extern   string                           ChartID_PipDisplayFluid          =     "FluidPipDisplay";                                             // PipDisplayFluid Chart Object        
extern   string                           ChartID_PipDisplayStatic         =     "StaticPipDisplay";                                            // PipDisplayStatic Chart Object
extern   string                           ChartID_SpreadDisplay            =     "SpreadDisplay";                                               // Spread Display Chart Object
extern   string                           ChartID_Suspension               =     "SuspendedPair";
input    string                           ProductLicenceKey                =     "ALvFRpKQS1EgMUVnTVVWblRWVldibFJXVmxkaWJGSlhW";                // Product Licence Key
input    ENUM_ENTITY                      Group_Entity                     =     1;                                                             // Entity
input    ENUM_SENDDIAG                    SendDiagnosticData               =     1;                                                             // Send Diagnostics Messages
input    SEND_TRANSACTION_EMAILS          SendTransactionMessages          =     1;                                                             // Send Transactional Messages
input    TEST_MODE                        OperationMode                    =     2;                                                             // Debug Mode
input    PREVIOUS_PRICES                  PlotPreviousPrices               =     2;                                                             // Print Previous Prices
input    PENDING_ORDER_OPTION             PendingOrderOption               =     1;                                                             // Pending Order Option
input    ChartObjectFont                  ChartObjectFontSize              =     15;                                                            // Chart Object Font Size
input    ChartDataPeriod                  ChartDataPeriods                 =     10;                                                            // Chart Data Period
input    ChartDataAveragingMethod         ChartDataMAMethod                =     SMA;                                                           // Chart Data Method          
int      brokerMarginLevel                                                 =     150;                                                           //Broker-specified minimum required mrgin level
int      startingHour                                                      =     9;           /*GMT*/
int      endingHour                                                        =     16;          /*GMT*/
int      AM_TrendFast                                                      =     1;           /*MODE_EMA*/
int      Period_TrendFast                                                  =     21;          /*Trend*/
int      AM_TrendSlow                                                      =     1;           /*MODE_EMA*/
int      Period_TrendSlow                                                  =     55;          /*Trend*/
int      AM_MomentumSlow                                                   =     0;           /*MODE_SMA*/
int      Period_MomentumSlow                                               =     13;          /*Momentum*/
int      AM_MomentumFast                                                   =     1;           /*MODE_EMA*/
int      Period_MomentumFast                                               =     8;           /*Momentum*/
int      Applied_Price                                                     =     0;           /*Applied Price*/        
double   hammerHeadPct                                                     =     0.20;        
double   hammerHandlePct                                                   =     0.20;        
double   retracePercentage                                                 =     0.30;        
double   candleTail                                                        =     0.40;
//double   engulfingRatio                                                    =     1.50;
double   initialPullbackRatio                                              =     0.50;
 
// Non-specificable Variables
bool              NewBar;
bool              ClosePosition;
//bool              manualClose;
bool              BuyMod;
bool              SellMod;
bool              InitOrders;
bool              InitTime;
////bool              close;
bool              isScreenShot;
bool              isTempSuspension;
bool              isCurrencyPresent;
bool              AutomationAllowed;
bool              MessageSent;
datetime          CandleOpenTime;
//datetime          lastStamp;
datetime          DateTimeNow;
datetime          BarTime;
datetime          DateTimeVariable = D'1970.01.01 00:00:00';
//datetime          time_a;
//datetime          time_b;
//datetime          time_c;
//datetime          time_e;
//datetime          time_f; 
//datetime          time_g;
//datetime          time_h;
//datetime          time_i;
//datetime          time_j;
//datetime          x_total;
//datetime          time_average;
//datetime          timeOpen;
datetime          Expires;
color             buycolor;
color             sellcolor;
color             WebColors;
int               isJPYPresent;
int               isGPBAUDPresent;
int               isEURAUDPresent;
//int               stringFindAccountCurrency;
//int               chartTimeframe;
//int               eaCode;
//int               n;
int               mqlTime;
//int               TradeDuration;
//int               maPeriod;
//int               fastMAPeriod;
int               ordersTotal;   
int               marginBuffer;
int               GMTAdjustment;
//int               i_Hours;
//int               filenameMode;
int               ReturnCode;
int               PendingExpiration;
int               PendingOrder;
//int               OTI;
int               TicketReference;
//int               AutoGenID;
int               BrokerAccountNumber;
int               GetCurrentErrorCode;
int               TotalOpenOrders               =  OrdersTotal();;
int               ClosePositionConfirmation;
int               MagicNumber;
double            EstimatedProfit;
double            PendingOrderStopLoss;
double            PendingOrderTakeProfit;
double            MarketOrderStopLoss;
double            MarketOrderTakeProfit;
double            MarketEntryPrice;
//double            priceAdjustment;
//double            pctRiskConversion;
double            BrokerCommission;
//double            closePrice; 
double            stopLoss;
//double            numberLotsToClose;
//double            pipDispLong;
//double            pipDispShort;  
double            broker_ratio                  = 0;        // Broker Ratio
double            broker_lot_min                = 0;        // Broker Minimum permitted amount of a lot.
double            broker_lot_max                = 0;        // Broker Maximum permitted amount of a lot.
double            broker_lot_step               = 0;        // Broker Step for changing lots.
double            broker_contract               = 0;        // Broker Lot size in the base currency.
double            broker_stop_level             = 0;        // Broker Stop level in points
double            broker_freeze_level           = 0;        // Order freeze level in points. If the execution price lies within the range defined by the freeze level, the order cannot be modified, cancelled or closed.
double            broker_point                  = 0;        // Broker Point size in the quote currency.
double            OrderMarginRequirement;
double            CurrentFreeMargin;
double            trendFast;
double            trendSlow;
double            momentumFast;
double            momentumSlow;
double            momentumFastCurrent;
double            momentumFastPrevious;
double            hammerBody;
double            tickvalue;
double            spread;
double            OrderSwapCharge;
double            currentOpenPrice;
double            positionCommission;
double            positionProfit;
double            currentBid;
double            currentAsk;
//double            currentSpread;
//double            entryPriceAsk;
double            accountBalance;
//double            amountAtRisk;
double            totalSpread;
double            totalCommissionSqrd;
//double            profitCalc;
//double            lossCalc;
double            ExchangeRate;
double            OpeningPrice;
double            StopLoss;
double            initialTrendBullCandle;
double            initialTrendBearCandle;
double            hammerHeadOpen;
double            hammerHeadClose;
double            RemainingMargin;
//double            partial;
//double            coVariance;
//double            slope;                                                // This is expressed as M in the Linear Regression Equation
//double            intercept;                                            // This is expressed as C in the Linear Regression Equation
//double            estimatedEntryPrice = slope * Time[0] + intercept;
//double            averagePrice;
//double            price_average; 
//double            sma;
//double            correlationCoefficient;
double            RSquared; //**PriceDataAttr
double            hammerHeadM;
double            retracementCandle;
double            retracementCandleOpen;
double            retracementCandleClose;
double            highestOC;
double            lowestOC;
double            highM;
double            lowM;
double            engulfingOpen;
double            engulfingClose;
double            engulfingCandleHigh;
double            engulfingCandleLow;
double            engulfingCandle;
double            pullbackOpen;
double            pullbackHigh;
double            pullbackLow;
double            pullbackClose;
double            pullbackCandle;
double            pullbackCandleMinimum;
double            initialOpen;
double            initialClose;
double            initial;
double            engulfingPullback;
double            initialPullback;
double            engulfingHighTail;
//double            engulfingLowTail;
//double            MidPointOpen;
//double            MidPointClose;
double            PriceProperty;
double            MarketSpread;
double            MarketExitPrice;
double            ExecutionSpreadCharge;
double            CurrentBarOpenPrice;
double            StopLossPrice;
double            TakeProfitPrice;
double            entryPriceBid;
double            totalCommission;
double            MidPoint;
double            StandardDeviation; //**PriceDataAttr
double            StDev;
double            RSq;
double            SpotBid;
double            SpotAsk;
double            CurrentLow;
double            CurrentHigh;
double            PriceDifferential;
double            PipPerformance;
double            PositionGrossProfit;
double            PositionNetProfit;
double            ModifiedTakeProfitPrice;
double            PositionClosurePrice;
double            NewTP;
double            TotalTransactionCost;
string            ChartCaptureImageURL;
string            ExecutionPrice       =  DoubleToString(OrderOpenPrice(),Digits);
string            ExecutionTimeframe   =  IntegerToString(Period()/60,0);
string            ExecutionEntity      =  StringSubstr(EnumToString((ENUM_ENTITY)Group_Entity),0);
string            ExecutionProperty    =  IntegerToString(ReturnCode,0);
string            ExecutionSymbol      =  OrderSymbol();
string            changelog;
//string            autoGenId;
string            symbol;
string            eaName;
string            accountCurrency;
string            AccountCurrency;
string            lastErrorCode;
string            AccountNumber;
//string            fileName;
string            SymbolPair;
//string            ticketNumber                     =   IntegerToString(OrderTicket(),0);
string            FooterMessage                    =   LegalFooterDisclaimer();
//string            url;
//string            myURL;
string            appendFileExt                    =  ".mqh"; 
string            errorCodeURL                     =  "Please find the correct fault code from the following URL https://docs.mql4.com/constants/errorswarnings/errorcodes";
string            GitHubRepo                       =  "You can find out full roadmap and version revisions by visiting https://github.com/BlauweStadTechnologieen/2024";
string            MemoText                         =  "From 15.4.5 you will see less diagnostic factors in your transactional message.\n\nYou will also receive fewer transaction emails, which are to be standardised, and a copy of the email will also be sent to your logging in your terminal.\n\n"+GitHubRepo;
string            strTempSuspension;
string            ConfimationEmailGreeting;
string            ConfimationEmailCostData;
long              CurrentChart;
long UniqueChartIdentifier = ChartID();
/*-----------------------------------------------------------------------------*/

enum ENUM_FUNCTION_MODE { MODE_DEINIT = -1, MODE_INIT, MODE_WORK };
struct STRUCT_ORDER_INFO
  {
   int               ticket;
   int               magic;
   int               type;
   double            lot;
   double            open;
   double            close;
   double            sl;
   double            tp;
   double            profit;
   datetime          time;
  };

STRUCT_ORDER_INFO stcOrdOldArr[1], stcOrdNewArr[1];   //arrays containing order list with information
string sOrdOldArr[], sOrdNewArr[];







      


