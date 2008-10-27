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
      void Stop();
      static void CheckError();
      bool Playing();
      
      Vector3 position;
      ALfloat pitch, gain;
      ALuint loop;
      ALfloat refdist;
      ALfloat maxdist;
      ALfloat rolloff;
      ALuint relative;
      
   private:
      ALuint id;
      floatvec velocity;

};

typedef shared_ptr<ALSource> ALSourcePtr;

#endif
