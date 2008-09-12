#include "ParticleEmitter.h"

ParticleEmitter::ParticleEmitter(const Vector3& pos, Particle& p, Uint32 etime, float d, int maxcount) : 
                                 position(pos), particle(p), emittertime(etime), density(d), count(maxcount),
                                 lastupdate(SDL_GetTicks())
{
}


ParticleEmitter::ParticleEmitter(const string& filename, ResourceManager& resman) : 
                                 lastupdate(SDL_GetTicks()), particle("particles/explosion", resman)
{
   IniReader read(filename);
   string partfile;
   read.Read(partfile, "Particle");
   particle = Particle(partfile, resman);
   read.Read(emittertime, "EmitterTime");
   read.Read(density, "Density");
   read.Read(count, "Count");
}


// Returns true if it is done emitting
bool ParticleEmitter::Update(list<Particle>& partlist)
{
   Uint32 currtick = SDL_GetTicks();
   Uint32 numticks = currtick - lastupdate;
   int addcount = int(Random(0.f, density * float(numticks)));
   for (ssize_t i = 0; i < addcount, count != 0; ++i)
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
   if (numticks >= emittertime || count == 0) return true;
   emittertime -= numticks;
   return false;
}


