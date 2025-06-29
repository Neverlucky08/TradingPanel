#ifndef __ONE_CLICK_TRADE_VIEW_MQH__
#define __ONE_CLICK_TRADE_VIEW_MQH__

#include <TradingPanel/Core/ThemeManager.mqh>

class COneClickTradeView
{
private:
   CThemeManager *m_theme;

public:
   COneClickTradeView(): m_theme(NULL) {}

   // Llamar desde App::OnInit
   bool Create(CThemeManager &theme)
   {
      m_theme = &theme;
      DrawButtons();
      return(true);
   }

   //-----------------------------------------------------------------------

   void DrawButtons()
   {
      struct BTN { string id; string txt; color bg; };
      BTN btns[5];

      btns[0].id = "TP_OC_BUY";    btns[0].txt = "BUY";     btns[0].bg = clrLime;
      btns[1].id = "TP_OC_SELL";   btns[1].txt = "SELL";    btns[1].bg = clrTomato;
      btns[2].id = "TP_OC_REV";    btns[2].txt = "REV";     btns[2].bg = clrGold;
      btns[3].id = "TP_OC_CLOSE";  btns[3].txt = "CLOSE";   btns[3].bg = clrSilver;
      btns[4].id = "TP_OC_CLOSEP"; btns[4].txt = "CLOSE %"; btns[4].bg = clrLightSlateGray;

      int x = 10, y = 50;
      for(int i = 0; i < ArraySize(btns); i++)
      {
         // Borrar si ya existe
         if(ObjectFind(0, btns[i].id) >= 0)
            ObjectDelete(0, btns[i].id);

         // Crear botón
         ObjectCreate(0, btns[i].id, OBJ_BUTTON, 0, 0, 0);
         ObjectSetInteger(0, btns[i].id, OBJPROP_CORNER,    CORNER_LEFT_UPPER);
         ObjectSetInteger(0, btns[i].id, OBJPROP_XDISTANCE,  x);
         ObjectSetInteger(0, btns[i].id, OBJPROP_YDISTANCE,  y);
         ObjectSetInteger(0, btns[i].id, OBJPROP_XSIZE,      60);
         ObjectSetInteger(0, btns[i].id, OBJPROP_YSIZE,      22);
         ObjectSetInteger(0, btns[i].id, OBJPROP_BGCOLOR,    btns[i].bg);
         // Aquí corregido: usamos Dark() en lugar de IsDark()
         ObjectSetInteger(0, btns[i].id, OBJPROP_COLOR,
            m_theme.Dark() ? clrWhite : clrBlack);
         ObjectSetString (0, btns[i].id, OBJPROP_TEXT,       btns[i].txt);

         x += 70;
      }
      ChartRedraw(0);
   }

   //-----------------------------------------------------------------------

   // Llamar desde App::OnDeinit para borrar botones
   void Cleanup()
   {
      string prefix = "TP_OC_";
      for(int i = ObjectsTotal(0,0)-1; i >= 0; i--)
      {
         string name = ObjectName(0, i, 0);
         if(StringFind(name, prefix) == 0)
            ObjectDelete(0, name);
      }
   }
};

#endif // __ONE_CLICK_TRADE_VIEW_MQH__
