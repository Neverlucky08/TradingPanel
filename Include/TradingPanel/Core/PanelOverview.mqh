#ifndef __PANEL_OVERVIEW_MQH__
#define __PANEL_OVERVIEW_MQH__

#include <TradingPanel/Core/ThemeManager.mqh>
#include <TradingPanel/Core/EventBus.mqh>

class CPanelOverview
{
private:
   long            m_chart;
   int             m_subwin;
   CThemeManager  *m_theme;
   CEventBus      *m_bus;

public:
   CPanelOverview() : m_chart(0), m_subwin(0), m_theme(NULL), m_bus(NULL) {}

   bool Create(long chart, int subwindow, CThemeManager &theme, CEventBus &bus)
   {
      m_chart  = chart;
      m_subwin = subwindow;
      m_theme  = &theme;
      m_bus    = &bus;

      Draw();
      return (true);
   }

   //---------------------------------------------------------------------------

   void Draw()
   {
      const string cats[4] = {"Trade", "Automation", "Analytics", "Tools"};
      int x = 10;

      for (int i = 0; i < 4; i++)
      {
         string name = "TP_OV_CAT_" + IntegerToString(i);

         if (ObjectFind(m_chart, name) >= 0)
            ObjectDelete(m_chart, name);

         ObjectCreate(m_chart, name, OBJ_RECTANGLE_LABEL, m_subwin, 0, 0);
         ObjectSetInteger(m_chart, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(m_chart, name, OBJPROP_ZORDER, 100);          // siempre al frente
         ObjectSetInteger(m_chart, name, OBJPROP_XDISTANCE, x);
         ObjectSetInteger(m_chart, name, OBJPROP_YDISTANCE, 10);
         ObjectSetInteger(m_chart, name, OBJPROP_XSIZE, 80);
         ObjectSetInteger(m_chart, name, OBJPROP_YSIZE, 24);
         ObjectSetInteger(m_chart, name, OBJPROP_BGCOLOR, m_theme.Bg());
         ObjectSetInteger(m_chart, name, OBJPROP_COLOR, m_theme.Dark() ? clrWhite : clrBlack);
         ObjectSetString (m_chart, name, OBJPROP_TEXT, cats[i]);

         x += 90;
      }
      ChartRedraw(m_chart);
   }

   //---------------------------------------------------------------------------

   /// Llamar desde OnChartEvent
   void HandleChartEvent(const int id)
   {
      if (id == CHARTEVENT_CHART_CHANGE)
         Draw();
   }

   //---------------------------------------------------------------------------

   /// Borrar objetos al quitar el EA
   void Cleanup()
   {
      for (int i = 0; i < 4; i++)
         ObjectDelete(m_chart, "TP_OV_CAT_" + IntegerToString(i));
   }
};

#endif // __PANEL_OVERVIEW_MQH__
