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


#include "CollisionDetection.h"
#include "util.h"

#define PI 3.14159265
//#define VERBOSE 1

// *******************************************************************
// Here be dragons
//
// Meddle not in the affairs of collision detection, for it is subtle
// and quick to break
// *******************************************************************

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


Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& objs, const bool extcheck,
                                           bool* exthit, const bool debug)
{
   Vector3 dummy;
   Mesh* dummymesh;
   return CheckSphereHit(oldpos, newpos, radius, objs, dummy, dummymesh, NULL, extcheck, exthit, debug);
}


/* Make sure that the movement from oldpos to newpos by the sphere
   of size radius is allowed, and if not return a vector that will
   adjust the position so it is closer to valid (it won't necessarily
   make it valid)

   If you don't care about finding out what objects (if any) were hit, pass in
   NULL for retobjs, otherwise pass in the appropriate pointer*/
Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, vector<Mesh*>& allobjs,
                                           Vector3& hitpos, Mesh*& hitobj, vector<Mesh*>* retobjs, const bool extcheck, bool* exthit, const bool debug)
{
   Vector3 adjust;
   Vector3 temp, temphitpos;
   Vector3 midpoint = (oldpos + newpos) / 2.f;
   Vector3 move = newpos - oldpos;
   bool nomove = false;
   if (move.magnitude() < 1e-5f)
      nomove = true;
   float movemaginv;
   int adjusted = 0;
   // 1e38 is near the maximum representable value for a single precision float
   hitpos = Vector3(1e38f, 1e38f, 1e38f);
   vector<Mesh*> objs;
   
   bool dummyexthit;
   if (!exthit)
      exthit = &dummyexthit;
   *exthit = false;
   
   //float cullrad = midpoint.distance(oldpos);
   
   if (!nomove)
   {
      movemaginv = 1.f / newpos.distance(oldpos);
      for (size_t i = 0; i < allobjs.size(); ++i)
      {
         Mesh& currmesh = *allobjs[i];
         Vector3 currpos = currmesh.GetPosition();
         if (DistanceBetweenPointAndLine(currpos, oldpos, move, movemaginv) <= currmesh.GetSize() + radius)
         {
            /*float currwidth = currmesh.GetWidth();
            if (midpoint.x + cullrad > currpos.x - currwidth &&
               midpoint.x - cullrad < currpos.x + currwidth &&
               midpoint.z + cullrad > currpos.z - currwidth &&
               midpoint.z - cullrad < currpos.z + currwidth)*/
               objs.push_back(allobjs[i]);
         }
      }
   }
   else
   {
      movemaginv = 0.f;
      for (size_t i = 0; i < allobjs.size(); ++i)
      {
         Mesh& currmesh = *allobjs[i];
         Vector3 currpos = currmesh.GetPosition();
         if (currpos.distance(oldpos) <= currmesh.GetSize() + radius)
         {
            /*float currwidth = currmesh.GetWidth();
            if (midpoint.x + cullrad > currpos.x - currwidth &&
               midpoint.x - cullrad < currpos.x + currwidth &&
               midpoint.z + cullrad > currpos.z - currwidth &&
               midpoint.z - cullrad < currpos.z + currwidth)*/
               objs.push_back(allobjs[i]);
         }
      }
   }
   
   size_t osize = objs.size();
   vector<Triangle*> neartris;
   neartris.reserve(osize * 200);
   map<Triangle*, Mesh*> trimap;
   Triangle* hittri = NULL;
//    logout << "Checking " << objs.size() << endl;
//    logout << "Radius " << radius << endl;
//    logout << "Dist " << oldpos.distance(newpos) << endl;
   
   bool hit;
   for (size_t i = 0; i < osize; i++)
   {
      Mesh* current = objs[i];
      current->Begin();
      while (current->HasNext())
      {
         Triangle& currtri = current->Next();
         if (currtri.collide)
         {
            if (currtri.maxdim < 0) currtri.CalcMaxDim();
            
            float checkrad = currtri.maxdim + radius;
            
            if ((!nomove && DistanceBetweenPointAndLine(currtri.midpoint, oldpos, move, movemaginv) < checkrad) ||
                  oldpos.distance(currtri.midpoint) < checkrad)
            {
               // Cache the results of the previous calculations for later use
               neartris.push_back(&currtri);
               trimap.insert(make_pair(&currtri, current));
               
               hit = false;
               hit = PlaneSphereCollision(temp, currtri, oldpos, newpos, radius + currtri.radmod, temphitpos, nomove);
               
               if (hit)
               {
                  adjust += temp;
                  if (oldpos.distance2(temphitpos) < oldpos.distance2(hitpos))
                  {
                     hittri = &currtri;
                     hitpos = temphitpos;
                  }
                  adjusted++;
                  if (retobjs)
                     retobjs->push_back(current);
               }
            }
         }
      }
   }
   
   size_t ntsize = neartris.size();
   
   // Check edges of polys as well.
   if (!adjusted)
   {
      if (nomove)
      {
         for (size_t i = 0; i < ntsize; i++)
         {
            Triangle& currtri = *neartris[i];
            hit = false;
            hit = PlaneEdgeSphereCollision(temp, currtri, newpos, radius + currtri.radmod);
            if (hit)
            {
               adjust += temp;
               hittri = &currtri;
               hitpos = newpos;
               adjusted++;
               if (retobjs)
                  retobjs->push_back(trimap[&currtri]);
            }
         }
      }
      else
      {
         // TODO: Parts of this comment are out of date
         // Do another edge check that checks the entire movement path, not just the ending position.
         // This is necessary because projectiles may move significantly larger distances than their
         // radius which can make the previous check fail incorrectly.  This is no longer a problem
         // for on-poly checks because they also check the entire movement path, but the first edge
         // check does not.  We keep it because this check can miss certain collisions (specifically
         // if a movement is close to parallel to the edge so the nearest point of the two vectors
         // falls outside the edge vector, but we still actually touch the edge) which is acceptable
         // for projectiles because the corner test will catch them, but could be a problem for player
         // movement.  Whew.
         Vector3 raystart, rayend;
         bool localhit;
         Vector3 localhitpos, localadjust;
         float currhitdist;
         for (size_t i = 0; i < ntsize; i++)
         {
            Triangle& currtri = *neartris[i];
            hit = false;
            localhit = false;
            localhitpos = Vector3();
            localadjust = Vector3();
            currhitdist = 1e38f;
            for (size_t j = 0; j < 3; ++j)
            {
               raystart = currtri.v[j]->pos;
               rayend = currtri.v[(j + 1) % 3]->pos;
               hit = RayCylinderCheck(oldpos, newpos, raystart, rayend, radius + currtri.radmod, temp, temphitpos);
               if (hit)
               {
                  localhit = true;
                  if (oldpos.distance2(temphitpos) < currhitdist)
                  {
                     localadjust = temp;
                     localhitpos = temphitpos;
                     currhitdist = oldpos.distance2(temphitpos);
                  }
                  *exthit = true;
               }
            }
            if (localhit)
            {
               ++adjusted;
               adjust += localadjust;
               if (oldpos.distance2(localhitpos) < oldpos.distance2(hitpos))
               {
                  hittri = &currtri;
                  hitpos = localhitpos;
               }
               if (retobjs)
                  retobjs->push_back(trimap[&currtri]);
            }
         }
         
         // Do a ray-sphere check on each corner of the triangles.  This is to handle
         // the aforementioned case when we're moving nearly parallel to the edge.
         if (!adjusted)
         {
            for (size_t i = 0; i < ntsize; i++)
            {
               Triangle& currtri = *neartris[i];
               for (int j = 0; j < 3; ++j)
               {
                  if (RaySphereCheck(oldpos, newpos, currtri.v[j]->pos, radius + currtri.radmod, temp, true))
                  {
                     if (oldpos.distance2(hitpos) > oldpos.distance2(currtri.v[j]->pos))
                     {
                        hittri = &currtri;
                        hitpos = currtri.v[j]->pos;
                     }
                     adjust += temp;
                     adjusted++;
                     *exthit = true;
                     if (retobjs)
                        retobjs->push_back(trimap[&currtri]);
                     break; // One hit per tri should be enough
                  }
               }
            }
         }
      }
   }// !adjusted
   
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
         // Note that this is most likely bogus for fast moving things, but since it looks fine (better even)
         // to have weapon tracers disappear off into the distance rather than explode against the bounding
         // box, that's okay.
         if (oldpos.distance2(newpos) < oldpos.distance2(hitpos))
            hitpos = newpos;
         float endside = norm.dot(newpos) + d;
         adjust += norm * -endside;
         adjusted++;
      }
   }
   
   if (hittri)
      hitobj = trimap[hittri];
   
   // Currently this is a problem because the only way to determine whether a hit was detected is to
   // check the magnitude of the returned vector - this should be changed so this function returns a
   // bool as all of the internal functions do now, but that will require changes in everything that
   // calls us so I'm not willing to deal with it right now.
   if (adjusted && adjust.magnitude() < 1e-4f)
   {
      /*logout << "Warning: adjusting too small amount " << adjusted << endl;
      adjust.print();*/
      adjust.normalize();
      adjust *= 2e-4f;
      if (adjust.magnitude() < 1e-4f) // Can happen if adjust is the zero vector
         adjust = Vector3(2e-4f, 2e-4f, 2e-4f);
   }
   if (adjusted <= 1)
      return adjust;
   return adjust / (float)adjusted;
}


