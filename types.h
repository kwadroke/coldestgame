#ifndef __TYPES_H
#define __TYPES_H

#include "Vector3.h"
#include <vector>
#include <string>
#include "SDL.h"

using std::vector;
using std::string;

// Define types used multiple places

/* The last item in each of the enums is a value to indicate how many enums each type
   actually has.  Iterating from 0...lastitem - 1 (i.e. numweapons) should always hit
   each possible weapon.*/
// Note: If you change the Weapon or Unit enums you need to alter the GUI as well to match

enum Units{UnitTest, Ultra, Omega, numunits};
enum BodyParts{Legs, Torso, LArm, RArm, numbodyparts};
enum Items{NoItem, SpawnPoint, HeatSink, AmmoCarrier, Radar, numitems};

typedef vector<float> floatvec;
typedef vector<int> intvec;
typedef vector<Vector3> Vector3vec;
typedef vector<GLubyte> GLubytevec;

struct UnitData
{
   int weight;
   int baseweight;
   string file;
   float turnspeed;
   float acceleration;
   float maxspeed;
   float size;
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
