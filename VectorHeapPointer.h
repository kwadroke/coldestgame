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


#ifndef __VECTORHEAPPOINTER_H
#define __VECTORHEAPPOINTER_H

#include <cstring> // For size_t
#include "VectorHeap.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
template <class T>
class VectorHeapPointer
{
   private:
      size_t index;
      VectorHeap<T>* heap;
      
   public:
      VectorHeapPointer(VectorHeap<T>* h = NULL, size_t i = 0) : index(i), heap(h)
      {
         if (heap)
         {
            assert(heap->valid);
            ++heap->refcount[index];
         }
      }
      
      ~VectorHeapPointer()
      {
         if (heap)
         {
            assert(heap->valid);
            --heap->refcount[index];
         }
      }
      
      VectorHeapPointer(const VectorHeapPointer<T>& p) : index(p.index), heap(p.heap)
      {
         if (heap)
         {
            assert(heap->valid);
            ++heap->refcount[index];
         }
      }
      
      VectorHeapPointer& operator=(const VectorHeapPointer<T>& p)
      {
         if (&p != this)
         {
            index = p.index;
            heap = p.heap;
            if (heap)
            {
               assert(heap->valid);
               ++heap->refcount[index];
            }
         }
         return *this;
      }
      
      T& operator*() const
      {
         assert(heap != NULL);
         assert(heap->valid);
         return heap->v[index];
      }
      
      // Note: This function is not thread-safe.  If someone changes the heap after this call the pointer
      // returned could become invalid.
      T* operator->() const
      {
         assert(heap != NULL);
         assert(heap->valid);
         return &heap->v[index];
      }
      
      operator bool() const
      {
         return heap != NULL;
      }
      
      bool operator==(const VectorHeapPointer<T>& p) const
      {
         return index == p.index && heap == p.heap;
      }
      
      bool operator<(const VectorHeapPointer<T>& p) const
      {
         if (heap != p.heap)
            return heap < p.heap;
         return index < p.index;
      }
      
      
      // Use this if you copy a heap and want to move a pointer from the old one to the new one
      void changeheap(VectorHeap<T>& h)
      {
         heap = &h;
      }

};

#endif
