#ifndef __DYNAMICPRIMITIVE_H
#define __DYNAMICPRIMITIVE_H

#include "GenericPrimitive.h"
#include "GraphicMatrix.h"
#include "Quaternion.h"

class DynamicObject;

class DynamicPrimitive : public GenericPrimitive
{
   public:
      DynamicPrimitive();
      string id;
      //string type;
      string parentid;
      string name;
      DynamicPrimitive *parent;
      list<DynamicPrimitive*> child; // These need to be deleted in a destructor at some point
      list<DynamicObject>::iterator parentobj;
      //Vector3 point[4];
      //int texnum;
      Vector3 orig[4];
      Vector3 rot1;
      Vector3 trans;
      Vector3 rot2;
      GraphicMatrix m;
      Quaternion q;
      int slices, stacks;
      float height;
      //float rad, rad1;
      bool transparent, translucent;
      //bool collide;
      bool facing;
};

#endif
