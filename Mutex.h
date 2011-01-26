#ifndef MUTEX_H
#define MUTEX_H

#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>
#include <boost/shared_ptr.hpp>


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
};

typedef boost::shared_ptr<Mutex> MutexPtr;

inline int Mutex::lock()
{
   int retval = SDL_mutexP(mutex);
   return retval;
}


inline int Mutex::unlock()
{
   int retval = SDL_mutexV(mutex);
   SDL_Delay(0); // Prevent thread starvation
   return retval;
}

#endif // MUTEX_H
