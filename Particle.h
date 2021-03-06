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


#ifndef __PARTICLE
#define __PARTICLE

#include <list>
#include <stack>
#include "CollisionDetection.h"
#include "Vector3.h"
#include "Timer.h"
#include "SoundSource.h"
#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>

using boost::shared_ptr;

class Particle
{
   public:
      Particle(Mesh&);
      Particle(unsigned long, Vector3, Vector3, float, float, float, float, bool, Uint32, Mesh&);
      Particle(const string&);
      Vector3 Update();
      void Render(Mesh *rendermesh = NULL, const Vector3& campos = Vector3());
      void PlaySound(const string&, ResourceManager&);
      void ResetTimer() {t.start();}
      
      size_t playernum;
      unsigned long id;
      
      Vector3 dir;
      Vector3 pos;
      Vector3 origin;
      Vector3 lasttracer;
      float velocity;
      float accel;
      float weight;
      float radius;
      bool explode;
      Uint32 lasttick;
      int damage;
      float dmgrad;
      int rewind;
      bool collide;
      int ttl;
      bool expired;
      int weapid;
      bool clientonly;
      
      string tracer;
      Uint32 tracertime;

      Mesh mesh;
      
   private:
      Timer t;
      bool debug;
      SoundSourcePtr source;
};


#endif
