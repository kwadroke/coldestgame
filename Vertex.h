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


#ifndef __VERTEX_H
#define __VERTEX_H

#include <vector>
#include <map>
#include "Vector3.h"
#include "glinc.h"
#include "types.h"
#include <boost/shared_ptr.hpp>

using std::map;
#define INLINE_VERTEX

// We pass this structure directly to OpenGL, so it needs to be aligned on single bytes
// Edit: Maybe.  It seems to work without doing that, but it may waste memory to align this
// Performance appears to be about the same either way
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
class Vertex
{
   public:
      Vertex();
      void GetVboData(VBOData&, const bool dynamic);
      
      Vector3 pos;
      Vector3 norm;
      Vector3 tangent;
      vector<floatvec> texcoords; // [Texture unit][x/y]
      GLubytevec color;
      floatvec terrainwt;
      
      unsigned short index;
#ifdef EDITOR
      string id;
#else
      size_t id;
#endif
};

typedef vector<Vertex> Vertexvec;
typedef boost::shared_ptr<Vertex> VertexPtr;
typedef vector<VertexPtr> VertexPtrvec;
typedef map<string, VertexPtr> VertMap;


#ifdef INLINE_VERTEX
inline
void Vertex::GetVboData(VBOData& vbodata, const bool dynamic)
{
   vbodata.x = pos.x;
   vbodata.y = pos.y;
   vbodata.z = pos.z;
   vbodata.nx = norm.x;
   vbodata.ny = norm.y;
   vbodata.nz = norm.z;
   
   vbodata.tx = tangent.x;
   vbodata.ty = tangent.y;
   vbodata.tz = tangent.z;
   
   for (int i = 0; i < 2; ++i)
   {
      vbodata.tc[i][0] = texcoords[i][0];
      vbodata.tc[i][1] = texcoords[i][1];
   }
   vbodata.r = color[0];
   vbodata.g = color[1];
   vbodata.b = color[2];
   vbodata.a = color[3];
   
   if (!dynamic)
   {
      vbodata.terrainwt[0] = terrainwt[0];
      vbodata.terrainwt[1] = terrainwt[1];
      vbodata.terrainwt[2] = terrainwt[2];
      vbodata.terrainwt1[0] = terrainwt[3];
      vbodata.terrainwt1[1] = terrainwt[4];
      vbodata.terrainwt1[2] = terrainwt[5];
   }
}
#endif


#endif
