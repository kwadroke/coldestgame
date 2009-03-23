// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
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

