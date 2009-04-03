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


#ifndef __PRIMITIVEOCTREE
#define __PRIMITIVEOCTREE

#include "glinc.h"
#include <vector>
#include "GenericPrimitive.h"
#include "Vector3.h"

using namespace std;

class PrimitiveOctree
{
   public:
      PrimitiveOctree(vector<GenericPrimitive>);
      void refine();
      void refine(int);
      bool innode(GenericPrimitive &);
      void setvertices(Vector3[]);
      bool empty();
      void clear();
      int size();
      void add(GenericPrimitive);
      void addall(vector<GenericPrimitive>);
      vector<GenericPrimitive> getprims(Vector3, float);
      PrimitiveOctree *child[8];
      Vector3 vertices[8];
      void visualize();
      
   private:
      vector<GenericPrimitive> prims;
      bool haschildren;
};

#endif
