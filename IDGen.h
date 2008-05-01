#ifndef __IDGEN_H
#define __IDGEN_H

#include "SDL.h"
#include "SDL_thread.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
   This class is just a thread-safe method of generating unique ids.
*/
class IDGen
{
   public:
      IDGen();
      ~IDGen();
      unsigned long next();
      operator unsigned long();
      
   private:
      IDGen(const IDGen&); // It doesn't make sense to copy these
      IDGen& operator=(const IDGen&);
      
      unsigned long nextid;
      SDL_mutex* incmutex;

};

#endif
