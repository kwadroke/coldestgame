#include "CollisionDetection.h"
#include "globals.h" // for floatzero

#define PI 3.14159265


CollisionDetection::CollisionDetection() : worldbounds(6, Quad())
{
   intmethod = 0;
   quiet = true;
}


CollisionDetection& CollisionDetection::operator=(const CollisionDetection& o)
{
   intmethod = o.intmethod;
   quiet = o.quiet;
   tilesize = o.tilesize;
   worldbounds = o.worldbounds;
}


Vector3 CollisionDetection::CheckSphereHitDebug(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& objs,
                                           stack<Mesh*>* retobjs)
{
   Vector3 retval = CheckSphereHit(oldpos, newpos, radius, objs, retobjs, true);
   return retval;
}


/* Make sure that the movement from oldpos to newpos by the sphere
   of size radius is allowed, and if not return a vector that will
   adjust the position so it is closer to valid

   If you don't care about finding out what objects (if any) were hit, pass in
   NULL for retobjs, otherwise pass in the appropriate pointer*/
Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& objs,
                                           stack<Mesh*>* retobjs, bool debug)
{
   Vector3 adjust;
   Vector3 temp;
   Vector3 dist;
   int adjusted = 0;
   
#if 0
   // Leaving this here for now because we'll need to copy pieces of it elsewhere
   if (!listvalid)
   {
      Vector3 midpoint = (oldpos + newpos) / 2.f;
      float findrad = radius + oldpos.distance(newpos);
      
      p = kdtree->getmeshes(midpoint, findrad);
      
      // Eliminate objects in the ignore list
      for (vector<Mesh*>::iterator i = p.begin(); i != p.end(); ++i)
      {
         if (InVector(*i, ignoreobjs))
            p.erase(i);
      }
      
      //cout << p.size() << endl;
   }
#endif
   
   Mesh* current;
   for (int i = 0; i < objs.size(); i++)
   {
      current = objs[i];
      current->Begin();
      while (current->HasNext())
      {
         const Triangle& currtri = current->Next();
         if (currtri.collide)
         {
            //dist = currtri.vert[0] + currtri.vert[1] + currtri.vert[2];
            //dist /= 3;
            //if (dist.distance2(newpos) < 
            //      currtri.vert[0].distance2(currtri.vert[3]) + radius * radius)
            {
               temp = adjust;
               adjust += PlaneSphereCollision(currtri.vert, oldpos, newpos, radius);
               if (adjust.distance2(temp) > .00001)
               {
                  adjusted++;
                  if (retobjs)
                     retobjs->push(current);
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
            const Triangle& currtri = current->Next();
            if (currtri.collide)
            {
               //dist = currtri.vert[0] + currtri.vert[1] + currtri.vert[2];
               //dist /= 3;
               //if (dist.distance2(newpos) < 
               //      currtri.vert[0].distance2(currtri.vert[3]) + radius * radius)
               {
                  temp = adjust;
                  adjust += PlaneEdgeSphereCollision(currtri.vert, newpos, radius);
                  if (adjust.distance2(temp) > .00001)
                  {
                     adjusted++;
                     if (retobjs)
                        retobjs->push(current);
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


// Essentially does a ray-sphere collision test on each edge of the triangle specified by v
Vector3 CollisionDetection::PlaneEdgeSphereCollision(Vector3vec v, const Vector3& pos, const float& radius)
{
   Vector3 adjust;
   int numhits = 0;
   for (int i = 0; i < 3; i++)
   {
      Vector3 ray, raystart, rayend;
      raystart = v[i];
      rayend = v[(i + 1) % 3];
      ray = rayend - raystart;
      ray.normalize();
      float maxt = raystart.distance(rayend);
      //float a = 1; // Just a reminder
      float b = 2 * ray.dot(raystart - pos);
      float c = (raystart - pos).dot(raystart - pos) - radius * radius;
      
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
            Vector3 adj = pos - (intercept + intercept1) / 2;
            if (t1 < 0)
               adj = pos - v[i];
            else if (t > maxt)
               adj = pos - v[(i + 1) % 3];
            float dist = adj.distance(Vector3());
            if (dist > radius - .001)  // For rounding error
               dist = radius - .001;
            adj.normalize();
            adj *= radius - dist;
            adjust += adj;
            //return adjust;
            ++numhits;
         }
      }
   }
   if (numhits)
      adjust /= numhits;
   return adjust;
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


