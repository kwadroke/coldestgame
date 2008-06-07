#ifndef __VERTEX_H
#define __VERTEX_H

#include <vector>
#include "Vector3.h"
#include "glinc.h"
#include "types.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Vertex
{
   public:
      Vertex();
      
      Vector3 pos;
      Vector3 norm;
      Vector3 tangent;
      vector<floatvec> texcoords; // [Texture unit][x/y]
      GLubytevec color;
      floatvec terrainwt;

};

typedef vector<Vertex> Vertexvec;

#endif
