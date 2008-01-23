#include "CollisionDetection.h"

#define PI 3.14159265


CollisionDetection::CollisionDetection()
{
   //octree = NULL;
   //dynobj = NULL;
   intmethod = 0;
   listvalid = false;
   quiet = true;
   for (int i = 0; i < 6; ++i)
      worldbounds.push_back(WorldPrimitives(false));
}


CollisionDetection& CollisionDetection::operator=(const CollisionDetection& o)
{
   intmethod = o.intmethod;
   listvalid = o.listvalid;
   quiet = o.quiet;
   tilesize = o.tilesize;
   kdtree = o.kdtree;
   worldbounds = o.worldbounds;
   //for (int i = 0; i < 6; ++i)
   //   worldbounds.push_back(o.worldbounds[i]);
}


Vector3 CollisionDetection::CheckSphereHitDebug(const Vector3& oldpos, const Vector3& newpos, const float& radius, list<DynamicObject>* dynobj,
                                           vector<list<DynamicObject>::iterator>& ignoreobjs,
                                           stack<list<DynamicObject>::iterator>* retobjs)
{
   cout << "Detecting " << radius << endl;
   Vector3 retval = CheckSphereHit(oldpos, newpos, radius, dynobj, ignoreobjs, retobjs, false);
   if (oldpos.y > -100)
   {
      oldpos.print();
      newpos.print();
      retval.print();
   }
   return retval;
}


Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, list<DynamicObject>* dynobj,
                                           stack<list<DynamicObject>::iterator>* retobjs)
{
   vector<list<DynamicObject>::iterator> dummy;
   return CheckSphereHit(oldpos, newpos, radius, dynobj, dummy, retobjs);
}


/* Make sure that the movement from oldpos to newpos by the sphere
   of size radius is allowed, and if not return a vector that will
   adjust the position so it is closer to valid

   If you don't care about finding out what objects (if any) were hit, pass in
   NULL for retobjs, otherwise pass in the appropriate pointer*/
