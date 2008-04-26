#include "Particle.h"


unsigned long Particle::nextid = 1;


Particle::Particle(Mesh& meshin) : mesh(meshin), rewind(0), collide(false), ttl(10000), expired(false)
{
   unsent = true;
   senttimes = 0;
   t.start();
   /*id = nextid;
   // Prevent overflow, not that I expect this to ever happen
   if (nextid > 4294967294ul)
      nextid = 0;
   ++nextid;*/
}


Particle::Particle(Vector3 p, Vector3 v, float vel, float acc, float w,
                   float rad, bool exp, Uint32 tick, Mesh& meshin) : mesh(meshin),
                   rewind(0), collide(false), ttl(0), expired(false)
{
   pos = p;
   dir = v;
   dir.normalize();
   velocity = vel;
   accel = acc;
   weight = w;
   radius = rad;
   explode = exp;
   lasttick = tick;
   unsent = true;
   senttimes = 0;
   damage = 0;
   dmgrad = 0;
   id = nextid;
   // Prevent overflow, not sure what the implications of this happening would be
   if (nextid > 4294967294ul)
      nextid = 1;
   ++nextid;
   t.start();
}


Vector3 Particle::Update()
{
   Vector3 oldpos = pos;
   Uint32 currtick = SDL_GetTicks();
   Uint32 interval = currtick - lasttick;
   lasttick = currtick;
   velocity *= accel;
   dir.y -= weight * interval / 1000.f;
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
      rendermesh->Add(mesh);
   }
}

