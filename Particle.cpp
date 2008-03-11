#include "Particle.h"


unsigned long Particle::nextid = 1;


Particle::Particle(Mesh& meshin) : mesh(meshin)
{
   cd = NULL;
   unsent = true;
   senttimes = 0;
   /*id = nextid;
   // Prevent overflow, not that I expect this to ever happen
   if (nextid > 4294967294ul)
      nextid = 0;
   ++nextid;*/
}


Particle::Particle(Vector3 p, Vector3 v, float vel, float acc, float w,
                   float rad, bool exp, Uint32 tick, Mesh& meshin) : mesh(meshin)
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
   cd = NULL;
   unsent = true;
   senttimes = 0;
   damage = 0;
   dmgrad = 0;
   id = nextid;
   // Prevent overflow, not that I expect this to ever happen
   if (nextid > 4294967294ul)
      nextid = 0;
   ++nextid;
}


bool Particle::Update(Mesh& rendermesh)
{
   if (cd == NULL)
   {
      cout << "Particle: Some moron forgot to set Particle::cd.  This is a bug.\n";
      return true;
   }
   Vector3 oldpos = pos;
   Uint32 currtick = SDL_GetTicks();
   Uint32 interval = currtick - lasttick;
   lasttick = currtick;
   velocity *= accel;
   dir.y -= weight * interval / 1000.f;
   pos += dir * (velocity * interval);
   cd->listvalid = false;
   if (explode)
   {
      Vector3 adjust = cd->CheckSphereHit(oldpos, pos, radius, NULL, &hitobjs);
      // Update object position either way
      mesh.Move(pos);
      if (adjust.distance2(Vector3()) > .00001)
         return true;
   }
   else
   {
      cout << "Particle:  Warning, explode == 0, this is not yet supported.\n";
   }
   mesh.AdvanceAnimation();
   rendermesh.Add(mesh);
   return false;
}

