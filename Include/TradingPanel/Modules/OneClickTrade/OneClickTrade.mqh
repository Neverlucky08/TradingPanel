#ifdef USE_ONE_CLICK_TRADE
#ifndef __ONE_CLICK_TRADE_MQH__
#define __ONE_CLICK_TRADE_MQH__

#include <Trade/Trade.mqh>
#include <TradingPanel/Modules/OneClickTrade/OneClickTradeView.mqh>

class COneClickTrade
{
private:
   CEventBus             *m_bus;
   CThemeManager         *m_theme;
   COneClickTradeView     m_view;
   CTrade                 m_trade;
   bool                   m_confirm;

public:
   COneClickTrade() : m_bus(NULL), m_theme(NULL), m_confirm(false) {}

   bool Init(CEventBus &bus, CThemeManager &theme, bool confirm_orders = false)
   {
      m_bus     = &bus;
      m_theme   = &theme;
      m_confirm = confirm_orders;
      m_view.Create(theme);
      return (true);
   }

   //---------------------------------------------------------------------------

   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      if (id != CHARTEVENT_OBJECT_CLICK)
         return;

      const string obj = sparam;
      if (StringFind(obj, "TP_OC_") != 0)
         return;

      ENUM_ORDER_TYPE action = ORDER_TYPE_BUY; // por defecto
      bool ok = false;

      if (obj == "TP_OC_BUY")        ok = SendOrder(ORDER_TYPE_BUY);
      else if (obj == "TP_OC_SELL")  ok = SendOrder(ORDER_TYPE_SELL);
      else if (obj == "TP_OC_REV")   Print(">> Reverse not implementado aún");
      else if (obj == "TP_OC_CLOSE") Print(">> Close not implementado aún");
      else if (obj == "TP_OC_CLOSEP")Print(">> Close% no implementado aún");

      if (ok)
         Print("Orden enviada desde ", obj);
   }

   //---------------------------------------------------------------------------

   bool SendOrder(const ENUM_ORDER_TYPE type)
   {
      if (m_confirm && !MessageBox("¿Enviar orden?", "Confirmar", MB_YESNO | MB_ICONQUESTION))
         return (false);

      double lot = 0.01;          // placeholder – aquí se integrará RiskLotSizer
      double price = (type == ORDER_TYPE_BUY ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                                             : SymbolInfoDouble(_Symbol, SYMBOL_BID));

      // Versión asíncrona para MT5
      m_trade.SetExpertMagicNumber(987654);
      bool sent = m_trade.PositionOpen(_Symbol, type, lot, price, 0, 0);

      if (!sent)
         Print("Error al enviar orden: ", GetLastError());

      return (sent);
   }

   //---------------------------------------------------------------------------

   void Cleanup() { m_view.Cleanup(); }
};

#endif // __ONE_CLICK_TRADE_MQH__
#endif // USE_ONE_CLICK_TRADE
