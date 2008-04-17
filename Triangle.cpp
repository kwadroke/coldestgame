#include "Triangle.h"

Triangle::Triangle() : vert(Vector3vec(3, Vector3())), norm(Vector3vec(3, Vector3())), 
                   material(NULL), tangent(Vector3()), collide(false), dist(0.f), matrix(GraphicMatrix())
{
   floatvec tc(2, 0.f);
   vector<floatvec> tcv(3, tc);
   texcoords = vector< vector<floatvec> >(8, tcv);
   color = vector<GLubytevec>(3, GLubytevec(4, 255));
   terrainwt = vector<floatvec>(3, floatvec(6, 0.f));
}


VBOData Triangle::GetVboData(const int vertex)
{
   VBOData ret;
   
   ret.x = vert[vertex].x;
   ret.y = vert[vertex].y;
   ret.z = vert[vertex].z;
   ret.nx = norm[vertex].x;
   ret.ny = norm[vertex].y;
   ret.nz = norm[vertex].z;
   
   // Compute tangent
   Vector3 one = vert[1] - vert[0];
   Vector3 two = vert[2] - vert[0];
   float tcone = texcoords[0][1][1] - texcoords[0][0][1];
   float tctwo = texcoords[0][2][1] - texcoords[0][0][1];
   tangent = one * -tctwo + two * tcone;
   ret.tx = tangent.x;
   ret.ty = tangent.y;
   ret.tz = tangent.z;
   
   for (int i = 0; i < 8; ++i)
   {
      ret.tc[i][0] = texcoords[i][vertex][0];
      ret.tc[i][1] = texcoords[i][vertex][1];
   }
   ret.r = color[vertex][0];
   ret.g = color[vertex][1];
   ret.b = color[vertex][2];
   ret.a = color[vertex][3];
   ret.terrainwt[0] = terrainwt[vertex][0];
   ret.terrainwt[1] = terrainwt[vertex][1];
   ret.terrainwt[2] = terrainwt[vertex][2];
   ret.terrainwt1[0] = terrainwt[vertex][3];
   ret.terrainwt1[1] = terrainwt[vertex][4];
   ret.terrainwt1[2] = terrainwt[vertex][5];
   return ret;
}


bool Triangle::operator<(const Triangle& t) const
{
   return material < t.material;
}


bool Triangle::operator>(const Triangle& t) const
{
   return material > t.material;
}


