// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#include "Particle.h"
#include "globals.h"


Particle::Particle(Mesh& meshin) : mesh(meshin), playernum(0), id(0), velocity(0.f), accel(0.f),
                   weight(0.f), radius(0.f), explode(true), lasttick(0), damage(0), dmgrad(0.f),
                   rewind(0), collide(false), ttl(10000), expired(false), weapid(-1), tracertime(10000)
{
   t.start();
   mesh.dynamic = true;
}


Particle::Particle(unsigned long nid, Vector3 p, Vector3 v, float vel, float acc, float w,
                   float rad, bool exp, Uint32 tick, Mesh& meshin) : mesh(meshin), playernum(0), id(nid),
                   dir(v), pos(p), origin(p), lasttracer(p), velocity(vel), accel(acc), weight(w), radius(rad), explode(exp),
                   lasttick(tick), damage(0), dmgrad(0.f), rewind(0), collide(false), ttl(10000), expired(false), weapid(-1),
                   tracertime(10000)
{
   dir.normalize();
   t.start();
   mesh.dynamic = true;
}


Particle::Particle(const string& filename, ResourceManager& resman) : mesh(meshcache->GetMesh("models/empty")), playernum(0), id(0),
                   velocity(0.f), accel(0.f), weight(0.f), radius(0.f), explode(true), lasttick(0), damage(0), dmgrad(0.f),
                   rewind(0), collide(false), ttl(10000), expired(false), weapid(-1), tracertime(10000)
{
   IniReader read(filename);
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
   mesh.dynamic = true;
   t.start();
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
   if (ttl > 0)
   {
      if (t.elapsed() > ttl)
         expired = true;
   }
   
   return oldpos;
}


// Note: This function does not actually render the particle, it adds it to a collective
// mesh of all particles which is then rendered
void Particle::Render(Mesh* rendermesh, const Vector3& campos)
{
   mesh.AdvanceAnimation(campos);
   // By default materials are not loaded until GenVbo is called (so that the server doesn't
   // make GL calls, but that causes issues here because Mesh::Add(Mesh&) copies tris
   // directly, so if the materials haven't been loaded those materials will still be NULL
   // and when we try to render rendermesh it will not show up
   if (rendermesh)
   {
      mesh.LoadMaterials();
      rendermesh->Add(&mesh);
   }
}

