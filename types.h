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


#ifndef __TYPES_H
#define __TYPES_H

#include "Vector3.h"
#include <vector>
#include <string>
#include <SDL/SDL.h>

using std::vector;
using std::string;

// Define types used multiple places

/* The last item in each of the enums is a value to indicate how many enums each type
   actually has.  Iterating from 0...lastitem - 1 (i.e. numweapons) should always hit
   each possible weapon.*/
// Note: If you change the Unit enums you need to alter the GUI as well to match

enum Units{Nemesis, Ultra, Omega, numunits};
enum BodyParts{Legs, Torso, LArm, RArm, Hips, numbodyparts};

typedef vector<float> floatvec;
typedef vector<int> intvec;
typedef vector<unsigned short> ushortvec;
typedef vector<Vector3> Vector3vec;
typedef vector<GLubyte> GLubytevec;
typedef vector<GLuint> gluintvec;
#ifndef __GNUC__
typedef ptrdiff_t ssize_t; // Already exists in GCC
#endif

struct UnitData // This should probably be a class like Weapon and Item, but meh
{
   int weight;
   string file;
   float turnspeed;
   float acceleration;
   float maxspeed;
   float size;
   float scale;
   Vector3 weaponoffset[numbodyparts];
   Vector3 viewoffset;
   int maxhp[numbodyparts];
};


struct OldPosition
{
   Vector3 pos;
   Uint32 tick;
   float facing;
};


struct SpawnPointData
{
   Vector3 position;
   int team;
   string name;
};

#endif
