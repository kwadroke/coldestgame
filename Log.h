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
// Copyright 2008, 2009 Ben Nemec
// @End License@


#ifndef __LOG_H
#define __LOG_H

#include <vector>
#include <fstream>
#include <string>
#include <iostream>
#include "SDL.h"

using std::vector;
using std::ofstream;
using std::ostream;
using std::string;
using std::cout;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Log
{
   public:
      Log();
      void SetFile(const string&);
      
      // Handle endl since the template can't
      Log& operator<<(ostream& (*f)(ostream&));
      template <typename T>
      Log& operator<<(const T& s);
      template <typename T>
      Log& operator<<(T& s);
      
   private:
      Log(const Log&); // No copying allowed
      Log& operator=(const Log&);
      
      ofstream fileout;
      SDL_mutex* mutex;
};


template <typename T>
Log& Log::operator<<(const T& s)
{
   SDL_mutexP(mutex);
   cout << s;
   if (fileout)
      fileout << s;
   SDL_mutexV(mutex);
   return *this;
}

template <typename T>
Log& Log::operator<<(T& s)
{
   SDL_mutexP(mutex);
   cout << s;
   if (fileout)
      fileout << s;
   SDL_mutexV(mutex);
   return *this;
}

#endif
