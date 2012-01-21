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
#include "PathNode.h"

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
      static void SetPathNodes(vector<PathNodePtr>& p) {pathnodes = p;}
      int Team() {return BotPlayer().team;}
      void SetAllSpawns(vector<SpawnPointData> s) {allspawns = s;}
      
      tsint baseattacker;
   
   private:
      bool botrunning;
      
      BotNetCodePtr netcode;
      
      Uint32 lasttick;
      
      Timer timer;
      Timer movetimer;
      Timer firetimer;
      Timer updatetimer;
      Timer targettimer;
      
      SDL_Thread* thread;
      
      vector<PlayerData> localplayers; // Thread-specific copy of players to avoid locking issues
      size_t targetplayer;
      vector<SpawnPointData> allspawns; // Netcode only gives us the ones for our team
      ssize_t targetspawn;
      
      Vector3 movetarget;
      PathNodePtr currpathnode;
      Vector3 heading;
      // Determines how close the bot wants to get - smaller numbers make it closer
      float closingdistance;
      
      static vector<PlayerData> players;
      static MutexPtr playermutex;
      static vector<PathNodePtr> pathnodes;
      
      // Don't really want to copy this object because threads would need
      // to be restarted every time.  To use in an STL container use
      // smart pointers
      Bot(const Bot&);
      Bot& operator=(const Bot&);
      
      static int Start(void*);
      void Update();
      void Loop();
      // Returns the PlayerData object that represents our current state (note that netcode->bot does not!)
      PlayerData& BotPlayer() {return localplayers[netcode->PlayerNum()];}
      
      size_t SelectTarget();
      size_t SelectTargetSpawn();
      void AimAtTarget(const Vector3&);
      void FindCurrPathNode();
      void UpdateHeading();
      void TurnToHeading();
      float SkillAverage() {return (console.GetFloat("botskillmax") + 1.f) / 2.f;}
      float SkillMax() {return console.GetFloat("botskillmax");}
      float Skill() {return console.GetFloat("botskill");}
};

typedef boost::shared_ptr<Bot> BotPtr;

#endif
