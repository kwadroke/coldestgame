// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2009 Ben Nemec
// @End License@

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
