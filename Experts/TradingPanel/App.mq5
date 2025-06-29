// ============================================================================
// Trading-Panel – Expert Advisor  (Sprint 2 – versión funcional)
// Ruta:  MQL5\Experts\TradingPanel\App.mq5
// ============================================================================

#property copyright "DoItTrading"
#property link      "https://doittrading.com"
#property version   "1.20"

//––– Includes de compilación -------------------------------------------------
#include <Trade/Trade.mqh>
#include <TradingPanel/defines.mqh>

// Core
#include <TradingPanel/Core/EventBus.mqh>
#include <TradingPanel/Core/ConfigService.mqh>
#include <TradingPanel/Core/ThemeManager.mqh>
#include <TradingPanel/Core/WindowManager.mqh>
#include <TradingPanel/Core/PanelOverview.mqh>
#include <TradingPanel/Ui/TPButton.mqh>
#include <TradingPanel/Ui/StatusBar.mqh>

#ifdef USE_PRICE_SERVICE
 #include <TradingPanel/Core/PriceService.mqh>
#endif

// Módulos Sprint 1
#ifdef USE_ONE_CLICK_TRADE
 #include <TradingPanel/modules/OneClickTrade/OneClickTrade.mqh>
#endif
#ifdef USE_RISK_LOT_SIZER
 #include <TradingPanel/modules/RiskLotSizer/RiskLotSizer.mqh>
#endif
#ifdef USE_SMART_SLTP
 #include <TradingPanel/modules/SmartSLTP/SmartSLTP.mqh>
#endif

// Módulos Sprint 2
#ifdef USE_BREAKEVEN_MGR
 #include <TradingPanel/modules/BreakevenManager/BreakevenManager.mqh>
#endif
#ifdef USE_TRAILING_STOP_MGR
 #include <TradingPanel/modules/TrailingStopMgr/TrailingStopMgr.mqh>
#endif

#ifdef USE_TRADE_OPS
 #include <TradingPanel/modules/TradeOps.mqh>
#endif
#ifdef USE_MARKET_NAV
 #include <TradingPanel/modules/MarketNavigation.mqh>
#endif
#ifdef USE_HOTKEYS
 #include <TradingPanel/modules/Hotkeys.mqh>
#endif

//––– Inputs (solo para módulos activos) --------------------------------------
input bool   inp_ConfirmOrders  = false;   // OneClickTrade
input double inp_RiskPercent    = 1.50;    // RiskLotSizer
input int    inp_DefaultRR      = 2;       // SmartSLTP

input double inp_BE_TriggerPts  = 200;     // Breakeven (puntos)
input double inp_TS_TrailPts    = 200;     // Trailing Stop (puntos)

//––– Singletons / globales ----------------------------------------------------
CEventBus      g_bus;
CConfigService g_cfg;
CThemeManager  g_theme;
CWindowManager g_winmgr;
CPanelOverview g_overview;

#ifdef USE_PRICE_SERVICE
 CPriceService  g_price;
#endif

// Sprint 1
#ifdef USE_ONE_CLICK_TRADE
 COneClickTrade g_trade;
#endif
#ifdef USE_RISK_LOT_SIZER
 CRiskLotSizer  g_risk;
#endif
#ifdef USE_SMART_SLTP
 CSmartSLTP     g_sltp;
#endif

// Sprint 2
#ifdef USE_BREAKEVEN_MGR
 CBreakevenManager g_be;
#endif
#ifdef USE_TRAILING_STOP_MGR
 CTrailingStopMgr  g_ts;
#endif


//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   // Core ----------------------------------------------------------
   g_bus.Init(ChartID());
   g_theme.Detect();
   g_overview.Create(ChartID(),0,g_theme,g_bus);

#ifdef USE_PRICE_SERVICE
   g_price.Init(_Symbol,PERIOD_CURRENT);
#endif

   // Sprint 1 ------------------------------------------------------
#ifdef USE_ONE_CLICK_TRADE
   g_trade.Init(g_bus,g_theme,inp_ConfirmOrders);
#endif
#ifdef USE_RISK_LOT_SIZER
   g_risk.Init(inp_RiskPercent);                // solo % riesgo
#endif
#ifdef USE_SMART_SLTP
   g_sltp.Init(inp_DefaultRR);                  // solo RR por defecto
#endif

   // Sprint 2 ------------------------------------------------------
#ifdef USE_BREAKEVEN_MGR
   g_be.Init(inp_BE_TriggerPts);
#endif
#ifdef USE_TRAILING_STOP_MGR
   g_ts.Init(inp_TS_TrailPts);
#endif

#ifdef USE_MARKET_NAV
   MarketNav::Create();
#endif
#ifdef USE_TRADE_OPS
   TradeOps::Init(g_risk,g_sltp);
#endif
   EventSetTimer(1);    // heartbeat 1 s
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| OnTimer                                                          |
//+------------------------------------------------------------------+
void OnTimer()
{
#ifdef USE_PRICE_SERVICE
   g_price.OnTimer();          // actualiza ATR en barras nuevas
#endif
   StatusBar::OnTimer();
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
#ifdef USE_PRICE_SERVICE
   g_price.OnTick();           // calcula spread cada tick
#endif
#ifdef USE_BREAKEVEN_MGR
   g_be.OnTick();              // mueve a BE si procede
#endif
#ifdef USE_TRAILING_STOP_MGR
   g_ts.OnTick();              // arrastra SL fijo en pips
#endif
}

//+------------------------------------------------------------------+
//| OnChartEvent                                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   g_overview.HandleChartEvent(id);

#ifdef USE_ONE_CLICK_TRADE
   g_trade.OnChartEvent(id,lparam,dparam,sparam);
#endif
#ifdef USE_HOTKEYS
   if(id==CHARTEVENT_KEYDOWN)
      Hotkeys::HandleKey((int)lparam);
#endif
   if(id==CHARTEVENT_OBJECT_CLICK)
   {
#ifdef USE_MARKET_NAV
      MarketNav::HandleClick(sparam);
#endif
   }
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();

   g_overview.Cleanup();

#ifdef USE_ONE_CLICK_TRADE
   g_trade.Cleanup();
#endif
#ifdef USE_SMART_SLTP
   g_sltp.Cleanup();
#endif
}
