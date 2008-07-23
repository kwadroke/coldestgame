#include "ServerState.h"

ServerState::ServerState(const Uint32 tickin) : tick(tickin)
{
}


void ServerState::Add(const PlayerData& p, size_t pindex)
{
   position.push_back(Vector3vec(numbodyparts));
   rots.push_back(Vector3vec(numbodyparts));
   frame.push_back(vector<int>(numbodyparts));
   animtime.push_back(vector<int>(numbodyparts));
   animspeed.push_back(vector<float>(numbodyparts));
   size.push_back(vector<float>(numbodyparts));
   index.push_back(pindex);
   
   size_t currindex = position.size() - 1;
   for (size_t i = 0; i < numbodyparts; ++i)
   {
      p.mesh[i]->ReadState(position[currindex][i], rots[currindex][i], frame[currindex][i],
                           animtime[currindex][i], animspeed[currindex][i], size[currindex][i]);
   }
}