Vector3 CollisionDetection::CheckSphereHit(const Vector3& oldpos, const Vector3& newpos, const float& radius, list<DynamicObject>* dynobj,
                                           vector<list<DynamicObject>::iterator>& ignoreobjs,
                                           stack<list<DynamicObject>::iterator>* retobjs, bool debug)
{
   Vector3 adjust;
   Vector3 temp;
   Vector3 dist;  // Used to eliminate prims from detection
   int adjusted = 0;
   
   // Get both world primitives and dynamic primitives that need to be checked
   if (!listvalid)
   {
      //p = octree->getprims(newpos, radius);
      p = kdtree->getprims(newpos, radius);
      //cout << "Objects to collision detect " << p.size() << endl;
   
      list<DynamicObject>::iterator i;
      vector<DynamicPrimitive> dyntemp; // Hold actual dummy objects so we can point to them.
      DynamicPrimitive dummy;
      for (i = dynobj->begin(); i != dynobj->end(); i++)
      {
         if (!InVector(i, ignoreobjs))//ignoreobjs.find(i) == ignoreobjs.end())
         {
            list<DynamicPrimitive*>::iterator j;
            float temp1 = i->size;
            int temp2 = i->animframe;
            GLuint temp3 = i->prims.size();
            DynamicObject* iptr = &(*i);
            for (j = i->prims[i->animframe].begin(); j != i->prims[i->animframe].end(); j++)
            {
               DynamicPrimitive *jptr = *j;
               if (jptr->collide)
               {
                  /*if (jptr->type == "tristrip")
                  {
                     for (int k = 0; k < 4; ++k)
                        dummy.v[k] = jptr->point[k];
                     dummy.collide = true;
                     dummy.type = "tristrip";
                     dummy.rad = -1;
                     p.push_back(dummy);
                  }*/
                  if (jptr->type == "cylinder")
                  {
                     dummy.collide = true;
                     dummy.type = "tristrip";
                     dummy.rad = jptr->rad;
                     dummy.rad1 = jptr->rad1;
                     dummy.parentobj = jptr->parentobj;
                     dummy.dynamic = jptr->dynamic;
                     for (int k = 0; k < 4; ++k)
                        dummy.v[k] = (jptr->v[k]);
                     dyntemp.push_back(dummy);
                  }
                  else p.push_back(*j);
               }
            }
         }
      }
      
      for (vector<DynamicPrimitive>::iterator j = dyntemp.begin(); j != dyntemp.end(); ++j)
      {
         p.push_back(&(*j));
      }
   }

   if (!quiet)
      cout << "Primitives to collision detect: " << p.size() << endl;
   
   int psize = p.size();
   
   GenericPrimitive *current;
   for (int i = 0; i < psize; i++)
   {
      current = p[i];
      if (current->collide)  // Can't hit it?  Don't check.
      {
         if (current->type == "terrain")
         {
            // Is the tile nearby?
            dist = current->v[0];
            if (newpos.x > dist.x - radius &&
                newpos.x < dist.x + radius + tilesize &&
                newpos.z > dist.z - radius &&
                newpos.z < dist.z + radius + tilesize)
            {
               for (int flip = 0; flip < 2; flip++)
               {
                  Vector3 points[3];
                  if (flip)
                  {
                     points[0] = current->v[0];
                     points[1] = current->v[1];
                     points[2] = current->v[2];
                  }
                  else
                  {
                     points[0] = current->v[1];
                     points[1] = current->v[3];  // Should be this order
                     points[2] = current->v[2];
                  }
                  temp = adjust;
                  adjust += PlaneSphereCollision(points, oldpos, newpos, radius, debug);
                  if (adjust.distance2(temp) > .00001)
                  {
                     adjusted++;
                     if (current->dynamic && retobjs)
                        retobjs->push(((DynamicPrimitive*)current)->parentobj);
                  }
               }
            }
         }
         else if (current->type == "tristrip")
         {
            dist = current->v[0] + current->v[1] + current->v[2] + current->v[3];
            dist /= 4;
            if (dist.distance2(newpos) < 
                current->v[0].distance2(current->v[3]) + radius * radius)
            {
               for (int flip = 0; flip < 2; flip++)
               {
                  Vector3 points[3];
                  if (flip)
                  {
                     points[0] = current->v[0];
                     points[1] = current->v[1];
                     points[2] = current->v[2];
                  }
                  else
                  {
                     points[0] = current->v[1];
                     points[1] = current->v[3];  // Should be this order
                     points[2] = current->v[2];
                  }
                  temp = adjust;
                  adjust += PlaneSphereCollision(points, oldpos, newpos, radius);
                  if (adjust.distance2(temp) > .00001)
                  {
                     adjusted++;
                     if (current->dynamic && retobjs)
                        retobjs->push(((DynamicPrimitive*)current)->parentobj);
                  }
               }
            }
         }
      }
   }
   
   Vector3 v, s, t, u;
   for (int i = 0; i < 6; i++)  // Check the world bounding box
   {
      v = worldbounds[i].v[0];
      s = worldbounds[i].v[1];
      t = worldbounds[i].v[2];
      u = worldbounds[i].v[3];
            
      Vector3 norm;
      norm = (s - v).cross(t - v);
      norm.normalize();
      
      float d = -norm.dot(s);
      
      if (CrossesPlane(oldpos, newpos, norm, d))  // Crossed the plane
      {
         adjust += norm * radius;
         adjusted++;
      }
      else  // Check player bounding sphere
      {
         Vector3 start = newpos;
         Vector3 end = newpos - norm * radius;
         
         if (CrossesPlane(start, end, norm, d))
         {
            // We're talking infinite planes here, so if we crossed we hit
            // However, we need to know how far to adjust the player's
            // position so we find the int point anyway
            Vector3 move = end - start;
            float denominator = norm.dot(move);
            
            if (denominator != 0)  // Parallel with the plane?
            {
               float x = -(norm.dot(start) + d) / denominator;
               adjust += move * (x - 1);
               adjusted++;
            }
         }
      }
   }
   
   // Check edges of polys as well.
   if (!adjust.distance2(Vector3()))
   {
      for (int i = 0; i < psize; i++)
      {
         current = p[i];
         if (current->collide)
         {
            if (current->type == "terrain")
            {
               // Is the tile nearby?
               dist = current->v[0];
               if (newpos.x > dist.x - radius &&
                  newpos.x < dist.x + radius + tilesize &&
                  newpos.z > dist.z - radius &&
                  newpos.z < dist.z + radius + tilesize)
               {
                  Vector3 points[3];
                  for (int flip = 0; flip < 2; flip++)
                  {
                     if (flip)
                     {
                        points[0] = current->v[0];
                        points[1] = current->v[1];
                        points[2] = current->v[2];
                     }
                     else
                     {
                        points[0] = current->v[1];
                        points[1] = current->v[2];
                        points[2] = current->v[3];
                     }
                     temp = adjust;
                     adjust += PlaneEdgeSphereCollision(points, newpos, radius);
                     if (adjust.distance2(temp) > .00001)
                     {
                        adjusted++;
                        if (current->dynamic && retobjs)
                           retobjs->push(((DynamicPrimitive*)current)->parentobj);
                     }
                  }
               }
            }
            else if (current->type == "tristrip")
            {
               dist = current->v[0] + current->v[1] + current->v[2] + current->v[3];
               dist /= 4;
               if (dist.distance2(newpos) < current->v[0].distance2(current->v[3]))
               {
                  for (int flip = 0; flip < 2; flip++)
                  {
                     Vector3 points[3];
                     if (flip)
                     {
                        points[0] = current->v[0];
                        points[1] = current->v[1];
                        points[2] = current->v[2];
                     }
                     else
                     {
                        points[0] = current->v[1];
                        points[1] = current->v[2];
                        points[2] = current->v[3];
                     }
                     temp = adjust;
                     if (current->rad == 0)
                        adjust += PlaneEdgeSphereCollision(points, newpos, radius);
                     else 
                        adjust += PlaneEdgeSphereCollision(points, newpos, radius + float(current->rad));
                     
                     if (adjust.distance2(temp) > .00001)
                     {
                        adjusted++;
                        if (current->dynamic && retobjs)
                           retobjs->push(((DynamicPrimitive*)current)->parentobj);
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


// May want to precalculate normals to speed things up - keep in mind that
// dynamic primitives don't have precalculated normals, so if this is implemented
// that will have to be done before calling this function
Vector3 CollisionDetection::PlaneSphereCollision(Vector3 v[3], const Vector3& pos, const Vector3& pos1, const float& radius, bool debug)
{
   Vector3 adjust;
   Vector3 norm = (v[1] - v[0]).cross(v[2] - v[0]);
   norm.normalize();
   float d = -norm.dot(v[0]);
   
   // First check whether the sphere center completely crossed the plane
   float startside = norm.dot(pos) + d;
   
   /* Allows for checking both sides of polygons - not sure we need this 
   though since almost all collidable polys are going to be facing out*/
   if (startside < 0)
   {
      norm = (v[2] - v[0]).cross(v[1] - v[0]);
      norm.normalize();
      d = -norm.dot(v[0]);
   }
   
   // If the signs don't match then we crossed the infinite plane
   if (CrossesPlane(pos, pos1, norm, d))
   {
      Vector3 move = pos1 - pos;
      float denominator = norm.dot(move);
      float x = 0;
      
      if (denominator != 0)  // Parallel with the plane?
      {
         x = -(norm.dot(pos) + d) / denominator;
         Vector3 intpoint = pos + move * x;
                     
         // Determine whether we're on the poly
         float angle = 0;
         bool forcehit = false;
         for (int i = 0; i < 3; i++)
         {
            // When intpoint == v[i], we have problems because the dot product below ends up zero, which is wrong
            if (intpoint.distance2(v[i]) < .001)
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
            if (startside > 0)
               adjust = norm * radius;
            else adjust = norm * -radius;
            
            /* This was spamming KDevelop too much, and if the radius is smaller than the distance moved
               then it's most likely a particle and they will frequently cross (and that's okay).
            */
            if (pos.distance2(pos1) < radius * radius)
               cout << "Crossed the plane\n";
            
            return adjust;
         }
      }
   }
   
   // Then, if not check whether the sphere intercepts the poly
   Vector3 start = pos1;
   Vector3 end = pos1 - norm * radius;
   
   if (CrossesPlane(start, end, norm, d))
   {
      Vector3 move = end - start;
      float denominator = norm.dot(move);
      float x = 0;
      if (denominator != 0)  // Parallel with the plane?
      {
         x = -(norm.dot(start) + d) / denominator;
         Vector3 intpoint = start + move * x;
                  
         // Determine whether we're on the poly
         float angle = 0;  // Apparently can't be in the switch
         switch (intmethod)
         {
            case 0:  // Angle = 2PI method
               for (int i = 0; i < 3; i++)
               {
                  Vector3 p = intpoint - v[i];
                  Vector3 p1 = intpoint - v[(i + 1) % 3];
                  p.normalize();
                  p1.normalize();
                  angle += acos(p.dot(p1));
               }
               if (angle > 2 * PI - .01 && angle < 2 * PI + .01)   
               {    
                  if (x > .9999 && x < 1.0001) // Handle some rounding error
                     x = .9999;
                  adjust = move * (x - 1);
                  return adjust;
               }
               break;
            case 1:  // Barycentric coordinates
               Vector3 r = intpoint - v[0];
               Vector3 q1 = v[1] - v[0];
               Vector3 q2 = v[2] - v[0];
               
               float multiplier = 1 /
               (q1.dot(q1) * q2.dot(q2) - q1.dot(q2) * q1.dot(q2));
               float w1 = q2.dot(q2) * r.dot(q1) - q1.dot(q2) * r.dot(q2);
               float w2 = -q1.dot(q2) * r.dot(q1) + q1.dot(q1) * r.dot(q2);
               w1 *= multiplier;
               w2 *= multiplier;
               float w0 = 1 - w1 - w2;
               if (w0 >= 0 && w1 >= 0 && w2 >= 0)
               {
                  if (x > .9999) // Handle some rounding error
                     x = .9999;
                  adjust = move * (x - 1);
                  return adjust;
               }
               break;
         }
         
         
      }
   }
   return Vector3();
}


Vector3 CollisionDetection::PlaneEdgeSphereCollision(Vector3 v[3], const Vector3& pos, const float& radius)
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
      float c = (raystart - pos).dot(raystart - pos) -
            radius * radius;
      
      if (b * b - 4 * c > 0)
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


bool CollisionDetection::InVector(list<DynamicObject>::iterator& iter, vector<list<DynamicObject>::iterator>& vec)
{
   for (int i = 0; i < vec.size(); ++i)
      if (vec[i] == iter) return true;
   return false;
}


// I don't think this one is ever used because in most cases we want to reuse d, so it doesn't make sense to 
// calculate it each time
bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm, const Vector3& polypoint)
{
   float d = -norm.dot(polypoint);
   
   return CrossesPlane(start, end, norm, d);
}


bool CollisionDetection::CrossesPlane(const Vector3& start, const Vector3& end, const Vector3& norm, const float& d)
{
   
   float startside = norm.dot(start) + d;
   float endside = norm.dot(end) + d;
   
   /* Because if the signs are the same, this will end up positive
      At times, when one of these variables should be zero, it will
      actually be a very small number (7E-6 for instance) of the
      opposite sign from the other variable, which means if we just
      check the signs it appears we hit when we didn't.  Including
      values very close to 0 as non-hits fixes this.
   */
   return (startside * endside < -.0001);
}


