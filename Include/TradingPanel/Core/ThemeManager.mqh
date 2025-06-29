#ifndef __THEME_MANAGER_MQH__
#define __THEME_MANAGER_MQH__

//––– Helpers RGB (24-bit BGR) ——————————————————————————
#define COLOR_R(c) ((uchar)((c)>>16))
#define COLOR_G(c) ((uchar)((c)>>8))
#define COLOR_B(c) ((uchar)((c)&0xFF))

#ifndef clrFirebrick
   #define clrFirebrick ((color)0x2222B2)
#endif

class CThemeManager
{
private:
   bool   m_dark;
   color  m_bg, m_fg, m_accent, m_error;

public:
            CThemeManager():m_dark(false){}
   void     Detect()
   {
      m_bg   = (color)ChartGetInteger(0,CHART_COLOR_BACKGROUND);
      m_dark = (COLOR_R(m_bg)+COLOR_G(m_bg)+COLOR_B(m_bg) < 3*128);

      m_fg     = (m_dark ? clrWhite      : clrBlack);
      m_accent = (m_dark ? clrLimeGreen  : clrForestGreen);
      m_error  = (m_dark ? clrTomato     : clrFirebrick);
   }

   color Bg()     const { return m_bg;     }
   color Fg()     const { return m_fg;     }
   color Accent() const { return m_accent; }
   color Error()  const { return m_error;  }
   bool  Dark()   const { return m_dark;   }
};

#endif //__THEME_MANAGER_MQH__
