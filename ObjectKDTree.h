#ifndef OBJECTKDTREE_H
#define OBJECTKDTREE_H

#include "Mesh.h"
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
   bool operator()(Mesh* p1, Mesh* p2) const
   {
      return (p1 == p2);
   }
   bool operator()(Mesh* hashme) const
   {
      return (intptr_t)hashme % 100000; // Umm, probably not ideal, but we can fix it later
   }
};

typedef __gnu_cxx::hash_set<Mesh*, eqptr, eqptr> MeshSet;
//typedef set<Mesh*> MeshSet;

class ObjectKDTree
{
   public:
      ObjectKDTree();
      ObjectKDTree(Meshlist*, Vector3vec);
      ObjectKDTree(const ObjectKDTree&);
      ObjectKDTree& operator=(const ObjectKDTree&);
      ~ObjectKDTree();
      void refine(int);
      bool insert(Mesh*);
      void setvertices(Vector3vec);
      void setfrustum(Vector3, Vector3, float, float, float, float);
      void setfrustum(Quadvec*);
      //vector<Triangle*> gettris(Vector3, float);
      vector<Mesh*> getmeshes(const Vector3&, const float);
      vector<Mesh*> getmeshes(const Vector3&, const Vector3&, const float);
      list<Mesh*> getmeshes();//Vector3, Vector3, float, float, float, float);
      void visualize();
      
   private:
      int size();
      bool innode(Vector3, float);
      bool innode2d(Vector3, float);
      bool infrustum();//Vector3, Vector3, float, float, float, float);
      bool infrustum(Mesh*);
      void setretobjs(MeshSet*);
      void getmeshes(const Vector3&, const float, vector<Mesh*>&);
      void getmeshes(list<Mesh*>&);
      
      
      vector<ObjectKDTree> children;
      list<Mesh*> members;
      bool haschildren;
      Vector3vec vertices;
      //set<WorldObjects*>* retobjs;
      MeshSet* retobjs;
      bool root;
      Quadvec p; // Only set in root node
      Quadvec* frustum; // Pointer to root's p
      static int maxlevels;
};

#endif
