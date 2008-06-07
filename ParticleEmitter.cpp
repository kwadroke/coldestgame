#include "ParticleEmitter.h"

ParticleEmitter::ParticleEmitter(const Vector3& pos, Particle& p, Uint32 etime, float d, int maxcount) : 
                                 position(pos), particle(p), emittertime(etime), density(d), count(maxcount),
                                 lastupdate(SDL_GetTicks())
{
}


// Returns true if it is done emitting
bool ParticleEmitter::Update(list<Particle>& partlist)
{
   Uint32 currtick = SDL_GetTicks();
   Uint32 numticks = currtick - lastupdate;
   int addcount = int(Random(0.f, density * float(numticks)));
   for (size_t i = 0; i < addcount; ++i)
   {
      Particle newpart(particle);
      newpart.pos = position;
      GraphicMatrix m;
      m.rotatex(Random(0, 360));
      m.rotatey(Random(0, 360));
      newpart.dir = Vector3(0, 0, 1);
      newpart.dir.transform(m);
      partlist.push_back(newpart);
      --count;
      if (count == 0) return true;
   }
   if (numticks >= emittertime) return true;
   emittertime -= numticks;
   return false;
}


