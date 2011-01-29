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


#ifndef __BOT_H
#define __BOT_H

#include <list>
#include <boost/shared_ptr.hpp>
#include <SDL/SDL_net.h>
#include "IDGen.h"
#include "Packet.h"
#include "util.h"
#include "globals.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Bot{
   public:
      Bot();
      ~Bot();
   
   private:
      bool botrunning;
      UDPsocket socket;
      UDPpacket* packet;
      IPaddress addr;
      IDGen sendpacketnum;
      
      Uint32 lasttick;
      bool needconnect, botconnected;
      list<Packet> sendqueue;
      
      int playernum;
      Meshlist dummymeshes;
      PlayerData bot;
      vector<SpawnPointData> spawns;
      Timer timer;
      Timer movetimer;
      
      int id;
      SDL_Thread* thread;
      
      // Don't really want to copy this object because threads would need
      // to be restarted every time.  To use in an STL container use
      // smart pointers
      Bot(const Bot&);
      Bot& operator=(const Bot&);
      
      static int Start(void*);
      void Update();
      void Loop();
      void Send();
      void Listen();
      void HandleAck(unsigned long);
      string FillUpdatePacket();
};

typedef boost::shared_ptr<Bot> BotPtr;

#endif
