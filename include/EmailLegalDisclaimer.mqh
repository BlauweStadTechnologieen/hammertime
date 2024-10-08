//+------------------------------------------------------------------+
//|                                              EmailAttributes.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <CompanyData.mqh>

string EmailLegalDisclaimer(){

   string Message =  "This automated email is intended for the recipient stated at the address at the top of this email. If you have received this in error, please forward this email immediately to dpo@"+CompanyDomain+", then delete this from your email client. This is an unmonitored email address, please do not reply to this message. If you have any queries, you can raise a ticket by messaging us on "+CompanyRaiseTicket+"\n\nTo view a copy of our privacy policy, you can head over to "+CompanyPrivacyURL+"\r\rThis message has originated from "+CompanyName +"\r\rThis email has been sent from an unmonitoried address, so please do not reply directly to this email.\r\rThis message is only intended for the recipient(s) stated at the top of this message. If you have received this message in error, we wholeheartedly apologise. Please forward this message to dpo@"+CompanyDomain+" if you were not expecting to receive this message.\r\rYou are receiving this message because the email address at the top of this e-mail was included in the terminal settings of either your MQL4 or MQL5 terminal\r\rYou can read our Privacy Policy by visiting "+CompanyPrivacyURL+"\r\rOur legal address is "+CompanyLegalAddress+" & our trading address is "+CompanyContactAddress+"\r\r"+CompanyRegData;
   
   return Message;

};