#ifndef __CONFIG_SERVICE_MQH__
#define __CONFIG_SERVICE_MQH__

class CConfigService
  {
public:
   bool   Load()              { return(true); }   // No JSON in Sprint‑1
   int    GetInt(const string key,const int def_val=0)   { return(def_val); }
   double GetDouble(const string key,const double def_val=0){ return(def_val); }
   bool   GetBool(const string key,const bool def_val=false){ return(def_val); }
  };

#endif //__CONFIG_SERVICE_MQH__