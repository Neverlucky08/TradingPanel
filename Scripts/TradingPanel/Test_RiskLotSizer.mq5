// Test_RiskLotSizer.mq5
#include <TradingPanel/defines.mqh>                 //  Activa USE_RISK_LOT_SIZER
#include <TradingPanel/core/EventBus.mqh>
#include <TradingPanel/core/ThemeManager.mqh>
#include <TradingPanel/modules/RiskLotSizer/RiskLotSizer.mqh>

void OnStart()
{
   // Crear servicios dummy
   CEventBus bus;      bus.Init(ChartID());
   CThemeManager theme; theme.Detect();

   // Inicializar el módulo con 1 % de riesgo
   CRiskLotSizer rs;
   rs.Init(bus, theme, 1.0);

   // Calcular lotes para un SL hipotético de 200 puntos
   double lots = rs.CalcLots(200);
   Print("Lots calculados = ", lots);
}
