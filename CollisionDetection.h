#ifndef __COLLISION_DETECTION
#define __COLLISION_DETECTION

#include <vector>
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
                             vector<Mesh*>* = NULL, const bool debug = false);
      Vector3 CheckSphereHitDebug(const Vector3&, const Vector3&, const float&, vector<Mesh*>&,
                             vector<Mesh*>* = NULL);
      bool UnitTest();
      
      int intmethod;
      int tilesize;
      vector<Quad> worldbounds;
      
   private:
      Vector3 PlaneSphereCollision(Vector3vec, const Vector3&, const Vector3&, const float&, const bool debug = false);
      Vector3 PlaneEdgeSphereCollision(const Vector3vec&, const Vector3&, const float&);
      Vector3 VectorEdgeCheck(const Vector3vec&, const Vector3&, const Vector3&, const float&);
      bool InVector(Mesh*, vector<Meshlist::iterator>&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const Vector3&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&, float&, Vector3&);
      float DistanceBetweenLines(const Vector3& start, const Vector3& dir, const Vector3& start1, const Vector3& dir1, float&, float&);
      bool RaySphereCheck(const Vector3& raystart, const Vector3& rayend,
                     const Vector3& spherepos, const float radius, Vector3& adjust);
};
#endif
