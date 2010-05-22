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


#include "ParticleEmitter.h"
#include "globals.h"

ParticleEmitter::ParticleEmitter(const Vector3& pos, Particle& p, Uint32 etime, float d, int maxcount) : 
                                 position(pos), particle(p), emittertime(etime), lastupdate(SDL_GetTicks()), density(d), count(maxcount),
                                 firstupdate(true)
{
}


ParticleEmitter::ParticleEmitter(const string& filename, ResourceManager& resman) : 
                                 particle("particles/explosion", resman), lastupdate(SDL_GetTicks()), firstupdate(true)
{
   NTreeReader read(filename);
   string partfile;
   read.Read(partfile, "Particle");
   particle = Particle(partfile, resman);
   read.Read(emittertime, "EmitterTime");
   read.Read(density, "Density");
   read.Read(count, "Count");
   read.Read(soundfile, "Sound");
}


// Returns true if it is done emitting
bool ParticleEmitter::Update(list<Particle>& partlist)
{
#ifndef DEDICATED
   if (firstupdate && soundfile != "")
   {
      resman.soundman.PlaySound(soundfile, position);
      firstupdate = false;
   }
#endif
   
   Uint32 currtick = SDL_GetTicks();
   Uint32 numticks = currtick - lastupdate;
   ssize_t addcount = int(Random(0.f, density * float(numticks)));
   lastupdate = currtick;
   for (ssize_t i = 0; (i < addcount), count != 0; ++i)
   {
      Particle newpart(particle);
      newpart.pos = position;
      newpart.lasttick = currtick;
      GraphicMatrix m;
      m.rotatex(Random(0, 360));
      m.rotatey(Random(0, 360));
      newpart.dir = Vector3(0, 0, 1);
      newpart.dir.transform(m);
      partlist.push_back(newpart);
      --count;
   }
   // Don't return even if count is 0 so that sounds can continue playing
   if (numticks >= emittertime) return true;
   emittertime -= numticks;
   return false;
}


