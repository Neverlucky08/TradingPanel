#ifdef USE_SMART_SLTP
#ifndef __SMART_SLTP_MQH__
#define __SMART_SLTP_MQH__

#include <TradingPanel/Core/PriceService.mqh>

class CSmartSLTP
  {
private:
   int m_default_rr;   // RR por defecto (TP = RR × SL)
public:
               CSmartSLTP():m_default_rr(2){}
   bool        Init(const int defaultRR)
     { m_default_rr = defaultRR; return(true);}  

   // Dibuja líneas SL & TP previas basadas en SL_points
   void        Preview(const double sl_points)
     {
      double price = (PositionSelect(_Symbol) ? PositionGetDouble(POSITION_PRICE_OPEN) : SymbolInfoDouble(_Symbol,SYMBOL_BID));
      if(sl_points<=0) return;
      double sl = price - sl_points*_Point;
      double tp = price + sl_points*m_default_rr*_Point;
      ObjectDelete(0,"TP_PRE_SL");
      ObjectDelete(0,"TP_PRE_TP");
      ObjectCreate(0,"TP_PRE_SL",OBJ_HLINE,0,0,sl);
      ObjectCreate(0,"TP_PRE_TP",OBJ_HLINE,0,0,tp);
      ObjectSetInteger(0,"TP_PRE_SL",OBJPROP_COLOR,clrRed);
      ObjectSetInteger(0,"TP_PRE_TP",OBJPROP_COLOR,clrLime);
      ChartRedraw(0);
     }

   void Cleanup()
     {
      ObjectDelete(0,"TP_PRE_SL");
      ObjectDelete(0,"TP_PRE_TP");
     }
  };

#endif //__SMART_SLTP_MQH__
#endif //USE_SMART_SLTP