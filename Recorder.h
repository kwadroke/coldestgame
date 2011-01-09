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
#ifndef RECORDER_H
#define RECORDER_H

#include <vector>
#include <set>
#include <fstream>
#include <boost/shared_ptr.hpp>
#include "SDL.h"
#include "PlayerData.h"
#include "Particle.h"
#include "Timer.h"

using std::vector;
using std::set;
using boost::shared_ptr;

class Recorder
{
   public:
      Recorder();
      void SetActive(bool);
      void AddShot(const size_t, const unsigned long);
      void AddHit(const Vector3&, const int);
      void AddItem(const Item&);

      void WriteFrame(bool reset = true);
      void Reset();

      static size_t CountSpawnedPlayers();

      static const int version, minor;

   private:
      string GetFilename();
      void WritePlayers();
      void WriteOccasional();
      void WriteShots();
      void WriteHits();
      void WriteItems();

      vector<size_t> shotplayer;
      vector<unsigned long> shots;
      Vector3vec hitpos;
      intvec hittype;
      vector<Item> newitem;
      
      Uint32 starttick;
      bool active;
      Timer frametimer, occtimer;

      ofstream write;
      ifstream read;
};

typedef shared_ptr<Recorder> RecorderPtr;

#endif // RECORDER_H
