#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <GlobalNamespace.mqh>


void plotting_lines(){
  
   /*time_a                           =  Time[0];
   time_b                           =  Time[1];
   time_c                           =  Time[2];
   time_d                           =  Time[3];
   time_e                           =  Time[4];
   time_f                           =  Time[5]; 
   time_g                           =  Time[6];
   time_h                           =  Time[7];
   time_i                           =  Time[8];
   time_j                           =  Time[9];
   time_a_pow                       =  MathPow(time_a,2);
   time_b_pow                       =  MathPow(time_b,2);
   time_c_pow                       =  MathPow(time_c,2);
   time_d_pow                       =  MathPow(time_d,2);
   time_e_pow                       =  MathPow(time_e,2);
   time_f_pow                       =  MathPow(time_f,2);
   time_g_pow                       =  MathPow(time_g,2);
   time_h_pow                       =  MathPow(time_h,2);
   time_i_pow                       =  MathPow(time_i,2);
   time_j_pow                       =  MathPow(time_j,2);
   price_a                          =  iOpen(Symbol(),0,0);
   price_b                          =  iOpen(Symbol(),0,1);
   price_c                          =  iOpen(Symbol(),0,2);
   price_d                          =  iOpen(Symbol(),0,3);
   price_e                          =  iOpen(Symbol(),0,4);
   price_f                          =  iOpen(Symbol(),0,5);
   price_g                          =  iOpen(Symbol(),0,6);
   price_h                          =  iOpen(Symbol(),0,7);
   price_i                          =  iOpen(Symbol(),0,8);
   price_j                          =  iOpen(Symbol(),0,9);
   n                                =  10;   
   x_total                          =  (time_a + time_b + time_c + time_d + time_e + time_f + time_g + time_h + time_i + time_j);
   y_total                          =  (price_a + price_b + price_c + price_d + price_e + price_f + price_g + price_h + price_i + price_j);
   time_average                     =  (time_a + time_b + time_c + time_d + time_e + time_f + time_g + time_h + time_i + time_j) / n;
   ExMinusAverage                   =  (time_a - time_average) + (time_b - time_average) + (time_c - time_average);
   price_average                    =  (price_a + price_b + price_c + price_d + price_e + price_f + price_g + price_h + price_i + price_j)/n; 
   EyMinusAverage                   =  (price_a - price_average) + (price_b - price_average) + (price_c - price_average) + (price_d - price_average) + (price_e - price_average) + (price_f - price_average) + (price_g - price_average) + (price_h - price_average) + (price_i - price_average) + (price_j - price_average);
   ExyAverage                       =  ((time_a - time_average) * (price_a - price_average) + (time_b - time_average) * (price_b - price_average)  +  (time_c - time_average) * (price_c - price_average)  +  (time_d - time_average) * (price_d - price_average)  +  (time_e - time_average) * (price_e - price_average)  +  (time_f - time_average) * (price_f - price_average)  +  (time_g - time_average) * (price_g - price_average)  +  (time_h - time_average) * (price_h - price_average)  +  (time_i  - time_average) * (price_i - price_average) + (time_j - time_average) * (price_j - price_average));
   Ex2                              =  time_a_pow + time_b_pow + time_c_pow + time_d_pow + time_e_pow + time_f_pow + time_g_pow + time_h_pow + time_i_pow + time_j_pow;
   Exy                              =  (time_a * price_a)+(time_b * price_b)+(time_c * price_c)+(time_d * price_d)+(time_e * price_e)+(time_f * price_f)+(time_g * price_g)+(time_h * price_h)+(time_i * price_i)+(time_j * price_j);
   ExMinusAveragePow2               =  MathPow(time_a - time_average,2)+ MathPow(time_b - time_average,2)+ MathPow(time_c - time_average,2)+ MathPow(time_d - time_average,2)+ MathPow(time_e - time_average,2)+ MathPow(time_f - time_average,2) + MathPow(time_g - time_average,2)+MathPow(time_h - time_average,2)+MathPow(time_i - time_average,2)+ MathPow(time_j - time_average,2);   
   EyMinusAveragePow2               =  MathPow(price_a - price_average,2)+ MathPow(price_b - price_average,2)+ MathPow(price_c - price_average,2)+ MathPow(price_d - price_average,2)+MathPow(price_e - price_average,2)+MathPow(price_f - price_average,2)+MathPow(price_g - price_average,2)+MathPow(price_h - price_average,2)+MathPow(price_i - price_average,2)+MathPow(price_j - price_average,2);
   sqrtExMinusAveragePow2           =  sqrt(ExMinusAveragePow2/(n-1));
   sqrtEyMinusAveragePow2           =  sqrt(EyMinusAveragePow2/(n-1));
   coVariance                       =  ExyAverage /(n-1);
   variance                         =  (sqrtEyMinusAveragePow2 * sqrtExMinusAveragePow2);
   correlationCoefficient           =  DoubleToString(NormalizeDouble(coVariance / variance,5));
   timeOpen                         =  Time[0];
   sma                              =  iMA(NULL,0,n,0,MODE_SMA,PRICE_OPEN,0);
   slope                            =  (Exy - (x_total * y_total/n))/(Ex2-(MathPow(x_total,2)/n));
   intercept                        =  (y_total-(slope*x_total))/n;
   regression                       =  NormalizeDouble(slope * time_a + intercept,Digits);
   standardDeviation                =  sqrt(ExMinusAveragePow2 * EyMinusAveragePow2/(n-1));  
   
   PrintFormat("n %d",n);
   PrintFormat("time_average  %d",time_average ); 
   PrintFormat("price_average %0.5f",price_average);
   PrintFormat("price_average SMA %0.5f",sma); 
   PrintFormat("ExyAverage  %0.2f",ExyAverage); 
   PrintFormat("Ex2  %0.0f",Ex2);
   PrintFormat("Exy   %0.0f",Exy );
   PrintFormat("ExMinusAveragePow2  %0.0f",ExMinusAveragePow2);
   PrintFormat("EyMinusAveragePow2  %0.9f",EyMinusAveragePow2);
   PrintFormat("sqrtEyMinusAveragePow2  %0.12f",sqrt(EyMinusAveragePow2/(n-1)));
   PrintFormat("sqrtExMinusAveragePow2  %0.0f",sqrt(ExMinusAveragePow2/(n-1)));
   PrintFormat("StandardDeviation  %0.2f",sqrtEyMinusAveragePow2 * sqrtExMinusAveragePow2); 
   PrintFormat("Variance  %0.2f",sqrtEyMinusAveragePow2 * sqrtExMinusAveragePow2);
   PrintFormat("CoVariance  %0.2f",ExyAverage /(n-1));
   PrintFormat("Bar Open Time %d",timeOpen);
   PrintFormat("Slope %0.12f", slope );
   PrintFormat("Intercept %0.2f", intercept );
   PrintFormat("Correlation %0.2f",coVariance / variance); 
   PrintFormat("Regression %0.5f",regression);*/


            
  
   
}


