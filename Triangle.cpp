#include "Triangle.h"

Triangle::Triangle() : maxdim(-1.f), material(NULL), collide(false),   
                       matrix(GraphicMatrix()), radmod(0.f), v(VertexPtrvec(3))
{
   for (size_t i = 0; i < 3; ++i)
      v[i] = VertexPtr(new Vertex());
}


ushortvec Triangle::GetIndices()
{
   ushortvec ret;
   for (int i = 0; i < 3; ++i)
      ret.push_back(v[i]->index);
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
   maxdim = v[0]->pos.distance(v[1]->pos);
   float tempdim = v[0]->pos.distance(v[2]->pos);
   if (tempdim > maxdim) maxdim = tempdim;
   tempdim = v[1]->pos.distance(v[2]->pos);
   if (tempdim > maxdim) maxdim = tempdim;
   midpoint = (v[0]->pos + v[1]->pos + v[2]->pos) / 3.f;
   maxdim += radmod;
}


