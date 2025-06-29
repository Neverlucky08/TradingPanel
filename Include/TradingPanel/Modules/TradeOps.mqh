#ifdef USE_TRADE_OPS
#ifndef __TRADE_OPS_MQH__
#define __TRADE_OPS_MQH__

#include <Trade/Trade.mqh>
#include <TradingPanel/Core/PriceService.mqh>
#include <TradingPanel/Modules/RiskLotSizer/RiskLotSizer.mqh>
#include <TradingPanel/Modules/SmartSLTP/SmartSLTP.mqh>
#include <TradingPanel/Ui/StatusBar.mqh>
#include <TradingPanel/Core/ThemeManager.mqh>

// Usamos instancias globales definidas en App.mq5:
extern CRiskLotSizer g_risk;
#ifdef USE_SMART_SLTP
 extern CSmartSLTP    g_sltp;
#endif
extern CThemeManager g_theme;

namespace TradeOps
{
static CTrade        _trade;

void Init(CRiskLotSizer &r, CSmartSLTP &s) { g_risk=&r; g_sltp=&s; }

//--------------------------------------------------
void Buy()
  {
    double vol = g_risk.CalcLots(200);
    _trade.SetTypeFilling(ORDER_FILLING_FOK);
    double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
#ifdef USE_SMART_SLTP
    g_sltp.Preview(price);
#endif
    _trade.Buy(vol, _Symbol, price, 0, 0, "OneClick BUY");
    StatusBar::Show("BUY ejecutado", 2, g_theme);
  }

void Sell()
  {
    double vol = g_risk.CalcLots(200);
    _trade.SetTypeFilling(ORDER_FILLING_FOK);
    double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
#ifdef USE_SMART_SLTP
    g_sltp.Preview(price);
#endif
    _trade.Sell(vol, _Symbol, price, 0, 0, "OneClick SELL");
    StatusBar::Show("SELL ejecutado", 2, g_theme);
  }

  void CloseAll()
  {
    for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(PositionGetSymbol(i) == _Symbol)
        _trade.PositionClose(PositionGetTicket(i));
    StatusBar::Show("Cerrado todo", 2, g_theme);
  }


void Reverse()
  {
    double totLots = 0;
    bool   wasBuy  = false;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(PositionGetSymbol(i) == _Symbol)
      {
        totLots += PositionGetDouble(POSITION_VOLUME);
        wasBuy   = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
        _trade.PositionClose(PositionGetTicket(i));
      }
    if(totLots <= 0) return;
    if(wasBuy) Sell(); else Buy();
    StatusBar::Show("Reversed", 2, g_theme);
  }
}
#endif
#endif
