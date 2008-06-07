#ifndef __QUAD_H
#define __QUAD_H

#include "Triangle.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Quad
{
   public:
      Quad();
      Quad(const Quad&);
      Quad& operator=(const Quad&);
      void SetVertex(const int, const Vector3&);
      inline Vector3 GetVertex(const int) const;
      void SetNormal(const int, const Vector3&);
      void SetCollide(bool);
      void SetMaterial(Material*);
      void SetColor(const int, const GLubytevec);
      void SetTexCoords(const int, const int, const floatvec);
      void SetTerrainWeight(const int, const int, const float);
      TrianglePtr First() {return first;}
      TrianglePtr Second() {return second;}
      
   private:
      inline void GetVertNums(const int, int&, int&) const;
      
      TrianglePtr first, second;

};

typedef vector<Quad> Quadvec;


Vector3 Quad::GetVertex(const int num) const
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      return first->v[vert].pos;
   if (vert1 >= 0 && vert1 < 3) 
      return second->v[vert1].pos;
   return Vector3(); // Uh oh
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

#endif
