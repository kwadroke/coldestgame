#ifndef __TRIANGLE_H
#define __TRIANGLE_H

#include "Vector3.h"
#include "types.h"
#include "GraphicMatrix.h"
#include "Material.h"
#include <vector>

using std::vector;

#pragma pack(push, 1)
struct VBOData
{
   GLfloat x;
   GLfloat y;
   GLfloat z;
   GLfloat nx;
   GLfloat ny;
   GLfloat nz;
   GLfloat tx;
   GLfloat ty;
   GLfloat tz;
   GLfloat tc[8][2]; // [Texture unit][x/y]
   GLubyte r;
   GLubyte g;
   GLubyte b;
   GLubyte a;
   GLfloat terrainwt[3];
   GLfloat terrainwt1[3];
};
#pragma pack(pop)

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Triangle
{
   public:
      Triangle();
      bool operator<(const Triangle&) const;
      bool operator>(const Triangle&) const;
      VBOData GetVboData(const int);
      
      Vector3vec vert;
      Vector3vec norm;
      Material* material;
      Vector3 tangent;
      bool collide;
      vector< vector< floatvec > > texcoords; // [Texture unit][vertex][x/y]
      vector<GLubytevec> color;
      vector<floatvec> terrainwt;
      float dist;
      GraphicMatrix matrix;

};

typedef vector<Triangle> Trianglevec;

#endif
