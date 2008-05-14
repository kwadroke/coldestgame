#include "PlayerData.h"

PlayerData::PlayerData(Meshlist& ml) : name("Nooblet"), team(1), spawnpacketnum(0), mesh(numbodyparts, ml.end())
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
   lastmovetick = ticks;
   pos = Vector3();
   pitch = roll = rotation = facing = 0.f;
   moveleft = moveright = moveforward = moveback = false;
   size = 0;
   lastfiretick = 0;
   leftclick = rightclick = run = false;
   meshes = &ml;
   currweapon = Torso;
   ping = 0;
   temperature = 0.f;
   fallvelocity = 0.f;
   Weapon none(Weapon::NoWeapon);
   for (int i = 0; i < numbodyparts; ++i)
   {
      weapons.push_back(none);
      hp[i] = 100;
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
