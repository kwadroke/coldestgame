#ifndef __TIMER_H
#define __TIMER_H

#include "SDL.h"
#include <iostream>

using std::cout;
using std::endl;

class Timer
{
   public:
      Timer();
      void start();
      void stop();
   private:
      Uint32 starttick;
};

#endif
