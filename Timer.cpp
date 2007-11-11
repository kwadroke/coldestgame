#include "Timer.h"

Timer::Timer()
{
}


void Timer::start()
{
   starttick = SDL_GetTicks();
}


void Timer::stop()
{
   cout << "Time: " << (SDL_GetTicks() - starttick) << endl;
}
