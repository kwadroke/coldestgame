#include "Mutex.h"
#include <iostream>
#include "util.h"

using std::endl;

Mutex::Mutex()
{
   if (!SDL_WasInit(0))
      logout << "Warning: Creating mutex without SDL_Init" << endl;
   mutex = SDL_CreateMutex();
}

Mutex::Mutex(const Mutex& other)
{
   mutex = SDL_CreateMutex();
}

Mutex::~Mutex()
{
 SDL_DestroyMutex(mutex);
}

Mutex& Mutex::operator=(const Mutex& other)
{
   if (&other != this)
   {
      mutex = SDL_CreateMutex();
   }
   return *this;
}


int Mutex::lock()
{
   int retval = SDL_mutexP(mutex);
   return retval;
}


int Mutex::unlock()
{
   int retval = SDL_mutexV(mutex);
   SDL_Delay(0); // Prevent thread starvation
   return retval;
}

