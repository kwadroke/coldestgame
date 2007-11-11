#include "Hit.h"

unsigned long Hit::nextid = 1;


Hit::Hit()
{
   id = nextid;
   // Prevent overflow, not that I expect this to ever happen
   if (nextid > 4294967294ul)
      nextid = 0;
   ++nextid;
}


// For the server only
Hit::Hit(unsigned long newid)
{
   id = newid;
}

