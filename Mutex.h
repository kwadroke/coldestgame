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

      void lock();
      void unlock();

   private:
      SDL_mutex *mutex;
};

typedef boost::shared_ptr<Mutex> MutexPtr;

#endif // MUTEX_H
