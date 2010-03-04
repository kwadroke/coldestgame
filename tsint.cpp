// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2010 Ben Nemec
// @End License@


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

