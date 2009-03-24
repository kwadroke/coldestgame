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
// Copyright 2008, 2009 Ben Nemec
// @End License@

#include "Vertex.h"

Vertex::Vertex() : index(0), norm(Vector3(0, 0, 1)), inited(false)
{
   floatvec tc(2, 0.f);
   texcoords = vector<floatvec>(8, tc);
   color = GLubytevec(4, 255);
   terrainwt = floatvec(6, 0.f);
#ifdef EDITOR
   id = "";
#else
   id = 0;
#endif
}


void Vertex::PopulateVboData()
{
   for (int i = 1; i < 8; ++i)
   {
      vbodata.tc[i][0] = texcoords[i][0];
      vbodata.tc[i][1] = texcoords[i][1];
   }
   vbodata.terrainwt[0] = terrainwt[0];
   vbodata.terrainwt[1] = terrainwt[1];
   vbodata.terrainwt[2] = terrainwt[2];
   vbodata.terrainwt1[0] = terrainwt[3];
   vbodata.terrainwt1[1] = terrainwt[4];
   vbodata.terrainwt1[2] = terrainwt[5];
   inited = true;
}


VBOData& Vertex::GetVboData()
{
   if (!inited)
      PopulateVboData();
   vbodata.x = pos.x;
   vbodata.y = pos.y;
   vbodata.z = pos.z;
   vbodata.nx = norm.x;
   vbodata.ny = norm.y;
   vbodata.nz = norm.z;
   
   vbodata.tx = tangent.x;
   vbodata.ty = tangent.y;
   vbodata.tz = tangent.z;
   
//    for (int i = 0; i < 8; ++i)
//    {
//       vbodata.tc[i][0] = texcoords[i][0];
//       vbodata.tc[i][1] = texcoords[i][1];
//    }
   // This will only allow a single texture coordinate to be animated, but that should be okay
   vbodata.tc[0][0] = texcoords[0][0];
   vbodata.tc[0][1] = texcoords[0][1];
   vbodata.r = color[0];
   vbodata.g = color[1];
   vbodata.b = color[2];
   vbodata.a = color[3];
//    vbodata.terrainwt[0] = terrainwt[0];
//    vbodata.terrainwt[1] = terrainwt[1];
//    vbodata.terrainwt[2] = terrainwt[2];
//    vbodata.terrainwt1[0] = terrainwt[3];
//    vbodata.terrainwt1[1] = terrainwt[4];
//    vbodata.terrainwt1[2] = terrainwt[5];
   return vbodata;
}
