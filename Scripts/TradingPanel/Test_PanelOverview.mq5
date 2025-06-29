// Creates PanelOverview standalone on the current chart
#include <TradingPanel/core/EventBus.mqh>
#include <TradingPanel/core/ThemeManager.mqh>
#include <TradingPanel/core/PanelOverview.mqh>

void OnStart()
{
   CEventBus bus;        bus.Init(ChartID());
   CThemeManager theme;  theme.Detect();
   CPanelOverview ov;
   ov.Create(ChartID(), 0, theme, bus);
   Print("PanelOverview drawn – check nav bar on chart");
}