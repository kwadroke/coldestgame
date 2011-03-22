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
// Copyright 2008, 2011 Ben Nemec
// @End License@
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

