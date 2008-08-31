#include "PlayerData.h"

PlayerData::PlayerData(Meshlist& ml) : name("Nooblet"), team(0), mesh(numbodyparts, ml.end()),
                       item(Item::NoItem, ml), speed(0.f), turnspeed(0.f), needsync(true), salvage(100), powerdowntime(0),
                       healaccum(0.f), firerequests(0), hp(intvec(numbodyparts, 100)), destroyed(numbodyparts, false), weight(1.f),
                       spectate(false), spawntimer(0)
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
   spawntimer = 15000;
}
