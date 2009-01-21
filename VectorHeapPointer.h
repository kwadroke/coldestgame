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
