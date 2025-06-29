#ifdef USE_BREAKEVEN_MGR
#ifndef __BREAKEVEN_MGR_MQH__
#define __BREAKEVEN_MGR_MQH__

#include <Trade/Trade.mqh>            //  ← añadir
class CBreakevenManager
  {
private:
   double m_trigger_pts;
   CTrade m_trade;                    //  ← añadir
public:
               CBreakevenManager():m_trigger_pts(200){}
   bool        Init(double triggerPts){ m_trigger_pts=triggerPts; return(true);}  

   void        OnTick()
     {
      if(!PositionSelect(_Symbol)) return;
      double open = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl   = PositionGetDouble(POSITION_SL);
      double bid  = SymbolInfoDouble(_Symbol,SYMBOL_BID);

      if((bid-open)/_Point >= m_trigger_pts && sl<open)
         m_trade.PositionModify(               //  ← usar m_trade
               PositionGetInteger(POSITION_TICKET),
               open,
               PositionGetDouble(POSITION_TP));
     }
  };

#endif //__BREAKEVEN_MGR_MQH__
#endif //USE_BREAKEVEN_MGR
