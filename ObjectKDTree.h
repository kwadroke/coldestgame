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


#ifndef OBJECTKDTREE_H
#define OBJECTKDTREE_H

#include "Mesh.h"
#include "Vector3.h"
#include <list>
#include <vector>
#include <set>
#include "SDL_thread.h"
#include "Timer.h"
#include "Camera.h"
#include <boost/shared_ptr.hpp>
#ifdef __GNUG__
// This may not be ready for primetime yet (or I'm stupid, but either way it's getting commented out)
//#   if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 3)
#      include <ext/hash_set>
//#   else
//#      include <unordered_set>
//#   endif
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
      return (uintptr_t)hashme % 10000; // Umm, probably not ideal, but we can fix it later
   }
};

#ifdef linux
//#if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 3)
typedef __gnu_cxx::hash_set<Mesh*, eqptr, eqptr> MeshSet;
//#else
//typedef unordered_set<Mesh*> MeshSet;
//typedef set<Mesh*> MeshSet;
//#endif
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
      void setfrustum(const Camera&, float, float, float, float, bool);
      void setfrustum(Quadvec*);
      bool infrustum(Mesh*);
      vector<Mesh*> getmeshes(const Vector3&, const float);
      vector<Mesh*> getmeshes(const Vector3&, const Vector3&, const float);
      list<Mesh*> getmeshes();
      void visualize();

   private:
      int size();
      bool innode(Vector3, float);
      bool infrustum();
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
