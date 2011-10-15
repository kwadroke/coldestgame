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


#ifndef __SOUNDMANAGER_H
#define __SOUNDMANAGER_H

#include <map>
#include <string>
#include <list>
#include <vector>
#include "ALBuffer.h"
#include "ALSource.h"
#include "Vector3.h"
#include "SoundSource.h"
#include "types.h"

using std::map;
using std::string;
using std::list;
using std::vector;

typedef vector<ALSourcePtr> SourceList;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class SoundManager
{
   public:
      SoundManager();
      ALBufferPtr GetBuffer(const string&);
      void SetListenPos(Vector3&);
      void SetListenDir(Vector3&);
      void SetPosition(const Vector3&, SoundSource*);
      void SetGain(const float, SoundSource*);
      void StopSource(SoundSource*);
      SoundSourcePtr PlaySound(const string&, const Vector3&, const bool loop = false, const bool relative = false);
      ALSourcePtr GetSource(const string&);
      void SetMaxSources(const size_t);
      void SetVolume(const float);
      
   private:
      SoundManager(const SoundManager&);
      SoundManager& operator=(const SoundManager&);
      size_t SelectSource(const Vector3&);
      
      map<string, ALBufferPtr> buffers;
      SourceList sources;
      Vector3 listenpos;

};

#endif
