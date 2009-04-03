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


#include "PlayerData.h"

PlayerData::PlayerData(Meshlist& ml) : speed(0.f), turnspeed(0.f), needsync(true), mesh(numbodyparts, ml.end()), 
                       firerequests(0), item(Item::NoItem, ml), spawntimer(0), hp(intvec(numbodyparts, 100)), 
                       destroyed(numbodyparts, false), team(0), name("Nooblet"), salvage(100), powerdowntime(0),
                       healaccum(0.f), weight(1.f), spectate(false), admin(false)
{
   Uint32 ticks = 0;
   if (SDL_WasInit(SDL_INIT_TIMER))
   {
      ticks = SDL_GetTicks();
   }
   recpacketnum = 0;
   addr.host = INADDR_NONE;
   addr.port = 0; // Theoretically this should be 0 regardless of byte-order...but I could be wrong
   connected = false;
   spawned = false;
   lastupdate = ticks;
   unit = numunits;
   kills = 0;
   deaths = 0;
   lastmovetick = lastcoolingtick = ticks;
   pos = Vector3();
   pitch = roll = rotation = facing = 0.f;
   moveleft = moveright = moveforward = moveback = false;
   size = 0;
   leftclick = rightclick = run = false;
   meshes = &ml;
   currweapon = 0;
   ping = 0;
   temperature = 0.f;
   fallvelocity = 0.f;
   Weapon none(Weapon::NoWeapon);
   for (int i = 0; i < numbodyparts; ++i)
   {
      weapons.push_back(none);
      lastfiretick.push_back(0);
   }
}


void PlayerData::Disconnect()
{
   connected = false;
   Kill();
}


void PlayerData::Kill()
{
   spawned = false;
   leftclick = false;
   for (int part = 0; part < numbodyparts; ++part)
   {
      if (mesh[part] != meshes->end())
      {
         meshes->erase(mesh[part]);
         mesh[part] = meshes->end();
      }
   }
}


void PlayerData::Reset()
{
   pitch = roll = rotation = facing = 0.f;
   moveleft = moveright = moveforward = moveback = false;
   leftclick = rightclick = run = false;
   temperature = 0.f;
   fallvelocity = 0.f;
   currweapon = 0;
   speed = turnspeed = 0.f;
   destroyed = vector<bool>(numbodyparts, false);
   healaccum = 0.f;
   firerequests = 0;
   weight = 1.f;
}

