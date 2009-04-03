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
      if (p.hp[i] > 0)
         p.mesh[i]->ReadState(position[currindex][i], rots[currindex][i], frame[currindex][i],
                           animtime[currindex][i], animspeed[currindex][i], size[currindex][i]);
   }
}

