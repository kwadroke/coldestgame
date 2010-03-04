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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __VECTORHEAP_H
#define __VECTORHEAP_H

#include <vector>

using std::vector;

template <class T> class VectorHeapPointer;

/**
	@author Ben Nemec <cybertron@nemebean.com>
   
   This class is designed to allow for reference counted pointer semantics where
   the objects pointed to are actually contained in a vector for better cache
   coherency.

   Note that items are never actually removed from the vector - when their refcount
   becomes 0 then that slot becomes available for reuse.
*/
template <class T>
class VectorHeap
{
   friend class VectorHeapPointer<T>;
   public:
      VectorHeap(size_t reserve = 0);
      ~VectorHeap();
      VectorHeapPointer<T> insert(T&);
      VectorHeapPointer<T> insert();
   
   private:
      vector<T> v;
      vector<size_t> refcount;
      bool valid;

};


#include "VectorHeapPointer.h"

template <class T>
VectorHeap<T>::VectorHeap(size_t reserve) : valid(true)
{
   if (reserve)
      v.reserve(reserve);
}


// This only exists as a sanity check for the pointers pointing into us.
// We can check that valid is true before pointer operations and that way hopefully
// if this object was destroyed with pointers still pointing at it, we'll catch it.
// Theoretically we could be destroyed and overwritten with something that puts 0
// at the valid position, so it's not perfect, but I figure it's better than nothing
template <class T>
VectorHeap<T>::~VectorHeap()
{
   valid = false;
}


template <class T>
VectorHeapPointer<T> VectorHeap<T>::insert(T& object)
{
   size_t rsize = refcount.size();
   for (size_t i = 0; i < rsize; ++i)
   {
      if (refcount[i] == 0)
      {
         v[i] = object;
         return VectorHeapPointer<T>(this, i);
      }
   }
   v.push_back(object);
   refcount.push_back(0);
   return VectorHeapPointer<T>(this, v.size() - 1);
}


template <class T>
VectorHeapPointer<T> VectorHeap<T>::insert()
{
   T newobj;
   return insert(newobj);
}

#endif
