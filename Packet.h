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


#ifndef __PACKET_H
#define __PACKET_H

#include <string>
#include <sstream>
#include <SDL_net.h>
#include "logout.h"

using namespace std;

class Packet
{
   public:
      Packet(IPaddress* address = NULL, string s = "");
      template <typename T>
      Packet& operator<<(const T&);
      
      template <typename T>
      Packet& operator<<(T&);
      size_t Send(UDPpacket*, UDPsocket&);
      IPaddress addr;
      string data;
      unsigned long ack;
      int attempts;
      Uint32 sendtick, lastsent;
      unsigned long sendinterval;
      static int laghax;
};

// Need both a const and non-const version of this function.
// The full reasons are not clear to me, but I need to be able to pass in non-const objects
// (IDGen is nonsensical as a const object) and const built-ins such as 0 seem to require
// that there be a const version as well.
template <typename T>
Packet& Packet::operator<<(const T& s)
{
   stringstream write;
   write << s;
   data += write.str();
   return *this;
}

template <typename T>
Packet& Packet::operator<<(T& s)
{
   stringstream write;
   write << s;
   data += write.str();
   return *this;
}

const char eol = '\n';

#endif
