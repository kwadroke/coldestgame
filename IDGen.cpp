#include "IDGen.h"

IDGen::IDGen() : nextid(0), incmutex(SDL_CreateMutex())
{
}


IDGen::~IDGen()
{
   SDL_DestroyMutex(incmutex);
}


unsigned long IDGen::next()
{
   SDL_mutexP(incmutex);
   unsigned long retval = nextid;
   ++nextid;
   SDL_mutexV(incmutex);
   return retval;
}


IDGen::operator unsigned long()
{
   return next();
}


