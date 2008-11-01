#include "tsint.h"

tsint::tsint() : value(0)
{
   mutex = SDL_CreateMutex();
}


tsint::tsint(const long newval)
{
   mutex = SDL_CreateMutex();
   SDL_mutexP(mutex);
   value = newval;
   SDL_mutexV(mutex);
}


tsint::~tsint()
{
   SDL_DestroyMutex(mutex);
}


long tsint::get()
{
   SDL_mutexP(mutex);
   long retval = value;
   SDL_mutexV(mutex);
   return retval;
}


void tsint::set(const long newval)
{
   SDL_mutexP(mutex);
   value = newval;
   SDL_mutexV(mutex);
}

