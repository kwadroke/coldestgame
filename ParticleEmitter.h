#ifndef __PARTICLEEMITTER_H
#define __PARTICLEEMITTER_H

#include "Particle.h"
#include "util.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ParticleEmitter
{
   public:
      ParticleEmitter(const Vector3&, Particle&, Uint32, float, int);
      ParticleEmitter(const string&, ResourceManager&);
      bool Update(list<Particle>&);
      Vector3 position;
      
   private:
      Particle particle;
      Uint32 emittertime;
      Uint32 lastupdate;
      float density;
      int count;

};

#endif
