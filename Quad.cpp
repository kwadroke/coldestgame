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


#include "Quad.h"

Quad::Quad(VertexHeap& vh) : first(new Triangle(vh)), second(new Triangle(vh))
{
   second->v[0] = first->v[1];
   second->v[2] = first->v[2];
   floatvec tc(2, 0.f);
   vector<floatvec> tcv(4, tc);
   tcv[1][1] = 1.f;
   tcv[2][0] = 1.f;
   tcv[2][1] = 1.f;
   tcv[3][0] = 1.f;
   int vert, vert1;
   for (int i = 0; i < 8; ++i)
   {
      for (int j = 0; j < 4; ++j)
      {
         GetVertNums(j, vert, vert1);
         if (vert >= 0)
            first->v[vert]->texcoords[i] = tcv[j];
         if (vert1 >= 0)
            second->v[vert1]->texcoords[i] = tcv[j];
      }
   }
   vertheap = &vh; // Need to save this so we can use it for copying later
}


Quad::Quad(const Quad& q) : first(new Triangle(*q.first)), second(new Triangle(*q.second))
{
   vertheap = q.vertheap;
   for (size_t i = 0; i < 3; ++i)
   {
      first->v[i] = vertheap->insert(*first->v[i]);
      second->v[i] = vertheap->insert(*second->v[i]);
   }
   second->v[0] = first->v[1];
   second->v[2] = first->v[2];
}


Quad& Quad::operator=(const Quad& q)
{
   first = TrianglePtr(new Triangle(*q.first));
   second = TrianglePtr(new Triangle(*q.second));
   vertheap = q.vertheap;
   for (size_t i = 0; i < 3; ++i)
   {
      first->v[i] = vertheap->insert(*first->v[i]);
      second->v[i] = vertheap->insert(*second->v[i]);
   }
   second->v[0] = first->v[1];
   second->v[2] = first->v[2];
   return *this;
}


void Quad::SetVertexVHP(const int num, const VertexVHP& v)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert] = v;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1] = v;
}


VertexVHP Quad::GetVertexVHP(const int num) const
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      return first->v[vert];
   if (vert1 >= 0 && vert1 < 3) 
      return second->v[vert1];
   return VertexVHP(); // Uh oh
}


void Quad::SetVertex(const int num, const Vector3& v)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert]->pos = v;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1]->pos = v;
}


void Quad::SetNormal(const int num, const Vector3& v)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert]->norm = v;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1]->norm = v;
}


void Quad::SetColor(const int num, const GLubytevec val)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert]->color = val;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1]->color = val;
}


void Quad::SetTexCoords(const int num, const int texunit, const floatvec val)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert]->texcoords[texunit] = val;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1]->texcoords[texunit] = val;
}


void Quad::SetTerrainWeight(const int vertex, const int tex, const float val)
{
   int vert, vert1;
   
   GetVertNums(vertex, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first->v[vert]->terrainwt[tex] = val;
   if (vert1 >= 0 && vert1 < 3)
      second->v[vert1]->terrainwt[tex] = val;
}


void Quad::SetCollide(bool val)
{
   first->collide = val;
   second->collide = val;
}


void Quad::SetMaterial(Material* m)
{
   m->Use();
   first->material = m;
   second->material = m;
}


void Quad::ChangeHeap(VertexHeap& h)
{
   vertheap = &h;
   for (size_t i = 0; i < 3; ++i)
   {
      first->v[i].changeheap(h);
      second->v[i].changeheap(h);
   }
}

