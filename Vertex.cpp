#include "Vertex.h"

Vertex::Vertex() : index(0), norm(Vector3(0, 0, 1))
{
   floatvec tc(2, 0.f);
   texcoords = vector<floatvec>(8, tc);
   color = GLubytevec(4, 255);
   terrainwt = floatvec(6, 0.f);
#ifdef EDITOR
   id = "";
#endif
}


VBOData& Vertex::GetVboData()
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
   
   for (int i = 0; i < 8; ++i)
   {
      vbodata.tc[i][0] = texcoords[i][0];
      vbodata.tc[i][1] = texcoords[i][1];
   }
   vbodata.r = color[0];
   vbodata.g = color[1];
   vbodata.b = color[2];
   vbodata.a = color[3];
   vbodata.terrainwt[0] = terrainwt[0];
   vbodata.terrainwt[1] = terrainwt[1];
   vbodata.terrainwt[2] = terrainwt[2];
   vbodata.terrainwt1[0] = terrainwt[3];
   vbodata.terrainwt1[1] = terrainwt[4];
   vbodata.terrainwt1[2] = terrainwt[5];
   return vbodata;
}



