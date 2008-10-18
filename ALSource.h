#ifndef __ALSOURCE_H
#define __ALSOURCE_H

#include "types.h"
#include "ALBuffer.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ALSource
{
   public:
      ALSource();
      ~ALSource();
      void Play(const ALBuffer&);
      void Play(const ALBufferPtr&);
      
   private:
      ALuint id;
      floatvec position;
      floatvec velocity;
      float pitch, gain;
      ALuint loop;

};

#endif
