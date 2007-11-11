#ifndef __SERVERINFO_H
#define __SERVERINFO_H

#include "SDL_net.h"
#include <string>

using std::string;

class ServerInfo
{
   public:
      ServerInfo();
      bool operator<(const ServerInfo&) const;
      
      bool inlist, haveinfo;
      int players, maxplayers, ping;
      Uint32 tick;
      string name;
      string map;
      string strip;
      IPaddress address;
      
};

#endif
