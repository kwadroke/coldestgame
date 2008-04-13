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
#include "Quad.h"
#include "Timer.h"
#include "SDL_thread.h"

using namespace std;

class CollisionDetection
{
   public:
      CollisionDetection();
      CollisionDetection& operator=(const CollisionDetection&);
      Vector3 CheckSphereHit(const Vector3&, const Vector3&, const float&, vector<Mesh*>&,
                             stack<Mesh*>* = NULL, const bool debug = false);
      Vector3 CheckSphereHitDebug(const Vector3&, const Vector3&, const float&, vector<Mesh*>&,
                             stack<Mesh*>* = NULL);
      Vector3 PlaneSphereCollision(Vector3vec, const Vector3&, const Vector3&, const float&, const bool debug = false);
      Vector3 PlaneEdgeSphereCollision(Vector3vec, const Vector3&, const float&);
      int intmethod;
      bool quiet;
      int tilesize;
      vector<Quad> worldbounds;
      
   private:
      bool InVector(Mesh*, vector<Meshlist::iterator>&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const Vector3&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&, float&, Vector3&);
};
#endif