// May want to precalculate normals where we can to speed things up

/* If nomove is true (which should imply that pos == pos1), then this will just check if the sphere intersects
   the triangle, regardless of the side its on.  This is necessary because if pos isn't moving we can't possibly
   hit using the other detection method, but in some cases (say calculating damage radius for splash damage) we
   need to be able to hit while not moving.
*/
bool CollisionDetection::PlaneSphereCollision(Vector3& retval, const Triangle& t, Vector3 pos, const Vector3& pos1,
      const float& radius, Vector3& hitpos, bool nomove, bool debug)
{
   Vector3vec v(3);
   for (int i = 0; i < 3; ++i)
      v[i] = t.v[i]->pos;
   Vector3 adjust;
   Vector3 norm = (v[1] - v[0]).cross(v[2] - v[0]);
   norm.normalize();
   Vector3 endpos = pos1;
   
   if (!nomove)
   {
      for (int i = 0; i < 3; ++i)
         v[i] += norm * radius;
   }
   
   float d = -norm.dot(v[0]);
   
   float startside = norm.dot(pos) + d;
   if (startside < -1e-2f)
   {
      return false;
   }
   else if (nomove)
      endpos -= norm * radius;
   
   float denominator;
   Vector3 move;
   float x = -1.f;
   Vector3 intpoint;
   
#ifdef VERBOSE
   logout << "Starting check..........................\n";
#endif
   if (CrossesPlane(pos, endpos, norm, d, denominator, move, x, intpoint))
   {
      // Determine whether we're on the tri
      float angle = 0.f;
      bool forcehit = false;
      
      for (int i = 0; i < 3; ++i)
      {
         // When intpoint == v[i], we have problems because the dot product below ends up zero, which is wrong
         if (intpoint.distance(v[i]) < 1e-4f)
         {
            forcehit = true;
            break;
         }
         Vector3 p = intpoint - v[i];
         Vector3 p1 = intpoint - v[(i + 1) % 3];
         p.normalize();
         p1.normalize();
#ifdef VERBOSE
         logout << "acos " << acos(p.dot(p1)) << endl;
#endif
         angle += acos(p.dot(p1));
      }
      
      if (forcehit || (angle > 2.f * PI - .01f && angle < 2.f * PI + .01f) || isnan(angle))
      {
         float endside = norm.dot(endpos) + d;
         if (endside > -2e-4f)
            endside = -2e-4f;
         adjust = norm * -endside;
         hitpos = intpoint;
         retval = adjust;
         return true;
      }
#ifdef VERBOSE
      logout << "intpoint not on tri " << angle << endl;
#endif
   }
#ifdef VERBOSE
   logout << "Ending check\n";
   float endside = norm.dot(endpos) + d;
   if (endside > -1e-2f && endside < 1e-5f && !nomove)
   {
      logout << "******************************** " << endside << endl;
      logout << "startside " << startside << endl;
      logout << "d " << d << endl;
      logout << "pos ";
      pos.print();
      logout << "endpos ";
      endpos.print();
      logout << endl;
   }
#endif
   return false;
}


