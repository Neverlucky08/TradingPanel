#ifdef USE_MARKET_NAV
#ifndef __MARKET_NAV_MQH__
#define __MARKET_NAV_MQH__

namespace MarketNav
{
string Symbols[] = {"EURUSD","GBPUSD","USDJPY","AUDUSD","XAUUSD"};
static ENUM_TIMEFRAMES TFs[] = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_H1,PERIOD_H4,PERIOD_D1};

string TfStr(ENUM_TIMEFRAMES tf)
{
   switch(tf){case PERIOD_M1:return"M1";case PERIOD_M5:return"M5";
   case PERIOD_M15:return"M15";case PERIOD_H1:return"H1";
   case PERIOD_H4:return"H4";case PERIOD_D1:return"D1";} return"?";
}

void Create()
{
   int y=40;
   for(int i=0;i<ArraySize(Symbols);i++)
   {
      string id="Sym_"+Symbols[i];
      ObjectCreate(0,id,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,id,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,id,OBJPROP_XDISTANCE,10);
      ObjectSetInteger(0,id,OBJPROP_YDISTANCE,y);
      ObjectSetString (0,id,OBJPROP_TEXT,Symbols[i]);
      y+=18;
   }
   int x=120;
   for(int j=0;j<ArraySize(TFs);j++)
   {
      string tfId="TF_"+IntegerToString((int)TFs[j]);
      ObjectCreate(0,tfId,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,tfId,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,tfId,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,tfId,OBJPROP_YDISTANCE,10);
      ObjectSetString (0,tfId,OBJPROP_TEXT,TfStr(TFs[j]));
      x+=35;
   }
   ChartRedraw(0);
}

//———————— Helpers ———————————
string TimeframeToString(ENUM_TIMEFRAMES tf)
{
   switch(tf){case PERIOD_M1:return "M1";case PERIOD_M5:return"M5";case PERIOD_M15:return"M15";case PERIOD_H1:return"H1";case PERIOD_H4:return"H4";case PERIOD_D1:return"D1";} return"?";}

ENUM_TIMEFRAMES StrToTF(const string id)
{
   int val=(int)StringToInteger(StringSubstr(id,3));
   return (ENUM_TIMEFRAMES)val;
}

//———————— Event handler ————
void HandleClick(const string obj)
{
   if(StringFind(obj,"Sym_")==0)
      ChartSetSymbolPeriod(0,StringSubstr(obj,4),Period());
   else if(StringFind(obj,"TF_")==0)
      ChartSetSymbolPeriod(0,NULL,StrToTF(obj));
}
}
#endif
#endif
