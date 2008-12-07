#ifndef OBJECTKDTREE_H
#define OBJECTKDTREE_H

#include "Mesh.h"
#include "Vector3.h"
#include <list>
#include <vector>
#include <set>
#include "SDL_thread.h"
#include "Timer.h"
#include <boost/shared_ptr.hpp>
#ifdef __GNUG__
#include <ext/hash_set>
#else
#include <hash_set>
#endif

#define PI 3.14159265

using namespace std;

struct eqptr
{
   bool operator()(Mesh* p1, Mesh* p2) const
   {
      return (p1 == p2);
   }
   intptr_t operator()(Mesh* hashme) const
   {
      return (intptr_t)hashme % 10000; // Umm, probably not ideal, but we can fix it later
   }
};

#ifdef linux
typedef __gnu_cxx::hash_set<Mesh*, eqptr, eqptr> MeshSet;
//typedef set<Mesh*> MeshSet;
#else
//typedef stdext::hash_set<Mesh*, eqptr> MeshSet;
typedef set<Mesh*> MeshSet;
#endif

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
      void erase(Mesh*);
      void setvertices(Vector3vec);
      void setfrustum(Vector3, Vector3, float, float, float, float);
      void setfrustum(Quadvec*);
      vector<Mesh*> getmeshes(const Vector3&, const float);
      vector<Mesh*> getmeshes(const Vector3&, const Vector3&, const float);
      list<Mesh*> getmeshes();
      void visualize();

   private:
      int size();
      bool innode(Vector3, float);
      bool infrustum();
      bool infrustum(Mesh*);
      void setretobjs(MeshSet*);
      void getmeshes(const Vector3&, const float, vector<Mesh*>&);
      void getmeshes(list<Mesh*>&);


      vector<shared_ptr<ObjectKDTree> > children;
      list<Mesh*> members;
      bool haschildren;
      Vector3vec vertices;
      MeshSet* retobjs;
      bool root;
      Quadvec p; // Only set in root node
      Quadvec* frustum; // Pointer to root's p
      static int maxlevels;
};

typedef shared_ptr<ObjectKDTree> ObjectKDTreePtr;

#endif
