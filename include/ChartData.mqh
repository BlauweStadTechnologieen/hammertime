#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <GlobalNamespace.mqh>
#include <MessagesModule.mqh>
#include <CompanyData.mqh>

string DisplayFormat(double Attribute){

   string Value;
   
   if (Attribute < 10) {
    
      Value = "00" + string(Attribute);
        
    } else if (Attribute < 100) {
    
      Value = "0" + string(Attribute);
        
    } else {
    
      Value = string(Attribute);
        
    }
    
    return Value;

}

string PriceInformation =  "PriceData";
string StatisticalData  =  "StatData";
string SoftwareVersion  =  "SoftwareVersion";
string VariantData      =  "VariantData";

bool ChartData(){

   //---
   //Software Version Display
   ObjectCreate(0,SoftwareVersion,OBJ_LABEL,0,0,0 );
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_XDISTANCE, 20);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_XSIZE, 400);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_YDISTANCE, VerticalDistance);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_YSIZE, 100);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_COLOR,clrBlue);
   
   ObjectSetInteger(0,SoftwareVersion, OBJPROP_FONTSIZE,ChartObjectFontSize);
   //---
   
   //---
   //Pricing Data Display
   ObjectCreate(0,PriceInformation,OBJ_LABEL,0,0,0 );
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_XDISTANCE, 20);
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_XSIZE, 400);
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_YDISTANCE, VerticalDistance + 30);
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_YSIZE, 100);
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
   ObjectSetInteger(0,PriceInformation, OBJPROP_COLOR,clrBlue);

   ObjectSetInteger(0,PriceInformation, OBJPROP_FONTSIZE,15);
   //---
   
   //---
   //Pricing Statistical Data Display                     
   ObjectCreate(0,StatisticalData,OBJ_LABEL,0,0,0 );
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_XDISTANCE, 20);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_XSIZE, 400);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_YDISTANCE, VerticalDistance + 60);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_YSIZE, 100);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_COLOR,clrBlue);
   
   ObjectSetInteger(0,StatisticalData, OBJPROP_FONTSIZE,ChartObjectFontSize);
   //---
   
   //---
   //Variants
   ObjectCreate(0,VariantData,OBJ_LABEL,0,0,0 );
   
   ObjectSetInteger(0,VariantData, OBJPROP_XDISTANCE, 20);
   
   ObjectSetInteger(0,VariantData, OBJPROP_XSIZE, 400);
   
   ObjectSetInteger(0,VariantData, OBJPROP_YDISTANCE, VerticalDistance + 90);
   
   ObjectSetInteger(0,VariantData, OBJPROP_YSIZE, 100);
   
   ObjectSetInteger(0,VariantData, OBJPROP_CORNER,CORNER_LEFT_UPPER);
   
   ObjectSetInteger(0,VariantData, OBJPROP_COLOR,clrBlue);
   
   ObjectSetInteger(0,VariantData, OBJPROP_FONTSIZE,ChartObjectFontSize);
   
   //---
   
   //---
   //// Declare dynamic arrays.
   double time[];
   double price[];
   double time_pow[];
   double PriceOpen[];
   double PriceClose[];
   double PriceHigh[];
   double PriceLow[];
   //---
   
   //---
   //// Resize arrays to the specified number of period.
   ArrayResize(time, ChartDataPeriods);
   ArrayResize(price, ChartDataPeriods);
   ArrayResize(time_pow, ChartDataPeriods);
   ArrayResize(PriceOpen, ChartDataPeriods);
   ArrayResize(PriceClose, ChartDataPeriods);
   ArrayResize(PriceHigh, ChartDataPeriods);
   ArrayResize(PriceLow, ChartDataPeriods);
   
   //---
   
   //---
   //Array to store values.
   for (int i = 0; i < ChartDataPeriods; i++) {
   
      time[i]        =  double(ulong(Time[i]));
      price[i]       =  Open[i];
      time_pow[i]    =  MathPow(time[i], 2);
   
   }
   //---
   
   //---
   //Calculate Sums & Averages
   double   SumOfPeriods  = 0;
   
   for (int i = 0; i < ChartDataPeriods; i++){
   
      SumOfPeriods   += time[i];
   
   }
   
   double RollingAveragePrice    = iMA(NULL, 0, ChartDataPeriods, 0, ENUM_MA_METHOD(ChartDataMAMethod), PRICE_OPEN, 0);
   double AverageTime            = SumOfPeriods / ChartDataPeriods;
   //---
   
   double SumCandleBodyLen    = 0;
   double SumCandleRangeLen   = 0;
   double RangeLenRatio       = 0;
   
   for (int i = 2; i < ChartDataPeriods; i++){
   
      PriceOpen[i]   = Open[i];
      PriceClose[i]  = Close[i];
      PriceHigh[i]   = High[i];
      PriceLow[i]    = Low[i];
      
      SumCandleBodyLen  += MathAbs(PriceOpen[i] - PriceClose[i]);
      SumCandleRangeLen += PriceHigh[i] - PriceLow[i];
   
   }
   
   // Calculate averages
   double AverageCandleBodyLen    =  SumCandleBodyLen / ChartDataPeriods;
   double AverageCandleRangeLen   =  SumCandleRangeLen / ChartDataPeriods;
   
   // Normalize the final average values
          AverageCandleBodyLen    /= Point;
          AverageCandleRangeLen   /= Point;
   
   // Normalize to the desired precision
          AverageCandleBodyLen    =  NormalizeDouble(AverageCandleBodyLen, 0);
          AverageCandleRangeLen   =  NormalizeDouble(AverageCandleRangeLen, 0);
   
   //Calculate Ratio
   //The higher the value, the more stable the price supposedly is
          RangeLenRatio           =  (AverageCandleBodyLen / AverageCandleRangeLen) * 100;
          RangeLenRatio           =  NormalizeDouble(RangeLenRatio,0);
   
   double ExMinusAverage      = 0;
   double EyMinusAverage      = 0;
   double ExyAverage          = 0;
   double Ex2                 = 0;
   double Exy                 = 0;
   double EyMinusAveragePow2  = 0;
   
   for (int i = 0; i < ChartDataPeriods; i++) {
      
      ExMinusAverage     += (time[i] - AverageTime);
      EyMinusAverage     += (price[i] - RollingAveragePrice);
      ExyAverage         += (time[i] - AverageTime) * (price[i] - RollingAveragePrice);
      Ex2                += time_pow[i];
      Exy                += time[i] * price[i];
      EyMinusAveragePow2 += MathPow(price[i] - RollingAveragePrice, 2);
   
   }
   
   double ExMinusAveragePow2 = 0;
   
   for (int i = 0; i < ChartDataPeriods; i++){
   
      ExMinusAveragePow2 += MathPow(time[i] - AverageTime,2);
   
   }
   
   double sqrtExMinusAveragePow2    =  sqrt(ExMinusAveragePow2 / (ChartDataPeriods - 1));
   double sqrtEyMinusAveragePow2    =  sqrt(EyMinusAveragePow2 / (ChartDataPeriods - 1));
   double CoVariance                =  ExyAverage / (ChartDataPeriods - 1);
   double Variance                  =  (sqrtExMinusAveragePow2 * sqrtEyMinusAveragePow2);
   double CorrelationCoefficient    =  NormalizeDouble((CoVariance / Variance),2);
          StDev                     =  NormalizeDouble(sqrtEyMinusAveragePow2  / Point,0);
          RSq                       =  NormalizeDouble(MathPow(CorrelationCoefficient,2)*100,0);
   
   string TrendStatus;
   string MomentumStatus;
   double Price;
   
   if (trendFast > trendSlow){
   
      TrendStatus          = "Bull";
      Price                = CurrentHigh;
   
   } else {
      
      TrendStatus          = "Bear";
      Price                = CurrentLow;
   
   }
   
   string R2   = DisplayFormat(RSq);
   string S    = DisplayFormat(StDev);
   string MS   = DisplayFormat(MarketSpread);
   string ACBL = DisplayFormat(AverageCandleBodyLen);
   string ACRL = DisplayFormat(AverageCandleRangeLen);
   string RLR  = DisplayFormat(RangeLenRatio);
   
   if (momentumFast > momentumSlow){
   
      MomentumStatus = "Bull";
   
   } else {
      
      MomentumStatus = "Bear";
   
   }
   
   if(!ObjectSetString(0,PriceInformation, OBJPROP_TEXT,TrendStatus+" / "+MomentumStatus+ " / "+DoubleToString(CurrentBarOpenPrice,Digits)+" / "+DoubleToStr(Price,Digits)+" / "+DoubleToString(SpotBid,Digits))){
         
      DiagnosticMessaging("Object Draw Error","Unfortunately there was an error in drawing the object "+PriceInformation);
      
      return false;
   
   }
   
   if(!ObjectSetString(0,StatisticalData, OBJPROP_TEXT,MS+" ("+string(MaximumSpread)+") / "+S+" ("+string(MinimumStandardDeviation)+" / "+string(MaximumStandardDeviation)+") / "+R2+"% ("+string(minRSquared)+"% / "+string(maxRSquared)+"%)")){
     
      DiagnosticMessaging("Object Draw Error","Unfortunately there was an error in drawing the object "+StatisticalData);
      
      return false;   
      
   }
   
   if(!ObjectSetString(0,SoftwareVersion, OBJPROP_TEXT,(eaName))){
   
      DiagnosticMessaging("Object Draw Error","Unfortunately there was an error in drawing the object "+SoftwareVersion);
      
      return false;
   
   }
   
   if(!ObjectSetString(0,VariantData, OBJPROP_TEXT,"Risk/Reward 1 : "+string(RewardFactor)+" / "+ACBL+" / "+ACRL+" / "+string(RLR))){
   
      DiagnosticMessaging("Object Draw Error: "+VariantData,"Unfortunately, there was an error in drawing the object "+VariantData);
   
      return false;
   
   }
   
  return true; 

}











