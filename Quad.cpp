#include "Quad.h"

Quad::Quad() : first(Triangle()), second(Triangle())
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
            first.texcoords[i][vert] = tcv[j];
         if (vert1 >= 0)
            second.texcoords[i][vert1] = tcv[j];
      }
   }
}


void Quad::SetVertex(const int num, const Vector3& v)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first.vert[vert] = v;
   if (vert1 >= 0 && vert1 < 3)
      second.vert[vert1] = v;
}


Vector3 Quad::GetVertex(const int num) const
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      return first.vert[vert];
   if (vert1 >= 0 && vert1 < 3) 
      return second.vert[vert1];
   return Vector3(); // Uh oh
}


void Quad::SetNormal(const int num, const Vector3& v)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first.norm[vert] = v;
   if (vert1 >= 0 && vert1 < 3)
      second.norm[vert1] = v;
}


void Quad::SetColor(const int num, const GLubytevec val)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first.color[vert] = val;
   if (vert1 >= 0 && vert1 < 3)
      second.color[vert1] = val;
}


void Quad::SetTexCoords(const int num, const int texunit, const floatvec val)
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first.texcoords[texunit][vert] = val;
   if (vert1 >= 0 && vert1 < 3)
      second.texcoords[texunit][vert1] = val;
}


void Quad::SetTerrainWeight(const int vertex, const int tex, const float val)
{
   int vert, vert1;
   
   GetVertNums(vertex, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      first.terrainwt[vert][tex] = val;
   if (vert1 >= 0 && vert1 < 3)
      second.terrainwt[vert1][tex] = val;
}


void Quad::GetVertNums(const int num, int& firstv, int& secondv) const
{
   switch(num)
   {
      case 0:
         firstv = 0;
         secondv = -1;
         break;
      case 1:
         firstv = 1;
         secondv = 0;
         break;
      case 2:
         firstv = -1;
         secondv = 1;
         break;
      case 3:
         firstv = 2;
         secondv = 2;
         break;
      default:
         cout << "Warning, bogus vertex passed to GetVertNums" << endl;
         break;
   };
}


void Quad::SetCollide(bool val)
{
   first.collide = val;
   second.collide = val;
}


void Quad::SetMaterial(Material* m)
{
   m->Use();
   first.material = m;
   second.material = m;
}


Triangle Quad::First()
{
   return first;
}

Triangle Quad:: Second()
{
   return second;
}

