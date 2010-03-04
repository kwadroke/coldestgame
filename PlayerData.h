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


#ifndef __PLAYERDATA
#define __PLAYERDATA

#include "Vector3.h"
#include <list>
#include <set>
#include "SDL_net.h"
#include "Mesh.h"
#include "Hit.h"
#include "types.h"
#include "Weapon.h"
#include "Item.h"
#include "ALSource.h"
#include "Particle.h"

class PlayerData
{
   public:
      PlayerData(Meshlist&);
      void Disconnect();
      void Kill();
      void Reset();
      void PlayFireSound(ALBufferPtr);
      
      Vector3 pos;
      Vector3 clientpos; // So server can keep track of both
      float pitch, rotation, roll, facing;
      float speed;
      float turnspeed;
      bool moveforward, moveleft, moveright, moveback;
      bool leftclick, rightclick;
      bool run;
      bool spawned;
      bool needsync;
      vector<Meshlist::iterator> mesh;
      Meshlist::iterator rendermesh;
      Particle* indicator;
      set<unsigned long> partids;
      set<unsigned long> acked;
      set<unsigned long> commandids;
      set<unsigned long> fireids;
      int firerequests;
      vector<Weapon> weapons;
      Item item;
      Uint32 lastupdate;
      Uint32 lastmovetick;
      vector<Uint32> lastfiretick;
      Uint32 lastcoolingtick;
      int spawntimer;
      float size;
      float fallvelocity;
      short id;
      IPaddress addr;
      bool connected;
      unsigned long recpacketnum;
      short unit;
      short currweapon;
      short pingtick;
      short ping;
      intvec hp;
      vector<bool> destroyed;
      short kills, deaths;
      short team;
      float temperature;
      string name;
      int salvage;
      int powerdowntime;
      float healaccum;
      // weight can be set to negative to cause a player to fall up, such as when ejecting
      float weight;
      bool spectate;
      bool admin;
      
   private:
      Meshlist* meshes;
};
#endif
