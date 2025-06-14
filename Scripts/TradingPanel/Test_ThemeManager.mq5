// Verifies that ThemeManager detects dark/light background
#include <TradingPanel/core/ThemeManager.mqh>

void OnStart()
{
   CThemeManager theme;
   theme.Detect();
   Print("Dark mode detected = ", (bool)theme.IsDark());
   Print("Background color = ", ColorToString(theme.Bg(), true));
}