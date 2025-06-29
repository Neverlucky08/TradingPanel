// EventBus.mqh – Simple wrapper around EventChartCustom
#ifndef __EVENTBUS_MQH__
#define __EVENTBUS_MQH__

class CEventBus
  {
private:
   long  m_chart_id;
public:
         CEventBus():m_chart_id(0){}
   bool  Init(const long chart_id){ m_chart_id=chart_id; return(true);}  

   // Publish a custom chart event (id must be < 65 535)
   bool  Publish(const ushort event_id,const long lparam=0,const double dparam=0.0,const string sparam="")
     {
      // EventChartCustom expects: long, ushort, long, double, string
      return(EventChartCustom(m_chart_id,event_id,lparam,dparam,sparam));
     }
  };

#endif //__EVENTBUS_MQH__