#ifndef __COLLISION_DETECTION
#define __COLLISION_DETECTION

#include <stack>
#include <list>
#include "ObjectKDTree.h"
#include "DynamicObject.h"
#include "DynamicPrimitive.h"
#include "Vector3.h"
#include "PrimitiveOctree.h"
#include "WorldPrimitives.h"
#include "Timer.h"
#include "SDL_thread.h"

using namespace std;

class CollisionDetection
{
   public:
      CollisionDetection();
      CollisionDetection& operator=(const CollisionDetection&);
      Vector3 CheckSphereHit(const Vector3&, const Vector3&, const float&, list<DynamicObject>*,
                             stack<list<DynamicObject>::iterator>* = NULL);
      Vector3 CheckSphereHit(const Vector3&, const Vector3&, const float&, list<DynamicObject>*,
                             vector<list<DynamicObject>::iterator>&,
                             stack<list<DynamicObject>::iterator>* = NULL);
      Vector3 PlaneSphereCollision(Vector3[], const Vector3&, const Vector3&, const float&);
      Vector3 PlaneEdgeSphereCollision(Vector3[], const Vector3&, const float&);
      //PrimitiveOctree *octree;
      ObjectKDTree *kdtree;
      int intmethod;
      bool listvalid;
      bool quiet;
      int tilesize;
      WorldPrimitives worldbounds[6];
      
   private:
      bool InVector(list<DynamicObject>::iterator&, vector<list<DynamicObject>::iterator>&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&);
      
      vector<GenericPrimitive*> p;
      SDL_mutex* mutex;
};
#endif
