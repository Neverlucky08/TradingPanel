#ifndef __PRICE_SERVICE_MQH__
#define __PRICE_SERVICE_MQH__

// ----------------------------------------------------------------------------
//  PriceService  –  datos de spread y ATR en puntos, actualizados en tiempo real
// ----------------------------------------------------------------------------
class CPriceService
  {
private:
   string           m_symbol;
   ENUM_TIMEFRAMES  m_tf;
   double           m_spread_pts;   // spread actual en puntos
   double           m_atr_pts;      // ATR(14) en puntos
   int              m_handleATR;
   datetime         m_last_bar;

public:
                     CPriceService():
                        m_symbol(""),
                        m_tf(PERIOD_CURRENT),
                        m_spread_pts(0),
                        m_atr_pts(0),
                        m_handleATR(INVALID_HANDLE),
                        m_last_bar(0) {}

   //-----------------------------------------------------------------------
   /// Crear handle ATR y resetear cache
   bool Init(const string symbol,const ENUM_TIMEFRAMES tf=PERIOD_CURRENT)
     {
      m_symbol  = symbol;
      m_tf      = tf;
      m_handleATR = iATR(m_symbol,m_tf,14);
      m_last_bar  = 0;
      return(m_handleATR!=INVALID_HANDLE);
     }

   //-----------------------------------------------------------------------
   /// Llamar en cada tick
   void OnTick()
     {
      UpdateSpread();
     }

   //-----------------------------------------------------------------------
   /// Llamar desde OnTimer() (p.e. cada 1 s) para ATR
   void OnTimer()
     {
      datetime bar_time = iTime(m_symbol,m_tf,0);
      if(bar_time != m_last_bar)    // nueva vela
        {
         m_last_bar = bar_time;
         UpdateATR();
        }
     }

   //-----------------------------------------------------------------------
   double Spread() const { return m_spread_pts; }
   double ATR()    const { return m_atr_pts;    }

private:
   //-------------------------------------------------------------------
   void UpdateSpread()
     {
      double ask   = SymbolInfoDouble(m_symbol,SYMBOL_ASK);
      double bid   = SymbolInfoDouble(m_symbol,SYMBOL_BID);
      double point = SymbolInfoDouble(m_symbol,SYMBOL_POINT);
      if(point>0)
         m_spread_pts = (ask-bid)/point;
     }

   //-------------------------------------------------------------------
   void UpdateATR()
     {
      double buf[];
      if(CopyBuffer(m_handleATR,0,0,1,buf)==1)
        {
         double point = SymbolInfoDouble(m_symbol,SYMBOL_POINT);
         if(point>0)
            m_atr_pts = buf[0]/point;
        }
     }

   //-------------------------------------------------------------------
   //  Métodos ESTÁTICOS de utilidad  (no dependen de la instancia)
   //-------------------------------------------------------------------

public:
   // Valor aproximado (moneda de la cuenta) de mover 1 punto por lote
   static double LotValue(const string symbol)
     {
      double tick_val = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
      double tick_sz  = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
      return (tick_sz>0 ? tick_val / tick_sz : 0);
     }

   // Normaliza el lotaje al step / min / max del broker
   static double NormalizeLots(const string symbol,double lots)
     {
      double step = SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
      double min  = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
      double max  = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);

      if(step<=0) step = 0.01;                     // salvaguarda
      lots = MathFloor(lots/step+0.5)*step;        // redondeo al step
      lots = MathMax(min, MathMin(max, lots));     // clamp entre min y max
      return(lots);
     }

   // ATR(bars) en puntos (cálculo rápido, independiente de la instancia)
   static double ATR(const string symbol,
                     ENUM_TIMEFRAMES tf  = PERIOD_CURRENT,
                     const int bars      = 14)
     {
      int h = iATR(symbol, tf, bars);
      if(h == INVALID_HANDLE)
         return(0);

      double buf[];
      if(CopyBuffer(h, 0, 0, 1, buf) != 1)
         return(0);

      double point = SymbolInfoDouble(symbol,SYMBOL_POINT);
      return(point>0 ? buf[0] / point : 0);
     }
  };
#endif //__PRICE_SERVICE_MQH__
