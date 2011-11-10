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
// Copyright 2008, 2011 Ben Nemec
// @End License@


#ifndef __QUAD_H
#define __QUAD_H

#include "Triangle.h"
#include <list>

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Quad
{
   public:
      Quad();
      Quad(const Quad&);
      Quad& operator=(const Quad&);
      void SetVertexPtr(const int, const VertexPtr&);
      VertexPtr GetVertexPtr(const int) const;
      void SetVertex(const int, const Vector3&);
      inline Vector3 GetVertex(const int) const;
      void SetNormal(const int, const Vector3&);
      void SetCollide(bool);
      void SetMaterial(Material*);
      void SetColor(const int, const GLubytevec);
      void SetTexCoords(const int, const int, const floatvec);
      void SetTerrainWeight(const int, const int, const float);
      void Translate(const Vector3&);
      void Scale(const float);
      TrianglePtr First() {return first;}
      TrianglePtr Second() {return second;}
      
   private:
      inline void GetVertNums(const int, int&, int&) const;
      
      TrianglePtr first, second;

};

typedef vector<Quad> Quadvec;
typedef std::list<Quad> Quadlist;


Vector3 Quad::GetVertex(const int num) const
{
   int vert, vert1;
   
   GetVertNums(num, vert, vert1);
   
   if (vert >= 0 && vert < 3)
      return first->v[vert]->pos;
   if (vert1 >= 0 && vert1 < 3) 
      return second->v[vert1]->pos;
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
         firstv = -1; // Avoid uninitialized variable warnings
         secondv = -1;
         logout << "Warning, bogus vertex passed to GetVertNums" << endl;
         break;
   };
}

#endif
