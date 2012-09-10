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
// Copyright 2008-2012 Ben Nemec
// @End License@


#ifndef __PARTICLEEMITTER_H
#define __PARTICLEEMITTER_H

#include "Particle.h"
#include "util.h"
#include "ALSource.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ParticleEmitter
{
   public:
      ParticleEmitter(const Vector3&, Particle&, Uint32, float, int);
      ParticleEmitter(const string&);
      bool Update(list<Particle>&);
      void ResetTime() {lastupdate = SDL_GetTicks();}
      Vector3 position;
      float minx, maxx;
      float miny, maxy;
      
   private:
      Particle particle;
      int emittertime;
      Uint32 lastupdate;
      float density;
      float densityaccum;
      int count;
      ALSourcePtr soundsource;
      string soundfile;
      bool firstupdate;
      bool one;
      string partfile;

      bool debug;

};

#endif
