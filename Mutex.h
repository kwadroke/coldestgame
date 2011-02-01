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
