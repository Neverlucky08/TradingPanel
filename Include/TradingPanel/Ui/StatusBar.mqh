#ifndef __STATUS_BAR_MQH__
#define __STATUS_BAR_MQH__
#include <TradingPanel/Core/ThemeManager.mqh>

namespace StatusBar
{
static datetime _until = 0;

void Show(const string msg,int secs,CThemeManager &theme)
{
   ObjectDelete(0,"TP_STATUS");
   ObjectCreate(0,"TP_STATUS",OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,"TP_STATUS",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"TP_STATUS",OBJPROP_XDISTANCE,10);
   ObjectSetInteger(0,"TP_STATUS",OBJPROP_YDISTANCE,ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)-30);
   ObjectSetInteger(0,"TP_STATUS",OBJPROP_BGCOLOR,theme.Bg());
   ObjectSetInteger(0,"TP_STATUS",OBJPROP_COLOR,theme.Fg());
   ObjectSetString (0,"TP_STATUS",OBJPROP_TEXT,msg);
   _until = TimeCurrent()+secs;
   ChartRedraw(0);
}

void OnTimer()
{
   if(_until>0 && TimeCurrent()>=_until)
   {
      ObjectDelete(0,"TP_STATUS");
      _until=0;
   }
}
}
#endif //__STATUS_BAR_MQH__
