// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
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
