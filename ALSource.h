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


#ifndef __ALSOURCE_H
#define __ALSOURCE_H

#include "types.h"
#include "ALBuffer.h"
#include "SoundSource.h"
#include <boost/shared_ptr.hpp>

using boost::shared_ptr;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ALSource
{
   public:
      ALSource();
      ALSource(const ALSource&);
      ALSource& operator=(const ALSource&);
      ~ALSource();
      void Play(const ALBuffer&);
      void Play(const ALBufferPtr&);
      void Stop();
      void SetPosition(const Vector3&);
      void SetGain(const float);
      static void CheckError();
      bool Playing();
      
      Vector3 position;
      ALfloat pitch, gain;
      ALuint loop;
      ALfloat refdist;
      ALfloat maxdist;
      ALfloat rolloff;
      ALuint relative;
      size_t managerid;
      
   private:
      ALuint id;
      floatvec velocity;

};

typedef shared_ptr<ALSource> ALSourcePtr;

#endif