#ifdef INLINE_COLDET
inline
#endif
bool CollisionDetection::PlaneEdgeSphereCollision(Vector3& retval, const Triangle& t, const Vector3& pos, const float& radius)
{
   Vector3vec v(3);
   for (int i = 0; i < 3; ++i)
      v[i] = t.v[i]->pos;
   Vector3 adjust, tempadj;
   int numhits = 0;
   for (int i = 0; i < 3; i++)
   {
      Vector3 raystart, rayend;
      raystart = v[i];
      rayend = v[(i + 1) % 3];
      if (RaySphereCheck(raystart, rayend, pos, radius, tempadj, false))
      {
         adjust += tempadj;
         ++numhits;
      }
   }
   if (numhits)
   {
      retval = adjust / numhits;
      return true;
   }
   return false;
}


// Finds the point of nearest approach of the vectors describing the movement and the edge
// of the triangle.  If this point falls on the edge of the polygon and the minimum distance
// between the two vectors is less than radius then we hit
bool CollisionDetection::VectorEdgeCheck(Vector3& retval, Vector3& hitpos, const Triangle& t, const Vector3& start, const Vector3& end, const float& radius)
{
   Vector3vec v(3);
   for (int i = 0; i < 3; ++i)
      v[i] = t.v[i]->pos;
   Vector3 adjust;
   Vector3 move = end - start;
   float j, k;
   
   for (int i = 0; i < 3; ++i)
   {
      Vector3 ray, raystart, rayend;
      raystart = v[i];
      rayend = v[(i + 1) % 3];
      ray = rayend - raystart;
      
      float dist = DistanceBetweenLines(start, move, raystart, ray, j, k);
      if (dist < radius)
      {
         if (j < 1e-5 || k < 1e-5 || j > .99999 || k > .99999) // No hit
            continue;
         hitpos = start + move * j;
         Vector3 other = raystart + ray * k;
         retval = hitpos - other;
         float retmag = radius - retval.magnitude();
         retval.normalize();
         retval *= retmag;
         return true;
      }
   }
   return false;
}

