#ifndef __TP_BUTTON_MQH__
#define __TP_BUTTON_MQH__
#include <TradingPanel/Core/ThemeManager.mqh>

//-- estilos predefinidos
enum TP_BTN_STYLE { TP_NORMAL, TP_ACCENT, TP_ERROR };

//------------------------------------------------------------
//  TPButton – helper estático
//------------------------------------------------------------
namespace TPButton
{
void Create(const string  id,
            const string  text,
            int           x, int y, int w, int h,
            TP_BTN_STYLE  style,
            CThemeManager &theme)
{
   ObjectDelete(0,id);
   ObjectCreate(0,id,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,id,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,id,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,id,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,id,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,id,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,id,OBJPROP_BGCOLOR,
         (style==TP_ACCENT ? theme.Accent() :
          style==TP_ERROR  ? theme.Error()  : theme.Bg()));
   ObjectSetInteger(0,id,OBJPROP_COLOR,theme.Fg());
   ObjectSetInteger(0,id,OBJPROP_BORDER_COLOR,theme.Fg());
   ObjectSetString (0,id,OBJPROP_TEXT,text);
   ObjectSetInteger(0,id,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,id,OBJPROP_HIDDEN,true);
}
} // namespace
#endif //__TP_BUTTON_MQH__
