// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __TRIANGLE_H
#define __TRIANGLE_H

#include <vector>
#include <string>
#include "Vertex.h"
#include "Vector3.h"
#include "types.h"
#include "GraphicMatrix.h"
#include "Material.h"

using std::vector;
using std::string;

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
      static float Perimeter(const Vector3&, const Vector3&, const Vector3&);
      void CalcMaxDim();
      
      VertexPtrvec v;
      Material* material;
      string matname;
      bool collide;
      GraphicMatrix matrix;
      float maxdim;
      Vector3 midpoint;
      float radmod;
      size_t id;

};

typedef vector<Triangle> Trianglevec;
typedef shared_ptr<Triangle> TrianglePtr;
typedef vector<TrianglePtr> TrianglePtrvec;

#endif
