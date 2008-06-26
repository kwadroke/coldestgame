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

class PlayerData
{
   public:
      PlayerData(Meshlist&);
      void Disconnect();
      void Kill();
      
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
      set<unsigned long> partids;
      set<unsigned long> acked;
      vector<Weapon> weapons;
      Item item;
      Uint32 lastupdate;  // How long since last player update?
      Uint32 lastmovetick;
      Uint32 lastfiretick;
      Uint32 lastcoolingtick;
      float size;
      float fallvelocity;
      short id;
      IPaddress addr;
      bool connected;
      unsigned long recpacketnum;
      unsigned long spawnpacketnum;
      short unit;
      short currweapon;
      short pingtick;
      short ping;
      short hp[numbodyparts];
      short kills, deaths;
      short team;
      float temperature;
      string name;
      int salvage;
      int powerdowntime;
      float healaccum;
      
   private:
      Meshlist* meshes;
};
#endif
