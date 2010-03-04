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
      void Add(const PlayerData&, const size_t, Meshlist::iterator);
      
      vector<Vector3vec> position;
      vector<Vector3vec> rots;
      vector<intvec> frame;
      vector<intvec> animtime;
      vector<floatvec> animspeed;
      vector<floatvec> size;
      vector<size_t> index;
      Uint32 tick;
};

#endif
