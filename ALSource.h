#ifndef __ALSOURCE_H
#define __ALSOURCE_H

#include "types.h"
#include "ALBuffer.h"
#include <boost/shared_ptr.hpp>

using boost::shared_ptr;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ALSource
{
   public:
      ALSource();
      ALSource(const ALSource&);
      ALSource& operator=(const ALSource&);
      ~ALSource();
      void Play(const ALBuffer&);
      void Play(const ALBufferPtr&);
      void SetPosition(const Vector3&);
      static void CheckError();
      
   private:
      ALuint id;
      floatvec position;
      floatvec velocity;
      float pitch, gain;
      ALuint loop;
      ALfloat refdist;
      ALfloat maxdist;

};

typedef shared_ptr<ALSource> ALSourcePtr;

#endif
