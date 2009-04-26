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
      float DistanceBetweenPointAndLine(const Vector3&, const Vector3&, const Vector3&, const float);
      bool UnitTest();
      
      int intmethod;
      int tilesize;
      vector<Quad> worldbounds;
      
   private:
      bool PlaneSphereCollision(Vector3&, const Triangle&, const Vector3&, const Vector3&, const float&, Vector3&, const bool debug = false);
      bool PlaneEdgeSphereCollision(Vector3&, const Triangle&, const Vector3&, const float&);
      bool VectorEdgeCheck(Vector3&, const Triangle&, const Vector3&, const Vector3&, const float&);
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
float CollisionDetection::DistanceBetweenPointAndLine(const Vector3& point, const Vector3& start, const Vector3& move, const float movemaginv)
{
   // This check is not required for any code that calls us and it helps performance significantly if we don't do it
   //if (movemag < 1e-5f) return 0.f;
   return(move.cross(start - point).magnitude() * movemaginv);
}
#endif
#endif
