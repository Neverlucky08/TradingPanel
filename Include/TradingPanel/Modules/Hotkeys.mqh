#ifdef USE_HOTKEYS
#ifndef __HOTKEYS_MQH__
#define __HOTKEYS_MQH__

#include <TradingPanel/Modules/TradeOps.mqh>

namespace Hotkeys
{
void HandleKey(int code)
{
   switch(code)
   {
      case 66: TradeOps::Buy();   break;   // B
      case 83: TradeOps::Sell();  break;   // S
      case 67: TradeOps::CloseAll();break; // C
      case 82: TradeOps::Reverse(); break; // R
   }
}
}

#endif //__HOTKEYS_MQH__
#endif //USE_HOTKEYS