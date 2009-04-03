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


#include "Triangle.h"

Triangle::Triangle(VertexHeap& vertheap) : v(VertexVHPvec(3)), material(NULL), collide(false),
                   matrix(GraphicMatrix()), maxdim(-1.f), radmod(0.f)
{
   for (size_t i = 0; i < 3; ++i)
      v[i] = vertheap.insert();
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
   midpoint = (v[0]->pos + v[1]->pos + v[2]->pos) / 3.f;
   maxdim = v[0]->pos.distance2(midpoint);
   float tempdim = v[1]->pos.distance2(midpoint);
   if (tempdim > maxdim)
      maxdim = tempdim;
   tempdim = v[2]->pos.distance2(midpoint);
   if (tempdim > maxdim)
      maxdim = tempdim;
   maxdim = sqrt(maxdim);
   maxdim += radmod;
}


float Triangle::Perimeter(const Vector3& one, const Vector3& two, const Vector3& three)
{
   return one.distance(two) + two.distance(three) + three.distance(one);
}


