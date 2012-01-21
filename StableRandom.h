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
// Copyright 2008-2012 Ben Nemec
// @End License@


#ifndef STABLERANDOM_H
#define STABLERANDOM_H

/**
	@author Ben Nemec <cybertron@nemebean.com>
   
   This is a not-so-random number generator guaranteed to return the same values
   on any system given the same seed.
*/
class StableRandom
{
   public:
      StableRandom(int seed = 0);
      float Random(float min, float max);
      void Seed(int seed = 0);
      
   private:
      static float vals[1024];
      int currindex;

};



#endif
