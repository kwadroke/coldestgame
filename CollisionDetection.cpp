#include "CollisionDetection.h"
#include "globals.h" // for floatzero

#define PI 3.14159265


CollisionDetection::CollisionDetection() : worldbounds(6, Quad())
{
   intmethod = 0;
}


CollisionDetection& CollisionDetection::operator=(const CollisionDetection& o)
{
   intmethod = o.intmethod;
   tilesize = o.tilesize;
   worldbounds = o.worldbounds;
   return *this;
}


Vector3 CollisionDetection::CheckSphereHitDebug(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& objs,
                                           vector<Mesh*>* retobjs)
{
   Vector3 retval = CheckSphereHit(oldpos, newpos, radius, objs, retobjs, true);
   return retval;
}


/* Make sure that the movement from oldpos to newpos by the sphere
   of size radius is allowed, and if not return a vector that will
   adjust the position so it is closer to valid (it won't necessarily
   make it valid)

   If you don't care about finding out what objects (if any) were hit, pass in
   NULL for retobjs, otherwise pass in the appropriate pointer*/
Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& objs,
                                           vector<Mesh*>* retobjs, bool debug)
{
   Vector3 adjust;
   Vector3 temp;
   Vector3 midpoint = (oldpos + newpos) / 2.f;
   float maxdim, tempdim;
   int adjusted = 0;
   
   Mesh* current;
   for (int i = 0; i < objs.size(); i++)
   {
      current = objs[i];
      current->Begin();
      while (current->HasNext())
      {
         Triangle& currtri = current->Next();
         if (currtri.collide)
         {
            if (currtri.maxdim < 0) currtri.CalcMaxDim();
            
            if (currtri.midpoint.distance2(midpoint) < currtri.maxdim + radius * radius)
            {
               temp = adjust;
               adjust += PlaneSphereCollision(currtri.vert, oldpos, newpos, radius);
               if (adjust.distance2(temp) > .00001)
               {
                  adjusted++;
                  if (retobjs)
                     retobjs->push_back(current);
               }
            }
         }
      }
   }
   
   Vector3 v, s, t, u;
   for (int i = 0; i < 6; i++)  // Check the world bounding box
   {
      v = worldbounds[i].GetVertex(0);
      s = worldbounds[i].GetVertex(1);
      t = worldbounds[i].GetVertex(2);
      u = worldbounds[i].GetVertex(3);
            
      Vector3 norm;
      norm = (t - v).cross(s - v);
      norm.normalize();
      v += norm * radius;
      s += norm * radius;
      t += norm * radius;
      u += norm * radius;
      
      float d = -norm.dot(s);
      
      float denominator;
      Vector3 move;
      if (CrossesPlane(oldpos, newpos, norm, d, denominator, move))  // Crossed the plane
      {
         float endside = norm.dot(newpos) + d;
         adjust += norm * -endside;// * 1.05f;
         adjusted++;
      }
   }
   
   // Check edges of polys as well.
   if (adjust.distance2(Vector3()) < .00001)
   {
      for (int i = 0; i < objs.size(); i++)
      {
         current = objs[i];
         current->Begin();
         while (current->HasNext())
         {
            Triangle& currtri = current->Next();
            if (currtri.collide)
            {
               if (currtri.maxdim < 0) currtri.CalcMaxDim();
            
               if (currtri.midpoint.distance2(midpoint) < currtri.maxdim + radius * radius)
               {
                  temp = adjust;
                  adjust += PlaneEdgeSphereCollision(currtri.vert, newpos, radius);
                  if (adjust.distance2(temp) > .00001)
                  {
                     adjusted++;
                     if (retobjs)
                        retobjs->push_back(current);
                  }
               }
            }
         }
      }
   }
   
   
   // If we moved a fairly long distance we're probably a projectile and need to do the following
   // These aren't useful for player movement though so we shouldn't do them in that case.
   if (oldpos.distance2(newpos) > radius * radius * 9)
   {
      // Do another edge check that checks the entire movement path, not just the ending position.
      // This is necessary because projectiles may move significantly larger distances than their
      // radius which can make the previous check fail incorrectly.  This is no longer a problem
      // for on-poly checks because they also check the entire movement path, but the first edge
      // check does not.  We keep it because this check can miss certain collisions (specifically
      // if a movement is close to parallel to the edge so the nearest point of the two vectors
      // falls outside the edge vector, but we still actually touch the edge) which is acceptable
      // for projectiles because the corner test will catch them, but could be a problem for player
      // movement.  Whew.
      if (adjust.distance2(Vector3()) < .00001)
      {
         for (int i = 0; i < objs.size(); i++)
         {
            current = objs[i];
            current->Begin();
            while (current->HasNext())
            {
               Triangle& currtri = current->Next();
               if (currtri.collide)
               {
                  if (currtri.maxdim < 0) currtri.CalcMaxDim();
               
                  if (currtri.midpoint.distance2(midpoint) < currtri.maxdim + radius * radius)
                  {
                     temp = adjust;
                     adjust += VectorEdgeCheck(currtri.vert, oldpos, newpos, radius);
                     if (adjust.distance2(temp) > .00001)
                     {
                        adjusted++;
                        if (retobjs)
                           retobjs->push_back(current);
                     }
                  }
               }
            }
         }
      }
      
      // Do a ray-sphere check on each corner of the triangles.  This is to handle
      // the aforementioned case when we're moving nearly parallel to the edge.
      if (adjust.distance2(Vector3()) < .00001)
      {
         for (int i = 0; i < objs.size(); i++)
         {
            current = objs[i];
            current->Begin();
            while (current->HasNext())
            {
               Triangle& currtri = current->Next();
               if (currtri.collide)
               {
                  if (currtri.maxdim < 0) currtri.CalcMaxDim();
               
                  if (currtri.midpoint.distance2(midpoint) < currtri.maxdim + radius * radius)
                  {
                     for (int j = 0; j < 3; ++j)
                     {
                        if (RaySphereCheck(oldpos, newpos, currtri.vert[j], radius, temp))
                        {
                           adjust += temp;
                           adjusted++;
                           if (retobjs)
                              retobjs->push_back(current);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   
   if (adjusted <= 1)
      return adjust;
   return adjust / (float)adjusted;
}


// May want to precalculate normals where we can to speed things up
Vector3 CollisionDetection::PlaneSphereCollision(Vector3vec v, const Vector3& pos, const Vector3& pos1, const float& radius, bool debug)
{
   Vector3 adjust;
   Vector3 norm = (v[1] - v[0]).cross(v[2] - v[0]);
   norm.normalize();
   
   float d = -norm.dot(v[0]);
   float startside = norm.dot(pos) + d;
   
   // Flip the normal if we start out on the back side
   // or not...it's possible to get bogus hits if we do this
   //if (startside < -1e-3) return Vector3();
   /*if (startside < 0)
   {
      norm = (v[2] - v[0]).cross(v[1] - v[0]);
      norm.normalize();
   }*/
   for (int i = 0; i < 3; ++i)
      v[i] += norm * radius * .9999;
   /*if (startside < 0)
      norm = (v[2] - v[0]).cross(v[1] - v[0]);
   else
      norm = (v[1] - v[0]).cross(v[2] - v[0]);
   norm.normalize();*/
   d = -norm.dot(v[0]);
   
   startside = norm.dot(pos) + d;
   if (startside < -1e-1) return Vector3();
   
   float denominator;
   Vector3 move;
   float x = -1.f;
   Vector3 intpoint;
#if 0
   if (floatzero(v[0].x - norm.x * radius * .98) && floatzero(v[0].z - norm.z * radius * .98))
   {
      float endside = norm.dot(pos1) + d;
      move = pos1 - pos;
      denominator = norm.dot(move);
      norm.print();
      move.print();
      x = -(norm.dot(pos) + d) / denominator;
      intpoint = pos + move * x;
      if (endside < -.0000001)
         cout << "Endside Okay" << endl;
      if (denominator != 0)
         cout << "Den Okay" << endl;
      if (x > -1e-4)
         cout << "X > Okay" << endl;
      else cout << x << endl;
      if (x < move.magnitude() + radius)
         cout << "X < Okay" << endl;
      else
      {
         cout << x << endl;
         cout << (move.magnitude() + radius) << endl;
      }
      /*cout << "Startside: " << startside << endl;
      cout << "Endside: " << endside << endl;
      cout << "Den: " << denominator << endl;
      cout << "X: " << x << endl;*/
      if (x < -1e-4)
         cout << "A big WTF to that....................\n";
      //intpoint.print();
   }
#endif
   if (CrossesPlane(pos, pos1, norm, d, denominator, move, x, intpoint))
   {
      // The following line has to be here because CrossesPlane does not have access to
      // radius, nor should it IMHO
      if (x > move.magnitude() + radius || x < -radius) return Vector3();
      // Determine whether we're on the poly
      float angle = 0.f;
      bool forcehit = false;
      
      for (int i = 0; i < 3; ++i)
      {
         // When intpoint == v[i], we have problems because the dot product below ends up zero, which is wrong
         if (intpoint.distance2(v[i]) < .000001)
         {
            forcehit = true;
            break;
         }
         Vector3 p = intpoint - v[i];
         Vector3 p1 = intpoint - v[(i + 1) % 3];
         p.normalize();
         p1.normalize();
         angle += acos(p.dot(p1));
      }
      
      if (forcehit || (angle > 2 * PI - .05 && angle < 2 * PI + .05))
      {
         float endside = norm.dot(pos1) + d;
         adjust = norm * -endside;// * 1.01f;
         return adjust;
      }
   }
   return Vector3();
}


Vector3 CollisionDetection::PlaneEdgeSphereCollision(const Vector3vec& v, const Vector3& pos, const float& radius)
{
   Vector3 adjust, tempadj;
   int numhits = 0;
   for (int i = 0; i < 3; i++)
   {
      Vector3 ray, raystart, rayend;
      raystart = v[i];
      rayend = v[(i + 1) % 3];
      if (RaySphereCheck(raystart, rayend, pos, radius, tempadj))
      {
         adjust += tempadj;
         ++numhits;
      }
   }
   if (numhits)
      adjust /= numhits;
   return adjust;
}


// Finds the point of nearest approach of the vectors describing the movement and the edge
// of the triangle.  If this point falls on the edge of the polygon and the minimum distance
// between the two vectors is less than radius then we hit
Vector3 CollisionDetection::VectorEdgeCheck(const Vector3vec& v, const Vector3& start, const Vector3& end, const float& radius)
{
   Vector3 adjust;
   Vector3 n;
   Vector3 move = end - start;
   float j, k;
   
   for (int i = 0; i < 3; ++i)
   {
      Vector3 ray, raystart, rayend;
      raystart = v[i];
      rayend = v[(i + 1) % 3];
      ray = rayend - raystart;
      
      float dist = DistanceBetweenLines(start, move, raystart, ray, j, k);
      Vector3 ts = raystart - start;
      if (dist < radius)
      {
         if (j < -1e-5 || k < -1e-5 || j > 1 || k > 1) // No hit
            continue;
         return Vector3(1, 1, 1);
      }
   }
   return Vector3();
}


bool CollisionDetection::InVector(Mesh* ptr, vector<Meshlist::iterator>& vec)
{
   for (int i = 0; i < vec.size(); ++i)
      if (&(*vec[i]) == ptr) return true;
   return false;
}


// I don't think this one is ever used because in most cases we want to reuse d, so it doesn't make sense to 
// calculate it each time
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const Vector3& polypoint, float &denominator, Vector3& move)
{
   float d = -norm.dot(polypoint);
   
   return CrossesPlane(start, end, norm, d, denominator, move);
}


// Also calculates the intersection point if we're interested.  
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const float& d, float &denominator, Vector3& move, float& x, Vector3& intpoint)
{
   if (CrossesPlane(start, end, norm, d, denominator, move))
   {
      x = -(norm.dot(start) + d) / denominator;
      intpoint = start + move * x;
      return true;
   }
   return false;
}


// NOTE: This does not actually take the location of start into consideration, so if start is not
// on the positive side of the plane then it may return true when the plane was not actually crossed.
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const float& d, float &denominator, Vector3& move)
{
   
   float endside = norm.dot(end) + d;
   
   /* Because if the signs are the same, this will end up positive
      At times, when one of these variables should be zero, it will
      actually be a very small number (7E-6 for instance) of the
      opposite sign from the other variable, which means if we just
      check the signs it appears we hit when we didn't.  Including
      values very close to 0 as non-hits fixes this.
   
      Err, cancel the above.
   
      Okay, from now on we have to assume that startside is positive.
      Multiplying them together when they could both be extremely small
      was resulting in numbers so close to 0 that we couldn't accurately
      distinguish them, so from now on this function requires that start
      be on the positive side of the plane.
   */
   if (endside < .00001)
   {
      move = end - start;
      denominator = norm.dot(move);
      if (denominator != 0)
      {
         return true;
      }
   }
   return false;
}


// From http://geometryalgorithms.com/Archive/algorithm_0106/algorithm_0106.htm
float CollisionDetection::DistanceBetweenLines(const Vector3& start, const Vector3& dir, const Vector3& start1, const Vector3& dir1,
                                              float& j, float& k)
{
   Vector3 st = start - start1;
   float a = dir.dot(dir);
   float b = dir.dot(dir1);
   float c = dir1.dot(dir1);
   float d = dir.dot(st);
   float e = dir1.dot(st);
   float acb2 = a * c - b * b;
   if (!floatzero(acb2))
   {
      j = (e * b - d * c) / acb2;
      k = (e * a - d * b) / acb2;
   }
   else // Parallel
   {
      j = 0;
      k = b > c ? d / b : e / c;
   }
   Vector3 p, p1;
   p = start + dir * j;
   p1 = start1 + dir1 * k;
   return p.distance(p1);
}


bool CollisionDetection::RaySphereCheck(const Vector3& raystart, const Vector3& rayend,
                                        const Vector3& spherepos, const float radius, Vector3& adjust)
{
   Vector3 ray = rayend - raystart;
   ray.normalize();
   float maxt = raystart.distance(rayend);
   //float a = 1; // Just a reminder
   float b = 2 * ray.dot(raystart - spherepos);
   float c = (raystart - spherepos).dot(raystart - spherepos) - radius * radius;
      
   if ((b * b - 4 * c) > 0)
   {
      float t = (-b + sqrt(b * b - 4 * c)) * .5;
      float t1 = (-b - sqrt(b * b - 4 * c)) * .5;
      Vector3 intercept, intercept1;
      intercept = raystart + ray * t;
      intercept1 = raystart + ray * t1;
      if ((t < maxt && t > 0) ||
           (t1 < maxt && t1 > 0))
      {
         adjust = spherepos - (intercept + intercept1) / 2;
         if (t1 < 0)
            adjust = spherepos - raystart;
         else if (t > maxt)
            adjust = spherepos - rayend;
         float dist = adjust.magnitude();
         if (dist > radius - .001)  // For rounding error
            dist = radius - .001;
         adjust.normalize();
         adjust *= radius - dist;
         return true;
      }
   }
   return false;
}


bool CollisionDetection::UnitTest()
{
   Vector3 s1(1, 0, 1);
   Vector3 s2(0, 0, 3);
   Vector3 d1(0, 1, 1);
   Vector3 d2(1, 0, 0);
   float j, k;
   Vector3vec v3(3);
   v3[0] = Vector3(0, 0, 0);
   v3[1] = Vector3(1, 0, 0);
   v3[2] = Vector3(0, 0, 1);
   cout << "Distance: " << DistanceBetweenLines(s1, d1, s2, d2, j, k) << endl;
   cout << j << "  " << k << endl;
   VectorEdgeCheck(v3, s1, d1, .5);
}


