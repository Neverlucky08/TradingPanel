// ============================================================================
// Trading Panel – Compile‑time feature toggles
// ============================================================================

// Core systems (always on)
#define USE_EVENT_BUS
#define USE_CONFIG_SERVICE
#define USE_THEME_MANAGER
#define USE_WINDOW_MANAGER
#define USE_PANEL_OVERVIEW

// Sprint‑1 modules
#define USE_ONE_CLICK_TRADE
#define USE_RISK_LOT_SIZER
#define USE_SMART_SLTP

// Sprint‑2 automation flags
#define USE_PRICE_SERVICE
#define USE_BREAKEVEN_MGR
#define USE_TRAILING_STOP_MGR

// ===== añadir al final de defines.mqh ============================
#define USE_TRADE_OPS        // Buy / Sell / Close / Reverse
#define USE_MARKET_NAV       // Watch‑list & timeframe buttons
#define USE_HOTKEYS          // Keyboard shortcuts (B, S, C, R)