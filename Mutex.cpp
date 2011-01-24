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


void Mutex::lock()
{
   SDL_mutexP(mutex);
}


void Mutex::unlock()
{
   SDL_mutexV(mutex);
}

