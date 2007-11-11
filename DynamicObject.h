#ifndef __DYNAMICOBJECT
#define __DYNAMICOBJECT

#include "SDL.h"
#include "Vector3.h"
#include <vector>
#include <list>

using namespace std;

class DynamicPrimitive;

// list in a vector in a list, how fun!
typedef list<DynamicPrimitive*> DPList;

class DynamicObject
{
   public:
      vector<DPList> prims;  // Need random access, so needs to be vector
      Vector3 position;
      float rotation, pitch, roll;
      float size;
      int animframe;
      int animdelay;
      Uint32 lasttick;
      bool visible;
      bool collide;
      bool billboard;
      int complete;
      //vector<GLuint> texnums;  // Also need random access, this is probably not necessary
};

#endif
