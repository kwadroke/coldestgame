// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2010 Ben Nemec
// @End License@


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
