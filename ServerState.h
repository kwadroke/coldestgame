#ifndef __SERVERSTATE_H
#define __SERVERSTATE_H

#include "Vector3.h"
#include "PlayerData.h"
#include "types.h"
#include <vector>

using std::vector;

class ServerState
{
   public:
      ServerState(const Uint32);
      void Add(const PlayerData&, const size_t);
      
      vector<Vector3vec> position;
      vector<Vector3vec> rots;
      vector<vector<int> > frame;
      vector<vector<int> > animtime;
      vector<vector<float> > animspeed;
      vector<size_t> index;
      Uint32 tick;
};

#endif
