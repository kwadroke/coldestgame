#ifndef __TRIANGLE_H
#define __TRIANGLE_H

#include "Vertex.h"
#include "Vector3.h"
#include "types.h"
#include "GraphicMatrix.h"
#include "Material.h"
#include <vector>

using std::vector;

// We pass this structure directly to OpenGL, so it needs to be aligned on single bytes
// Edit: Maybe.  It seems to work without doing that, but it may waste memory to align this
// Performance subjectively appears to be the same either way
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
      static bool TriPtrComp(const shared_ptr<Triangle>&, const shared_ptr<Triangle>&);
      void CalcMaxDim();
      
      Vertexvec v;
      Material* material;
      bool collide;
      GraphicMatrix matrix;
      float maxdim;
      Vector3 midpoint;
      float radmod;

};

typedef vector<Triangle> Trianglevec;
typedef shared_ptr<Triangle> TrianglePtr;
typedef vector<TrianglePtr> TrianglePtrvec;

#endif
