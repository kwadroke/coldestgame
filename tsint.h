#ifndef __TSINT_H
#define __TSINT_H

#include "SDL.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>

   Thread-safe int class
*/
class tsint
{
   public:
      tsint();
      tsint(const long);
      ~tsint();
      long get();
      void set(const long);
      tsint& operator=(const long& newval) {SDL_mutexP(mutex); value = newval; SDL_mutexV(mutex); return *this;}
      operator long() const {SDL_mutexP(mutex); long retval = value; SDL_mutexV(mutex); return retval;}
      long operator++() {SDL_mutexP(mutex); ++value; long retval = value; SDL_mutexV(mutex); return retval;}
      long operator--() {SDL_mutexP(mutex); --value; long retval = value; SDL_mutexV(mutex); return retval;}


   private:
      tsint(const tsint&); // No copying allowed
      tsint& operator=(const tsint&);
      SDL_mutex* mutex;
      long value;

};

#endif