#ifdef INLINE_COLDET
inline
#endif
bool CollisionDetection::InVector(Mesh* ptr, vector<Meshlist::iterator>& vec)
{
   for (size_t i = 0; i < vec.size(); ++i)
      if (&(*vec[i]) == ptr) return true;
   return false;
}


// I don't think this one is ever used because in most cases we want to reuse d, so it doesn't make sense to 
// calculate it each time
#ifdef INLINE_COLDET
inline
#endif
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const Vector3& polypoint, float &denominator, Vector3& move)
{
   float d = -norm.dot(polypoint);
   
   return CrossesPlane(start, end, norm, d, denominator, move);
}


// Also calculates the intersection point if we're interested.
#ifdef INLINE_COLDET
inline
#endif
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const float& d, float &denominator, Vector3& move, float& x, Vector3& intpoint)
{
   if (CrossesPlane(start, end, norm, d, denominator, move))
   {
      x = -(norm.dot(start) + d) / denominator;
      intpoint = start + move * x;
      // Although this check is technically part of the algorithm, if we crossed the plane, then we know
      // that the intersection point is on the ray, and this check can cause problems when one of the
      // end points is very near to co-planar.
      //if (x < 1.0002f && x > -2e-4f)
         return true;
      //if (x < 0)
#ifdef VERBOSE
         logout << "intpoint not on line " << x << endl;
#endif
   }
   return false;
}


