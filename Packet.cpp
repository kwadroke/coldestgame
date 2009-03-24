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
// Copyright 2008, 2009 Ben Nemec
// @End License@

#include "Packet.h"

int Packet::laghax = 0;

Packet::Packet(IPaddress* inaddr, string s) : ack(0), data(s),
               attempts(0), lastsent(0), sendinterval(100)
{
   if (inaddr)
      addr = *inaddr;
   else addr.host = INADDR_NONE;
   sendtick = SDL_GetTicks() + laghax;
}


void Packet::Send(UDPpacket* packet, UDPsocket& socket)
{
   if (!packet)
   {
      logout << "Send Error: null packet" << endl;
      return;
   }
   
   Uint32 currtick = SDL_GetTicks();
   if (currtick - lastsent < sendinterval) // Don't swamp the receiver with ack packets
      return;
   lastsent = currtick;
   
   packet->address = addr;
   strcpy((char*)packet->data, data.c_str());
   packet->len = data.length() + 1;
   
   SDLNet_UDP_Send(socket, -1, packet);
   ++attempts;
}

