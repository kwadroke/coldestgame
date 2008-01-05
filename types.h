#ifndef __TYPES_H
#define __TYPES_H

#include "Vector3.h"

// Define types used multiple places

/* The last item in each of the enums is a value to indicate how many enums each type
   actually has.  Iterating from 0...lastitem - 1 (i.e. numweapons) should always hit
   each possible weapon.*/
enum Weapons{Empty, MachineGun, Laser, Autocannon, GaussRifle, NeutrinoCannon, numweapons};
enum Units{UnitTest, Ultra, Omega, numunits};
enum BodyParts{Torso, LArm, RArm, numbodyparts};

typedef vector<float> floatvec;
typedef vector<Vector3> Vector3vec;

struct UnitData
{
   int weight;
   int baseweight;
   string file;
   float turnspeed;
   float maxspeed;
   Vector3 larmattach;
   Vector3 rarmattach;
   Vector3 legattach;
   Vector3 lweapattach;
   Vector3 rweapattach;
   Vector3 torsoweapattach;
};


struct WeaponData
{
   float radius;
   float velocity;
   float acceleration;
   float splashradius;
   float weight;
   float heat;
   int damage;
   int reloadtime;
   bool explode;
   string file;
   string name;
};


struct OldPosition
{
   Vector3 pos;
   Uint32 tick;
   float facing;
};

#endif
