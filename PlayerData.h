#ifndef __PLAYERDATA
#define __PLAYERDATA

#include "Vector3.h"
#include <list>
#include <set>
#include "SDL_net.h"
#include "DynamicObject.h"
#include "Hit.h"
#include "types.h"

struct PlayerData
{
   Vector3 pos;
   float pitch, rotation, roll, facing;
   bool moveforward, moveleft, moveright, moveback;
   bool leftclick, rightclick;
   list<DynamicObject>::iterator torso;
   list<DynamicObject>::iterator legs;
   list<DynamicObject>::iterator larm;
   list<DynamicObject>::iterator rarm;
   set<unsigned long> partids;
   set<unsigned long> hitids;
   set<unsigned long> acked;
   list<Hit> servhits;  // Used by server only
   vector<short> weapons;
   Uint32 lastupdate;  // How long since last player update?
   Uint32 lastmovetick;
   Uint32 lastfiretick;
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
   short hp;
   short kills, deaths;
};
#endif