// NOTE: This does not actually take the location of start into consideration, so if start is not
// on the positive side of the plane then it may return true when the plane was not actually crossed.
#ifdef INLINE_COLDET
inline
#endif
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm,
                                      const float& d, float &denominator, Vector3& move)
{
   
   float endside = norm.dot(end) + d;
   
   if (endside < 1e-4f)
   {
      move = end - start;
      denominator = norm.dot(move);
      if (!floatzero(denominator))
      {
         return true;
      }
#ifdef VERBOSE
      logout << "denominator is 0" << endl;
#endif
   }
#ifdef VERBOSE
   logout << "endside > 0    " << endside << endl;
   logout << "d " << d << endl;
   logout << "norm ";
   norm.print();
   logout << "end ";
   end.print();
#endif
   return false;
}


// From http://geometryalgorithms.com/Archive/algorithm_0106/algorithm_0106.htm
#ifdef INLINE_COLDET
inline
#endif
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
                                        const Vector3& spherepos, const float radius, Vector3& adjust, const bool extadj)
{
   Vector3 ray = rayend - raystart;
   ray.normalize();
   float maxt = raystart.distance(rayend);
   //float a = 1; // Just a reminder
   float b = 2.f * ray.dot(raystart - spherepos);
   float c = (raystart - spherepos).dot(raystart - spherepos) - radius * radius;
   float b24ac = b * b - 4.f * c;
   float cushion = 0;//-.0001f;
      
   if (b24ac > 1e-4f)
   {
      float t = (-b + sqrt(b24ac)) * .5;
      float t1 = (-b - sqrt(b24ac)) * .5;
      Vector3 intercept, intercept1;
      intercept = raystart + ray * t;
      intercept1 = raystart + ray * t1;
      if ((t < maxt && t > cushion) ||
         (t1 < maxt && t1 > cushion))
      {
         if (!extadj)
         {
            adjust = spherepos - (intercept + intercept1) * .5f;
            if (t < cushion || t1 < cushion)
               adjust = spherepos - raystart;
            else if (t > maxt || t1 > maxt)
               adjust = spherepos - rayend;
            float dist = adjust.magnitude();
            adjust.normalize();
            adjust *= radius - dist;
         }
         else
         {
            // If we started out inside the sphere then consider that a non-hit
            // This can happen if we start a move very close to a sphere
            if (t < cushion || t1 < cushion)
               return false;
            Vector3 nearint, farint;
            if (t < t1)
            {
               nearint = intercept;
               farint = intercept1;
            }
            else
            {
               nearint = intercept1;
               farint = intercept;
            }
            Vector3 perp;
            Vector3 half = (nearint + farint) / 2.f;
            if (half.distance2(raystart) <= rayend.distance2(raystart))
               perp = (nearint + half) / 2.f;
            else
               perp = (nearint + rayend) / 2.f;
            perp -= spherepos;
            perp.normalize();
            perp *= radius * 1.005f;
            adjust = (spherepos + perp) - rayend;
         }
         return true;
      }
   }
   // Handles the case for when the poly is completely contained in the circle
   // This is nonsensical for extadj so we don't handle that case (it's considered a miss)
   if (!extadj && (raystart.distance(spherepos) < radius && rayend.distance(spherepos) < radius))
   {
      adjust = spherepos - (raystart + rayend) / 2.f;
      return true;
   }
   return false;
}


