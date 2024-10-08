//+------------------------------------------------------------------+
//|                                              EmailAttributes.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

string   CompanyName                =  "Blue City Capital Technologies, Inc";
string   CompanyLegalAddress        =  "#14395 8 The Green, Dover, DE 19901";
string   CompanyContactAddress      =  "303 Twin Dolphin Drive,Redwood Shores,Redwood City, CA 94065";
string   CompanyRegData             =  "Registered in the State of Delaware under Section 102 of the General Corporation Law of the State of Delaware, Company Number 3215522";
string   CompanyDomain              =  "bluecitycapital.com"; 
string   CompanyRaiseTicket         =  "hello@"+CompanyDomain;
string   CompanyEngineeringTicket   =  "engineering@"+CompanyDomain;
string   CompanyReportAbuse         =  "abuse@"+CompanyDomain;
string   CompanyWebAddress          =  "www."+CompanyDomain;
string   ContactInformation         =  "This email originates from "+CompanyName+" "+CompanyLegalAddress+" | "+CompanyRegData;
string   CompanyPrivacyURL          =  "https://www."+CompanyDomain+"/legal/privacy/privacy-statement";
string   HeaderInformation          =  " | "+CompanyName;
string   LicenceInformationStatus   =  "Licence Check Status "+HeaderInformation;
string   CompanyHelpInstructions    =  "If the issue persists, please contact us at "+CompanyEngineeringTicket+", or you can go to www."+CompanyDomain+" & select 'Speak with us' at the buttom of the page.\n\nYours sincerely\n\n"+CompanyName;
string   CompanySignOff             =  "You can always raise a help ticket by emailing "+CompanyRaiseTicket+"\n\nYours sincerely\n\n"+CompanyName;
string   MQHScript                  =  " | MQH Script";

string LegalFooterDisclaimer(){
   //---
   //This contains the privacy and identification and identification information about the company in the event that an unauthorized party becomes privy to the contents of this email.
   string Message =  "This automated email is intended for the recipient stated at the address at the top of this email. If you have received this in error, please forward this email immediately to dpo@"+CompanyDomain+", then delete this from your email cliet. You can also reply to this message if you need any assistence. If you have any queries, you can raise a ticket by messaging us on "+CompanyRaiseTicket+"\n\nTo view a copy of our privacy policy, you can head over to "+CompanyPrivacyURL+"\r\rThis message has originated from "+CompanyName +"\r\rThis email has been sent from an unmonitoried address, so please do not reply directly to this email.\r\rThis message is only intended for the recipient(s) stated at the top of this message. If you have received this message in error, we wholeheartedly apologise. Please forward this message to dpo@"+CompanyDomain+" if you were not expecting to receive this message.\r\rYou are receiving this message because the email address at the top of this e-mail was included in the terminal settings of either your MQL4 or MQL5 terminal\r\rYou can read our Privacy Policy by visiting "+CompanyPrivacyURL+"\r\rOur legal address is "+CompanyLegalAddress+" & our trading address is "+CompanyContactAddress+"\r\r"+CompanyRegData;
   
   return Message;

}