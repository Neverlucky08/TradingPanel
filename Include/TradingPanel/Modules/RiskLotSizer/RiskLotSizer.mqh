#ifdef USE_RISK_LOT_SIZER
#ifndef __RISK_LOT_SIZER_MQH__
#define __RISK_LOT_SIZER_MQH__

#include <TradingPanel/Core/PriceService.mqh>
#include <Trade/Trade.mqh>

enum ENUM_LOT_MODE { MODE_FIXED_LOT, MODE_PERCENT_BALANCE, MODE_PERCENT_EQUITY };

class CRiskLotSizer
  {
private:
   double          m_risk_pct;
   ENUM_LOT_MODE   m_mode;
public:
               CRiskLotSizer():m_risk_pct(1.0),m_mode(MODE_PERCENT_BALANCE){}
   bool        Init(const double defaultRisk,ENUM_LOT_MODE mode=MODE_PERCENT_BALANCE)
     {
      m_risk_pct = defaultRisk;
      m_mode     = mode;
      return(true);
     }
   // Devuelve lotes para un SL en puntos (no pips)
   double      CalcLots(const double sl_points)
     {
      if(sl_points<=0) return(0.01);

      double balance = (m_mode==MODE_PERCENT_EQUITY ? AccountInfoDouble(ACCOUNT_EQUITY)
                                                    : AccountInfoDouble(ACCOUNT_BALANCE));
      double risk_money = balance * (m_risk_pct/100.0);
      double lot_val    = CPriceService::LotValue(_Symbol);
      double loss_per_lot = sl_points * _Point * lot_val;
      if(loss_per_lot<=0) return(0.01);
      double lots = risk_money / loss_per_lot;
      return(CPriceService::NormalizeLots(_Symbol,lots));
     }
  };

#endif //__RISK_LOT_SIZER_MQH__
#endif //USE_RISK_LOT_SIZER