//+------------------------------------------------------------------+
//|                                                      license.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <CompanyData.mqh>

bool  ValidLicence(string licence = ""){ 

   bool valid = false;
   
   #ifdef LIC_TRADE_MODES
   
      valid                   =  false;
      int   validModes[]      =  LIC_TRADE_MODES;
      long  accountTradeMode  =  AccountInfoInteger(ACCOUNT_TRADE_MODE);
      
      for (int i = ArraySize(validModes)-1; i >= 0; i--){
      
         if (accountTradeMode == validModes[i]){
         
            valid = true;
            
               break;
         
         }
      }
      
      if (!valid){
            
         string compatability = (string)accountTradeMode;
         
            MessageBox("This is an invalid account type."+"\n"+
            
               "\nThe EA will only work on the account type "+compatability+" account types."+"\n"+
               
                  "\nPlease contact the developer to change the account compatability.","Blue City Capital® | Invalid Account Type",MB_OK | MB_ICONSTOP);
            
                     Print("This is a limited trial version. This will not work on this type of account.");
                     
                        return(false);
      
      }       
      
   #endif
   
   #ifdef LIC_EXPIRES_DAYS
   
      #ifndef LIC_EXPIRES_START
      
         #define LIC_EXPIRES_START  __DATETIME__
      
      #endif
      
      datetime expiredDate = (LIC_EXPIRES_START + (LIC_EXPIRES_DAYS * 86400));
            
         PrintFormat("Time Limited copy, license to use expires at %s", TimeToString(expiredDate));
         
            if (TimeCurrent() > expiredDate){
            
               Print("License to use expired");
               
                  PlaySound("\\Files\\error_sound.wav");
                        
                     MessageBox("Your Product Licence Key has now expired.\n\nPlease speak to your administrator for a new Product Licence Key.",HeaderInformation+"Hold up Dawg!",MB_ICONSTOP | MB_OK);
                     
                           return(false);
            
            }
               
   #endif
   
   #ifdef LIC_PRIVATE_KEY
   
      long     account              = AccountInfoInteger(ACCOUNT_LOGIN);
      string   result               = GenerateKey(IntegerToString(account),LIC_PRIVATE_KEY);
      string   NoLicenceHeader      = HeaderInformation + "No Product Licence Key Entered";
      string   InvalidLicenceHeader = HeaderInformation + "Incorrect Licence Key";
                  
      if (result != licence){

         PlaySound("\\Files\\error_sound.wav");

         MessageBox("You have entered an incorrect Product Licence Key. Your EA will now deinitialize."+"\n"+
            
            "\nPlease speak to your adiminstrator for a new Product Licence Key by messaging developers@"+CompanyDomain,InvalidLicenceHeader,MB_ICONERROR | MB_OK
         
         );
         
         return(false);

      }
                   
   #endif 
   
   return(true);

}
//---
//This will generate the 44 charachter Product Licence Key, not to be confused with your Customer Number (Unique ID)
string GenerateKey(string account, string privatekey){
   
   uchar accountChar [];
   
      StringToCharArray(account+privatekey, accountChar);
   
   uchar keyChar[];
   
      StringToCharArray(privatekey, keyChar);
   
   uchar resultChar[];
   
      CryptEncode(CRYPT_HASH_SHA256, accountChar, keyChar, resultChar);
   
         CryptEncode(CRYPT_BASE64, resultChar, resultChar, resultChar); 
         
            string   result   =  CharArrayToString(resultChar);            
      
   return(result);
   
}
//---

