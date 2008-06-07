#include "Triangle.h"

Triangle::Triangle() : maxdim(-1.f), material(NULL), collide(false),   
                       matrix(GraphicMatrix()), radmod(0.f), v(Vertexvec(3, Vertex()))
{
}


VBOData Triangle::GetVboData(const int vertex)
{
   VBOData ret;
   
   ret.x = v[vertex].pos.x;
   ret.y = v[vertex].pos.y;
   ret.z = v[vertex].pos.z;
   ret.nx = v[vertex].norm.x;
   ret.ny = v[vertex].norm.y;
   ret.nz = v[vertex].norm.z;
   
   // Compute tangent
   Vector3 one = v[1].pos - v[0].pos;
   Vector3 two = v[2].pos - v[0].pos;
   float tcone = v[1].texcoords[0][1] - v[0].texcoords[0][1];
   float tctwo = v[2].texcoords[0][1] - v[0].texcoords[0][1];
   Vector3 tangent = one * -tctwo + two * tcone;
   ret.tx = tangent.x;
   ret.ty = tangent.y;
   ret.tz = tangent.z;
   
   for (int i = 0; i < 8; ++i)
   {
      ret.tc[i][0] = v[vertex].texcoords[i][0];
      ret.tc[i][1] = v[vertex].texcoords[i][1];
   }
   ret.r = v[vertex].color[0];
   ret.g = v[vertex].color[1];
   ret.b = v[vertex].color[2];
   ret.a = v[vertex].color[3];
   ret.terrainwt[0] = v[vertex].terrainwt[0];
   ret.terrainwt[1] = v[vertex].terrainwt[1];
   ret.terrainwt[2] = v[vertex].terrainwt[2];
   ret.terrainwt1[0] = v[vertex].terrainwt[3];
   ret.terrainwt1[1] = v[vertex].terrainwt[4];
   ret.terrainwt1[2] = v[vertex].terrainwt[5];
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


bool Triangle::TriPtrComp(const TrianglePtr& l, const TrianglePtr& r)
{
   return *l < *r;
}


void Triangle::CalcMaxDim()
{
   maxdim = v[0].pos.distance(v[1].pos);
   float tempdim = v[0].pos.distance(v[2].pos);
   if (tempdim > maxdim) maxdim = tempdim;
   tempdim = v[1].pos.distance(v[2].pos);
   if (tempdim > maxdim) maxdim = tempdim;
   midpoint = (v[0].pos + v[1].pos + v[2].pos) / 3.f;
   maxdim += radmod;
}


