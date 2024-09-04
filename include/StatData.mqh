//+------------------------------------------------------------------+
//|                                                     StatData.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include <GlobalNamespace.mqh>
#include <MessagesModule.mqh>
#include <CompanyData.mqh>

void CalculateRSquare(int Periods, int SMAMODE){

   if(Periods > 10){
   
      Periods = 10;
   
   }

   //---
   //// Declare dynamic arrays.
   double time[];
   double price[];
   double time_pow[];
   //---

   //---
   //// Resize arrays to the specified number of period.
   ArrayResize(time, Periods);
   ArrayResize(price, Periods);
   ArrayResize(time_pow, Periods);
   //---

   //---
   //Array to store values.
   for (int i = 0; i < Periods; i++) {
   
   time[i]     = (double)Time[i];
   price[i]    = Open[i];
   time_pow[i] = MathPow(time[i], 2);
   
   }
   //---

   //---
   //Calculate Sums & Averages
   double   SumOfPrices   = 0;
   double   SumOfPeriods  = 0;
   
   for (int i = 0; i < Periods; i++){
   
      SumOfPeriods   += time[i];
   
   }

   double SMA           = iMA(NULL, 0, Periods, 0, SMAMODE, PRICE_OPEN, 0);
   double AverageTime   = SumOfPeriods / Periods;
   //---

   ExMinusAverage      = 0;
   EyMinusAverage      = 0;
   ExyAverage          = 0;
   Ex2                 = 0;
   Exy                 = 0;
   EyMinusAveragePow2  = 0;

   for (int i = 0; i < Periods; i++) {
   
      ExMinusAverage     += (double)(time[i] - AverageTime);
      EyMinusAverage     += (price[i] - SMA);
      ExyAverage         += ((double)time[i] - AverageTime) * (price[i] - SMA);
      Ex2                += time_pow[i];
      Exy                += (double)time[i] * price[i];
      EyMinusAveragePow2 += MathPow(price[i] - SMA, 2);
   
   }

   ExMinusAveragePow2 = 0;
   
   for (int i = 0; i <Periods; i++){
   
      ExMinusAveragePow2 += MathPow(time[i] - AverageTime,2);
   
   }

   double SRTExMinusAveragePow2    = sqrt(ExMinusAveragePow2 / (Periods - 1));
   double SRTEyMinusAveragePow2    = sqrt(EyMinusAveragePow2 / (Periods - 1));
   double CoVariance               = ExyAverage / (Periods - 1);
   double Variance                 = (SRTExMinusAveragePow2 * SRTEyMinusAveragePow2);
   double CorrelationCoefficient   = NormalizeDouble((CoVariance / Variance),2);
   double StandardDeviation        = NormalizeDouble(SRTEyMinusAveragePow2  / Point,2);
   double RSquared                 = NormalizeDouble(MathPow(CorrelationCoefficient,2)*100,2);
   
   PrintFormat("%0.0f",RSquared);
   PrintFormat("%0.0f",StandardDeviation); 
    
}
