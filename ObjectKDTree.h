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
#include <ext/hash_set>

#define PI 3.14159265

using namespace std;

struct eqptr
{
   bool operator()(WorldObjects* p1, WorldObjects* p2) const
   {
      return (p1 == p2);
   }
   bool operator()(WorldObjects* hashme) const
   {
      return (unsigned long)hashme % 500000; // Umm, probably not ideal, but we can fix it later
   }
};

typedef __gnu_cxx::hash_set<WorldObjects*, eqptr, eqptr> ObjectSet;

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
      void setretobjs(ObjectSet*);
      void getprims(Vector3, float, vector<GenericPrimitive*>&);
      void getobjs(list<WorldObjects*>&);
      
      
      vector<ObjectKDTree> children;
      list<WorldObjects*> members;
      bool haschildren;
      Vector3 vertices[8];
      //set<WorldObjects*>* retobjs;
      ObjectSet* retobjs;
      bool root;
      vector<WorldPrimitives> p; // Only set in root node
      vector<WorldPrimitives>* frustum; // Pointer to root's p
      static int maxlevels;
};

#endif
