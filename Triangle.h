#ifndef __TRIANGLE_H
#define __TRIANGLE_H

#include "Vertex.h"
#include "Vector3.h"
#include "types.h"
#include "GraphicMatrix.h"
#include "Material.h"
#include <vector>

using std::vector;

/**
	@author Ben Nemec <cybertron@nemebean.com>
   
   Note: After copying this object the vertices will still be shared between the two objects.
   This is desirable behavior because we want to allow multiple triangles to share the same
   vertex for rendering efficiency, but it means copying is not simple.  The owner of the
   Triangle needs to remap the vertices to a new set of vertices, preferably making sure that
   Triangles that previously pointed to the same vertex still do.
*/
class Triangle
{
   public:
      Triangle();
      bool operator<(const Triangle&) const;
      bool operator>(const Triangle&) const;
      ushortvec GetIndices();
      static bool TriPtrComp(const shared_ptr<Triangle>&, const shared_ptr<Triangle>&);
      void CalcMaxDim();
      
      VertexPtrvec v;
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
