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
// Copyright 2008-2012 Ben Nemec
// @End License@
#ifndef BOTNETCODE_H
#define BOTNETCODE_H

#include "NetCode.h"
#include "Timer.h"
#include "types.h"
#include "globals.h"
#include <boost/shared_ptr.hpp>


class BotNetCode : public NetCode
{
   public:
      BotNetCode();
      void SendFire();
      int PlayerNum() {return playernum;}
      
      Meshlist dummymeshes; // Has to be before bot so it gets initialized first
      PlayerData bot;
      pid_t id;
      size_t attacker;

   protected:
      virtual void HandlePacket(stringstream&);
      virtual void Send();
      
      string FillUpdatePacket();
      void SendSpawnRequest();
      
      void ReadConnect(stringstream&);
      void ReadTeamChange(stringstream&);
      void ReadAck(stringstream&);
      void ReadSpawnRequest(stringstream&);
      void ReadPing();
      void ReadDeath(stringstream&);
      void ReadDamage(stringstream&);
      
      bool connected, needconnect;
      int playernum;
      string map;
      Timer sendtimer;
      Timer respawntimer;
      vector<SpawnPointData> spawns;
};

typedef boost::shared_ptr<BotNetCode> BotNetCodePtr;

#endif // BOTNETCODE_H
