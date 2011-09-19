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
#include "BotNetCode.h"
#include "util.h"
#include "globals.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Bot{
   public:
      Bot();
      ~Bot();
      
      static void Initialize();
      static void SetPlayers(vector<PlayerData>&);
      static vector<PlayerData> GetPlayers();
   
   private:
      bool botrunning;
      
      BotNetCodePtr netcode;
      
      Uint32 lasttick;
      
      Timer timer;
      Timer movetimer;
      Timer firetimer;
      
      SDL_Thread* thread;
      
      static vector<PlayerData> players;
      static MutexPtr playermutex;
      
      // Don't really want to copy this object because threads would need
      // to be restarted every time.  To use in an STL container use
      // smart pointers
      Bot(const Bot&);
      Bot& operator=(const Bot&);
      
      static int Start(void*);
      void Update();
      void Loop();
};

typedef boost::shared_ptr<Bot> BotPtr;

#endif