// Thanks to oliii at http://www.gamedev.net/community/forums/topic.asp?topic_id=173865 for this algorithm
bool CollisionDetection::RayCylinderCheck(const Vector3& raystart, const Vector3& rayend,
                                          const Vector3& cylstart, const Vector3& cylend, const float radius,
                                          Vector3& adjust, Vector3& hitpos)
{
   Vector3 cylray = cylend - cylstart;
   Vector3 normcylray = cylray;
   normcylray.normalize();
   
   Vector3 ray = rayend - raystart;
   float maxt = ray.magnitude();
   ray.normalize();
   
   // I think I want to be using normcylray here, although it's not explicitly mentioned in the reference
   // If not it shouldn't hurt to use it
   Vector3 rxc = ray.cross(normcylray);
   Vector3 rsmcs = raystart - cylstart;
   Vector3 rcxc = rsmcs.cross(normcylray);
   float a = rxc.dot(rxc);
   float b = 2.f * rcxc.dot(rxc);
   float c = rcxc.dot(rcxc) - radius * radius;
   
   float b24ac = b * b - 4.f * a * c;
   float cushion = 0;//-.0001f;
   
   if (b24ac >= 1e-4f)
   {
      float a2inv = 1.f / (2.f * a);
      float t = (-b + sqrt(b24ac)) * a2inv;
      float t1 = (-b - sqrt(b24ac)) * a2inv;
      
      // If we started out inside the cylinder then consider that a non-hit
      // This can happen if we start a move very close to a cylinder
      if ((t < cushion && t1 > cushion) || (t > cushion && t1 < cushion))
         return false;
      
      if ((t > cushion && t < maxt) ||
          (t1 > cushion && t1 < maxt))
      {
         Vector3 intercept;
         if (t < cushion)
            intercept = raystart + ray * t1;
         else if (t1 < cushion)
            intercept = raystart + ray * t;
         else if (t < t1)
            intercept = raystart + ray * t;
         else
            intercept = raystart + ray * t1;
         
         float intproj = (intercept - cylstart).dot(normcylray);
         if (intproj < 0 || (intproj > cylray.magnitude()))
            return false;
         
         /*logout << "Hit..................................\n";
         logout << t1 << "  " << t << "  " << maxt << "  " << radius << endl;
         logout << "intercept ";
         intercept.print();
         logout << "raystart ";
         raystart.print();
         logout << "ray ";
         ray.print();*/
         // Now we know the hit was on both the cylinder and the ray
         hitpos = intercept;
         Vector3 intoncyl = cylstart + normcylray * intproj;
         Vector3 perp = intercept - intoncyl;
         
         float endproj = (rayend - cylstart).dot(normcylray);
         Vector3 endoncyl = cylstart + endproj * normcylray;
         
         Vector3 maxadj = ray.cross(cylray);
         maxadj.normalize();
         maxadj *= radius;
         Vector3 maxadj1 = -maxadj;
         if (maxadj.distance2(perp) > maxadj1.distance2(perp))
            maxadj = maxadj1;
         
         float interpval;
         float half = (t + t1) * .5f;
         Vector3 maxadjpoint = raystart + ray * half;
         
         float maxadjdist = DistanceBetweenPointAndLine(maxadjpoint, cylstart, cylray, 1.f / cylray.magnitude());
         maxadj.normalize();
         maxadj *= maxadjdist;
         if (t < t1 && t > cushion)
            interpval = smoothstep(t, half, maxt);
         else
            interpval = smoothstep(t1, half, maxt);
         perp = lerp(maxadj, perp, interpval);
         perp.normalize();
         perp *= radius * 1.005f;
         
         //endoncyl = intoncyl + perp; // or endoncyl + perp - tbd which is better
         endoncyl = endoncyl + perp; // This is almost certainly better
         
         adjust = endoncyl - rayend;
         return true;
      }
   }
   return false;
}

#ifndef INLINE_COLDET
float CollisionDetection::DistanceBetweenPointAndLine(const Vector3& point, const Vector3& start, const Vector3& move, const float movemaginv)
{
   // This check is not required for any code that calls us and it helps performance significantly if we don't do it
   //if (movemag < 1e-5f) return 0.f;
   return(move.cross(start - point).magnitude() * movemaginv);
}
#endif


// Someday I'm going to get around to writing some actual unit tests for this function rather than just using it as a sandbox
// to test various parts of the class.  But not today.:-)
bool CollisionDetection::UnitTest()
{
   Vector3 a(0, 0, 2);
   Vector3 b(0, 1, 1.5);
   Vector3 anorm = a;
   anorm.normalize();
   float proj = b.dot(anorm);
   cout << proj;
   
   return true;
}


