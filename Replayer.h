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
// Copyright 2008, 2011 Ben Nemec
// @End License@
#ifndef REPLAYER_H
#define REPLAYER_H

#include <fstream>
#include <SDL/SDL.h>
#include <boost/shared_ptr.hpp>
#include "PlayerData.h"
#include "Item.h"
#include "Timer.h"

using boost::shared_ptr;

class Replayer
{
   public:
      Replayer();
      void SetActive(const string&, const bool a = true);
      bool Active() {return active;}
      void Update();

   private:
      void ReadPlayers();
      void ReadShots();
      void ReadHits();
      void ReadItems();
      void EnsurePlayerSize(const size_t);
      
      bool active, first;
      Uint32 starttick, filetick;
      Timer timer;
      size_t framecount;

      ifstream read;
};

typedef shared_ptr<Replayer> ReplayerPtr;

#endif // REPLAYER_H
