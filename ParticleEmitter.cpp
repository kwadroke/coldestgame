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


#include "ParticleEmitter.h"
#include "globals.h"

ParticleEmitter::ParticleEmitter(const Vector3& pos, Particle& p, Uint32 etime, float d, int maxcount) : 
                                 position(pos), minx(0.f), maxx(360.f), miny(0.f), maxy(360.f), particle(p), emittertime(etime), 
                                 lastupdate(SDL_GetTicks()), density(d), densityaccum(0.f), count(maxcount),
                                 firstupdate(true), one(false), debug(false)
{
}


ParticleEmitter::ParticleEmitter(const string& filename) : 
                                 minx(0.f), maxx(360.f), miny(0.f), maxy(360.f), particle("particles/explosion"), 
                                 lastupdate(SDL_GetTicks()), densityaccum(0.f), firstupdate(true), one(false), 
                                 debug(false)
{
   NTreeReader read(filename);
   read.Read(partfile, "Particle");
   particle = Particle(partfile);
   read.Read(emittertime, "EmitterTime");
   read.Read(density, "Density");
   read.Read(count, "Count");
   read.Read(soundfile, "Sound");
   read.Read(one, "One");
}


// Returns true if it is done emitting
bool ParticleEmitter::Update(list<Particle>& partlist)
{
#ifndef DEDICATED
   if (firstupdate) 
   {
      if (soundfile != "")
         resman.soundman.PlaySound(soundfile, position);
      firstupdate = false;
   }
#endif
   
   Uint32 currtick = SDL_GetTicks();
   Uint32 numticks = currtick - lastupdate;
   ssize_t addcount;
   if (!one)
   {
      float addval = Random(0.f, (density + densityaccum) * float(numticks));
      addcount = int(addval);
      if (addcount == 0)
      {
         densityaccum += density;
      }
      else
         densityaccum = 0.f;
   }
   else
      addcount = 1;
   lastupdate = currtick;
   for (ssize_t i = 0; (i < addcount) && count != 0; ++i)
   {
      Particle newpart(partfile);
      newpart.pos = position;
      newpart.lasttick = currtick;
      GraphicMatrix m;
      m.rotatex(Random(minx, maxx));
      m.rotatey(Random(miny, maxy));
      newpart.dir = Vector3(0, 0, 1);
      newpart.dir.transform(m);
      partlist.push_back(newpart);
      --count;
   }
   if (emittertime < 0)
      return false;
   // Don't return even if count is 0 so that sounds can continue playing
   if (numticks >= emittertime)
      return true;
   emittertime -= numticks;
   return false;
}


