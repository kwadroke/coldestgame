#ifndef OBJECTKDTREE_H
#define OBJECTKDTREE_H

#include "WorldObjects.h"
#include "Vector3.h"
#include "GenericPrimitive.h"
#include "GraphicMatrix.h"
#include <list>
#include <vector>
#include <set>
#include "SDL_thread.h"
#include "Timer.h"
//#include <ext/hash_set>

#define PI 3.14159265

using namespace std;

class ObjectKDTree
{
   public:
      ObjectKDTree();
      ObjectKDTree(list<WorldObjects>*, Vector3[]);
      ObjectKDTree(const ObjectKDTree&);
      ObjectKDTree& operator=(const ObjectKDTree&);
      ~ObjectKDTree();
      void refine(int);
      bool insert(WorldObjects*);
      void setvertices(Vector3[]);
      void setfrustum(Vector3, Vector3, float, float, float, float);
      void setfrustum(vector<WorldPrimitives>*);
      vector<GenericPrimitive*> getprims(Vector3, float);
      list<WorldObjects*> getobjs();//Vector3, Vector3, float, float, float, float);
      void visualize();
      
   private:
      int size();
      bool innode(Vector3, float);
      bool innode2d(Vector3, float);
      bool infrustum();//Vector3, Vector3, float, float, float, float);
      bool infrustum(WorldObjects*);
      void vecappend(vector<GenericPrimitive*> &, vector<GenericPrimitive*> &);
      void objvecappend(list<WorldObjects*> &, list<WorldObjects*> &);
      void setretobjs(set<WorldObjects*>*);
      
      
      vector<ObjectKDTree> children;
      list<WorldObjects*> members;
      bool haschildren;
      Vector3 vertices[8];
      set<WorldObjects*>* retobjs;
      bool root;
      vector<WorldPrimitives> p; // Only set in root node
      vector<WorldPrimitives>* frustum; // Pointer to root's p
};

#endif
