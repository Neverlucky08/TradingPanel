#ifdef USE_TRAILING_STOP_MGR
#ifndef __TRAILING_STOP_MGR_MQH__
#define __TRAILING_STOP_MGR_MQH__

#include <Trade/Trade.mqh>            //  ← añadir
class CTrailingStopMgr
  {
private:
   double m_trail_pts;
   CTrade m_trade;                    //  ← añadir
public:
               CTrailingStopMgr():m_trail_pts(200){}
   bool        Init(double trailPts){ m_trail_pts=trailPts; return(true);}  

   void        OnTick()
     {
      if(!PositionSelect(_Symbol)) return;
      double bid  = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double sl   = PositionGetDouble(POSITION_SL);
      double new_sl = bid - m_trail_pts*_Point;

      if(new_sl > sl)
         m_trade.PositionModify(      //  ← usar m_trade
               PositionGetInteger(POSITION_TICKET),
               new_sl,
               PositionGetDouble(POSITION_TP));
     }
  };

#endif //__TRAILING_STOP_MGR_MQH__
#endif //USE_TRAILING_STOP_MGR
