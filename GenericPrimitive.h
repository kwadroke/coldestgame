#ifndef __GENERIC_PRIMITIVE_H
#define __GENERIC_PRIMITIVE_H

#include "Vector3.h"
#include <string>
#include <list>
#include <vector>

using namespace std;

class DynamicObject;

class GenericPrimitive
{
   public:
      GenericPrimitive();
      void Init();
      Vector3 v[4];
      float rad, rad1;
      string type;
      bool collide;
      bool dynamic;
      int vboindex;
      vector< vector< vector<float> > > texcoords;
      int texnum;
      GLuint texnums[6];
      string shader;
      float color[4][4];
      float dist;
};
#endif
