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

#include "Log.h"

// Note: violating all kinds of rules here, but since Log should only ever be constructed once, and never destructed
// (except at program exit), I'm not worrying about it.  If any of those conditions should change for some reason
// this will need to be fixed.
Log::Log()
{
   mutex = SDL_CreateMutex();
}


void Log::SetFile(const string& filename)
{
   SDL_mutexP(mutex);
   fileout.open(filename.c_str());
   SDL_mutexV(mutex);
}


Log& Log::operator<<(ostream& (*s)(ostream&))
{
   SDL_mutexP(mutex);
   cout << s;
   if (fileout)
      fileout << s;
   SDL_mutexV(mutex);
	return *this;
}



