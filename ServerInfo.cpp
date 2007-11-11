#include "ServerInfo.h"

ServerInfo::ServerInfo()
{
   address.host = INADDR_NONE;
   name = "";
   map = "";
   strip = "-1.-1.-1.-1";
   players = 0;
   maxplayers = 0;
   ping = 0;
   inlist = false;
   haveinfo = false;
}


bool ServerInfo::operator<(const ServerInfo& o) const
{
   if (address.host < o.address.host) return true;
   if (address.host > o.address.host) return false;
   return address.port < o.address.port;
}
