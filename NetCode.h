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
// Copyright 2008, 2011 Ben Nemec
// @End License@
#ifndef NETCODE_H
#define NETCODE_H

#include "Packet.h"
#include "IDGen.h"
#include "Timer.h"
#include <SDL_net.h>
#include <list>

using std::list;

class NetCode
{
   public:
      NetCode();
      virtual ~NetCode();
      virtual void Update();
      void SendPacket(Packet&);
      static int Version(){return version;}

   protected:
      // No copying
      NetCode(const NetCode&);
      NetCode& operator=(const NetCode&);
      virtual void HandlePacket(stringstream&){}
      void HandleAck(const unsigned long);
      void Ack(const unsigned long);
      virtual void Send(){}
      
      void SendLoop();
      
      virtual void Receive();
      virtual void ReceiveExtended(){}

      UDPsocket socket;
      UDPpacket* packet;
      IPaddress address;

      Uint32 lastnettick;
      Uint32 currnettick;
      IDGen sendpacketnum;
      bool error;

      stringstream get;
      string getdata;
      string packettype;
      unsigned long packetnum;

      const static int version;

      size_t sendbps;
      Timer sentbytestimer;

   private:
      list<Packet> sendqueue;
};

#endif // NETCODE_H
