// Simple script to verify EventBus compiles and sends a message
#include <TradingPanel/defines.mqh>
#include <TradingPanel/core/EventBus.mqh>

void OnStart()
  {
   CEventBus bus;   bus.Init(ChartID());
   bus.Publish(123,1,0,"hello world");
   Print("Event sent!");
  }