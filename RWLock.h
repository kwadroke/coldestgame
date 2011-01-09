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
// Copyright 2008, 2011 Ben Nemec
// @End License@

#ifndef __RWLOCK_H
#define __RWLOCK_H

#include "tsint.h"
#include <SDL.h>
#include <SDL_thread.h>
#include <boost/shared_ptr.hpp>

// A multiple readers, single writer lock class that gives fair access to everyone.
class RWLock
{
   private:
      RWLock(const RWLock&); // No copying
      RWLock& operator=(const RWLock&);
      
      SDL_mutex* mutex;
      tsint readers;
      
   public:
      RWLock() : mutex(SDL_CreateMutex()), readers(0) {}
      ~RWLock()
      {
         SDL_DestroyMutex(mutex);
      }
      
      void Read()
      {
         SDL_mutexP(mutex);
         ++readers;
         SDL_mutexV(mutex);
      }
      
      void EndRead()
      {
         --readers;
      }
      
      void Write()
      {
         SDL_mutexP(mutex);
         while (readers)
            SDL_Delay(1);
      }
      
      void EndWrite()
      {
         SDL_mutexV(mutex);
      }
};

typedef boost::shared_ptr<RWLock> RWLockPtr;

#endif
