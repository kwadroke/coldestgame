#ifndef __WORLD_PRIMITIVES_H
#define __WORLD_PRIMITIVES_H

#include "GenericPrimitive.h"

class WorldObjects;

class WorldPrimitives : public GenericPrimitive
{
   public:
      WorldPrimitives();
      bool operator<(const WorldPrimitives &) const;
      bool operator>(const WorldPrimitives &) const;
      
      //string type;
      //int object;
      list<WorldObjects>::iterator object;
      //int texnum;
      bool depthtest, transparent;
      GLfloat terraintex[4][6];
         
      //float rad, rad1; // Radii for cylinders and similar objects
      float height;    // Height for same
      int slices;      // Slices and stacks for same
      int stacks;
      
      //Vector3 v[4]; // Vertices for polygons
      Vector3 normal;
      Vector3 n[4]; // Normal vectors for each vertex
};


#endif
