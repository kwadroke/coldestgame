#include "PlayerData.h"

PlayerData::PlayerData(list<DynamicObject>& dynobjs)
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
   dynobj = &dynobjs;
   legs = torso = larm = rarm = dynobj->end();
   currweapon = Torso;
   ping = 0;
   temperature = 0.f;
   fallvelocity = 0.f;
   for (int i = 0; i < numbodyparts; ++i)
   {
      weapons.push_back(Empty);
      hp[i] = 100;
   }
}


void PlayerData::Disconnect()
{
   connected = false;
   spawned = false;
   dynobj->erase(legs);
   dynobj->erase(torso);
   dynobj->erase(larm);
   dynobj->erase(rarm);
   legs = torso = larm = rarm = dynobj->end();
}
