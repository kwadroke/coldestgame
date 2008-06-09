#include "Vertex.h"

Vertex::Vertex() : index(0)
{
   floatvec tc(2, 0.f);
   texcoords = vector<floatvec>(8, tc);
   color = GLubytevec(4, 255);
   terrainwt = floatvec(6, 0.f);
}


VBOData Vertex::GetVboData()
{
   VBOData ret;
   
   ret.x = pos.x;
   ret.y = pos.y;
   ret.z = pos.z;
   ret.nx = norm.x;
   ret.ny = norm.y;
   ret.nz = norm.z;
   
   ret.tx = tangent.x;
   ret.ty = tangent.y;
   ret.tz = tangent.z;
   
   for (int i = 0; i < 8; ++i)
   {
      ret.tc[i][0] = texcoords[i][0];
      ret.tc[i][1] = texcoords[i][1];
   }
   ret.r = color[0];
   ret.g = color[1];
   ret.b = color[2];
   ret.a = color[3];
   ret.terrainwt[0] = terrainwt[0];
   ret.terrainwt[1] = terrainwt[1];
   ret.terrainwt[2] = terrainwt[2];
   ret.terrainwt1[0] = terrainwt[3];
   ret.terrainwt1[1] = terrainwt[4];
   ret.terrainwt1[2] = terrainwt[5];
   return ret;
}



