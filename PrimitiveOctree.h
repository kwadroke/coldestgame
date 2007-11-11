#ifndef __PRIMITIVEOCTREE
#define __PRIMITIVEOCTREE

#define NO_SDL_GLEXT
#include <vector>
#include "GenericPrimitive.h"
#include "Vector3.h"
#include "SDL_opengl.h"

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
