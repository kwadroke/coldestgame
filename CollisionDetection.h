#ifndef __COLLISION_DETECTION
#define __COLLISION_DETECTION

#include <vector>
#include <list>
#include "ObjectKDTree.h"
#include "Vector3.h"
#include "Quad.h"
#include "Timer.h"
#include "SDL_thread.h"

#define INLINE_COLDET

using namespace std;

class CollisionDetection
{
   public:
      CollisionDetection();
      CollisionDetection& operator=(const CollisionDetection&);
      Vector3 CheckSphereHit(const Vector3&, const Vector3&, const float&, vector<Mesh*>&, Vector3&, Mesh*&,
                             vector<Mesh*>* = NULL, const bool extcheck = true, const bool debug = false);
      Vector3 CheckSphereHit(const Vector3&, const Vector3&, const float&, vector<Mesh*>&, const bool extcheck = true);
      // Useful for external code too
      float DistanceBetweenPointAndLine(const Vector3&, const Vector3&, const Vector3&);
      bool UnitTest();
      
      int intmethod;
      int tilesize;
      vector<Quad> worldbounds;
      
   private:
      Vector3 PlaneSphereCollision(const Triangle&, const Vector3&, const Vector3&, const float&, Vector3&, const bool debug = false);
      Vector3 PlaneEdgeSphereCollision(const Triangle&, const Vector3&, const float&);
      Vector3 VectorEdgeCheck(const Triangle&, const Vector3&, const Vector3&, const float&);
      bool InVector(Mesh*, vector<Meshlist::iterator>&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const Vector3&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&);
      bool CrossesPlane(const Vector3&, const Vector3&, const Vector3&, const float&, float&, Vector3&, float&, Vector3&);
      float DistanceBetweenLines(const Vector3& start, const Vector3& dir, const Vector3& start1, const Vector3& dir1, float&, float&);
      bool RaySphereCheck(const Vector3& raystart, const Vector3& rayend,
                     const Vector3& spherepos, const float radius, Vector3& adjust);
};

// From http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
#ifdef INLINE_COLDET
inline
float CollisionDetection::DistanceBetweenPointAndLine(const Vector3& point, const Vector3& start, const Vector3& end)
{
   if (start.distance2(end) < 1e-5f) return 0.f;
   return ((end - start).cross(start - point)).magnitude() / (end - start).magnitude();
}
#endif
#endif
