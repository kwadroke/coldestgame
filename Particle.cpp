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


#include "Particle.h"
#include "globals.h"


Particle::Particle(Mesh& meshin) : playernum(0), id(0), velocity(0.f), accel(0.f),
                   weight(0.f), radius(0.f), explode(true), lasttick(0), damage(0), dmgrad(0.f), 
                   rewind(0), collide(false), ttl(10000), expired(false), weapid(-1), clientonly(false), tracertime(10000), mesh(meshin),
                   debug(false)
{
   t.start();
}


Particle::Particle(unsigned long nid, Vector3 p, Vector3 v, float vel, float acc, float w,
                   float rad, bool exp, Uint32 tick, Mesh& meshin) : playernum(0), id(nid),
                   dir(v), pos(p), origin(p), lasttracer(p), velocity(vel), accel(acc), weight(w), radius(rad), explode(exp),
                   lasttick(tick), damage(0), dmgrad(0.f), rewind(0), collide(false), ttl(10000), expired(false), weapid(-1),
                   clientonly(false), tracertime(10000), mesh(meshin), debug(false)
{
   dir.normalize();
   t.start();
}


Particle::Particle(const string& filename, ResourceManager& resman) : playernum(0), id(0),
                   velocity(0.f), accel(0.f), weight(0.f), radius(0.f), explode(true), lasttick(0), damage(0), dmgrad(0.f),
                   rewind(0), collide(false), ttl(10000), expired(false), weapid(-1), clientonly(false), tracertime(10000), mesh(meshcache->GetMesh("models/empty")),
                   debug(false)
{
   NTreeReader read(filename);
   read.Read(velocity, "Velocity");
   read.Read(accel, "Accel");
   read.Read(weight, "Weight");
   read.Read(radius, "Radius");
   read.Read(explode, "Explode");
   read.Read(damage, "Damage");
   read.Read(dmgrad, "DamageRadius");
   read.Read(collide, "Collide");
   int temp = 10000;
   read.Read(temp, "TTL");
   ttl = temp;
   temp = 10000;
   read.Read(temp, "TracerTime");
   tracertime = temp;
   
   string meshname;
   read.Read(meshname, "Mesh");
   mesh = meshcache->GetMesh(meshname);
   t.start();
   
   string sound;
   read.Read(sound, "Sound");
}


Vector3 Particle::Update()
{
   Vector3 oldpos = pos;
   Uint32 currtick = SDL_GetTicks();
   Uint32 interval = currtick - lasttick;
   lasttick = currtick;
   velocity += accel * float(interval) / 10.f;
   dir.y -= weight * float(interval) / 1000.f;
   pos += dir * (velocity * interval);
   mesh.Move(pos);
   if (ttl >= 0) // A negative ttl means never expire this particle
   {
      if (t.elapsed() >= Uint32(ttl))
         expired = true;
   }
   return oldpos;
}


// Note: This function does not actually render the particle, it adds it to a collective
// mesh of all particles which is then rendered
void Particle::Render(Mesh* rendermesh, const Vector3& campos)
{
   if (rendermesh)
   {
      mesh.EnsureMaterials();
      mesh.Update(campos);
      rendermesh->Add(mesh);
   }
   else
   {
      mesh.Update(campos);
   }
}

