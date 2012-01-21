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
// Copyright 2008-2012 Ben Nemec
// @End License@
#ifndef MUTEX_H
#define MUTEX_H

#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>
#include <boost/shared_ptr.hpp>
#include "Timer.h"
#include "util.h"


class Mutex
{
   public:
      Mutex();
      Mutex(const Mutex& other);
      virtual ~Mutex();
      virtual Mutex& operator=(const Mutex& other);

      int lock();
      int unlock();

   private:
      SDL_mutex *mutex;
      Timer t;
};

typedef boost::shared_ptr<Mutex> MutexPtr;

inline int Mutex::lock()
{
   Timer timer;
   timer.start();
   int retval = SDL_mutexP(mutex);
   if (timer.elapsed() > 250)
   {
      logout << "Long lock wait " << gettid() << " for " << timer.elapsed() << " ms" << endl;
   }
   t.start();
   return retval;
}


inline int Mutex::unlock()
{
   if (t.elapsed() > 250)
   {
      logout << "Long held lock " << gettid() << " for " << t.elapsed() << " ms" << endl;
   }
   int retval = SDL_mutexV(mutex);
   //SDL_Delay(0); // Prevent thread starvation
   return retval;
}

#endif // MUTEX_H
