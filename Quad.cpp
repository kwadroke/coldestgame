#include "Quad.h"

Quad::Quad() : first(new Triangle()), second(new Triangle())
{
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
}


Quad::Quad(const Quad& q) : first(new Triangle(*q.first)), second(new Triangle(*q.second))
{
   for (size_t i = 0; i < 3; ++i)
   {
      first->v[i] = VertexPtr(new Vertex(*first->v[i]));
      second->v[i] = VertexPtr(new Vertex(*second->v[i]));
   }
}


Quad& Quad::operator=(const Quad& q)
{
   first = TrianglePtr(new Triangle(*q.first));
   second = TrianglePtr(new Triangle(*q.second));
   for (size_t i = 0; i < 3; ++i)
   {
      first->v[i] = VertexPtr(new Vertex(*first->v[i]));
      second->v[i] = VertexPtr(new Vertex(*second->v[i]));
   }
   return *this;
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

