#include "Timer.h"

Timer::Timer()
{
}


void Timer::start()
{
   starttick = SDL_GetTicks();
}


Uint32 Timer::stop()
{
   logout << "Time: " << (SDL_GetTicks() - starttick) << endl;
   return (SDL_GetTicks() - starttick);
}


Uint32 Timer::elapsed()
{
   return (SDL_GetTicks() - starttick);
}
