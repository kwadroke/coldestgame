#include "ObjectKDTree.h"

ObjectKDTree::ObjectKDTree(list<WorldObjects> *objs, Vector3 v[8])
{
   haschildren = false;
   root = true;
   retobjs = new set<WorldObjects*>();
   // Get pointers to objects
   for (list<WorldObjects>::iterator i = objs->begin(); i != objs->end(); ++i)
   {
      members.push_back(&(*i));
   }
   cout << "KD-Tree Objects: " << members.size() << endl << flush;
   for (int i = 0; i < 6; ++i)
      p.push_back(WorldPrimitives());
   
   for (int i = 0; i < 8; ++i)
   {
      vertices[i].x = v[i].x;
      vertices[i].y = v[i].y;
      vertices[i].z = v[i].z;
   }
   vertices[1].x = v[0].x;
   vertices[1].y = v[7].y;
   vertices[1].z = v[0].z;
   
   vertices[2].x = v[7].x;
   vertices[2].y = v[0].y;
   vertices[2].z = v[0].z;
   
   vertices[3].x = v[7].x;
   vertices[3].y = v[7].y;
   vertices[3].z = v[0].z;
   
   vertices[4].x = v[0].x;
   vertices[4].y = v[7].y;
   vertices[4].z = v[7].z;
   
   vertices[5].x = v[7].x;
   vertices[5].y = v[0].y;
   vertices[5].z = v[7].z;
   
   vertices[6].x = v[0].x;
   vertices[6].y = v[0].y;
   vertices[6].z = v[7].z;
}


ObjectKDTree::ObjectKDTree()
{
   haschildren = false;
   members = list<WorldObjects*>();
   root = false;
   retobjs = NULL;
}


ObjectKDTree& ObjectKDTree::operator=(const ObjectKDTree& o)
{
   if (this == &o) return *this;
   for (int i = 0; i < 8; ++i)
      vertices[i] = o.vertices[i];
   members = o.members;
   children = o.children;
   root = o.root;
   p = o.p;
   frustum = &p;
   haschildren = o.haschildren;
   if (haschildren && root)
   {
      children[0].setfrustum(frustum);
      children[1].setfrustum(frustum);
   }
   if (root)
   {
      retobjs = new set<WorldObjects*>();
      setretobjs(retobjs);
   }
   return *this;
}


ObjectKDTree::ObjectKDTree(const ObjectKDTree& o)
{
   for (int i = 0; i < 8; ++i)
      vertices[i] = o.vertices[i];
   members = o.members;
   children = o.children;
   root = o.root;
   p = o.p;
   frustum = &p;
   haschildren = o.haschildren;
   if (haschildren && root)
   {
      children[0].setfrustum(frustum);
      children[1].setfrustum(frustum);
   }
   if (root)
   {
      retobjs = new set<WorldObjects*>();
      setretobjs(retobjs);
   }
}


ObjectKDTree::~ObjectKDTree()
{
   if (root)
      delete retobjs;
}


void ObjectKDTree::refine(int level)
{
   int curraxis = level % 2;
   int iterations = 0;
   float currsplit, minsplit, maxsplit;
   
   switch(curraxis)
   {
      case 0:
         minsplit = vertices[0].x;
         maxsplit = vertices[7].x;
         currsplit = (vertices[0].x + vertices[7].x) / 2;
         break;
      case 1:
         minsplit = vertices[0].z;
         maxsplit = vertices[7].z;
         currsplit = (vertices[0].z + vertices[7].z) / 2;
         break;
      case 2:
         minsplit = vertices[0].y;
         maxsplit = vertices[7].y;
         currsplit = (vertices[0].y + vertices[7].y) / 2;
         break;
   };
      
   Vector3 v[8];
   children.push_back(ObjectKDTree());
   children.push_back(ObjectKDTree());
   haschildren = true;
   
   while (true)
   {
      // Set children vertices
      v[0] = vertices[0];
      v[7] = vertices[7];
      switch(curraxis)
      {
         case 0:
            v[0].x = currsplit;
            break;
         case 1:
            v[0].z = currsplit;
            break;
         case 2:
            v[0].y = currsplit;
            break;
      };
      children[0].setvertices(v);
      
      v[0] = vertices[0];
      v[7] = vertices[7];      
      switch(curraxis)
      {
         case 0:
            v[7].x = currsplit;
            break;
         case 1:
            v[7].z = currsplit;
            break;
         case 2:
            v[7].y = currsplit;
            break;
      }
      children[1].setvertices(v);
      
      // Attempt to insert each object into the children, every object should be
      // successfully inserted into at least one of the children
      list<WorldObjects*>::iterator j;
      for (int i = 0; i < 2; ++i)
      {
         for (j = members.begin(); j != members.end(); ++j)
         {
            children[i].insert(*j);
         }
      }
      
      // If we've successfully split approx. in half, or have tried enough
      int size0 = children[0].size() + 1; // +1 to avoid div by zero
      int size1 = children[1].size() + 1;
      if (((float)size0 / (float)size1 > .9 && 
           (float)size0 / (float)size1 < 1.1) || iterations >= 5)
      {
         if ((children[0].size() >= 1 || children[1].size() >= 1) &&
            (level + 1 < 10))
         {
            children[0].refine(level + 1);
            children[1].refine(level + 1);
            // All members should be in a child now, so don't keep a copy
            members.clear();
         }
         else // Stop recursing
         {
            children.clear();
            haschildren = false;
         }
         
         if (root && haschildren)
         {
            setretobjs(retobjs);
            children[0].setfrustum(frustum);
            children[1].setfrustum(frustum);
         }
         return;
      }
      /* children[0] is actually the top half of the split, so 
         average curr and max, curr and min for children[1].
      */
      else if (children[0].size() > children[1].size())
      {
         minsplit = currsplit;
         switch(curraxis)
         {
            case 0:
               currsplit = (currsplit + maxsplit) / 2;
               break;
            case 1:
               currsplit = (currsplit + maxsplit) / 2;
               break;
            case 2:
               currsplit = (currsplit + maxsplit) / 2;
               break;
         };
      }
      else
      {
         maxsplit = currsplit;
         switch(curraxis)
         {
            case 0:
               currsplit = (currsplit + minsplit) / 2;
               break;
            case 1:
               currsplit = (currsplit + minsplit) / 2;
               break;
            case 2:
               currsplit = (currsplit + minsplit) / 2;
               break;
         };
      }
      
      children[0].members.clear();
      children[1].members.clear();
      ++iterations;
   }
}


bool ObjectKDTree::insert(WorldObjects *obj)
{
   if (innode(Vector3(obj->x, obj->y, obj->z), obj->size))
   {
      members.push_back(obj);
      return true;
   }
   else if (obj->type == "terrain" && innode2d(Vector3(obj->x, obj->y, obj->z), obj->size))
   {
      members.push_back(obj);
      return true;
   }
   return false;
}


bool ObjectKDTree::innode(Vector3 v, float size)
{
   return (v.x >= vertices[0].x - size / 2 &&
           v.y <= vertices[0].y + size / 2 &&
           v.z >= vertices[0].z - size / 2 &&
           v.x <= vertices[7].x + size / 2 &&
           v.y >= vertices[7].y - size / 2 &&
           v.z <= vertices[7].z + size / 2);
}


// Just for terrain because we only care about x and z coords
bool ObjectKDTree::innode2d(Vector3 v, float size)
{
   return (v.x >= vertices[0].x - size / 2 &&
           v.z >= vertices[0].z - size / 2 &&
           v.x <= vertices[7].x + size / 2 &&
           v.z <= vertices[7].z + size / 2);
}


vector<GenericPrimitive*> ObjectKDTree::getprims(Vector3 pos, float size)
{
   vector<GenericPrimitive*> ret;
   vector<GenericPrimitive*> temp;
   
   ret.reserve(1000);
   
   Timer t;
   
   if (root)
   {
      retobjs->clear();
      //retobjs->reserve(200);
   }
   
   if (innode(pos, size))
   {
      if (haschildren)
      {
         temp = children[0].getprims(pos, size);
         vecappend(ret, temp);
         temp = children[1].getprims(pos, size);
         vecappend(ret, temp);
      }
      else
      {
         for (list<WorldObjects*>::iterator i = members.begin(); i != members.end(); ++i)
         {
            if (retobjs->find(*i) == retobjs->end())
            {
               retobjs->insert(*i);
               for (vector<WorldPrimitives>::iterator j = (*i)->prims.begin(); j != (*i)->prims.end(); ++j)
               {
                  if (j->collide)
                  {
                     ret.push_back(&(*j));
                  }
               }
            }
         }
      }
   }
   
   return ret;
}


void ObjectKDTree::vecappend(vector<GenericPrimitive*> &dest, vector<GenericPrimitive*> &source)
{
   for (vector<GenericPrimitive*>::iterator i = source.begin(); i != source.end(); ++i)
      dest.push_back(*i);
}


/* Make sure to call setfrustum so this has the latest position info to
   work with
   */
list<WorldObjects*> ObjectKDTree::getobjs()
{
   list<WorldObjects*> ret;
   list<WorldObjects*> temp;
   
   if (root)
   {
      retobjs->clear();
      //retobjs->reserve(200);
   }
   
   if (infrustum())
   {
      if (haschildren)
      {
         temp = children[0].getobjs();
         objvecappend(ret, temp);
         temp = children[1].getobjs();
         objvecappend(ret, temp);
      }
      else
      {
         for (list<WorldObjects*>::iterator i = members.begin(); i != members.end(); ++i)
         {
            if (retobjs->find(*i) == retobjs->end() && infrustum(*i))
            {
               retobjs->insert(*i);
               ret.push_back(*i);
            }
         }
      }
   }
   
   return ret;
}


void ObjectKDTree::objvecappend(list<WorldObjects*> &dest, list<WorldObjects*> &source)
{
   for (list<WorldObjects*>::iterator i = source.begin(); i != source.end(); ++i)
      dest.push_back(*i);
}


bool ObjectKDTree::infrustum()
{
   /* Check if the tree node falls at all within the frustum
      Do this by checking each vertex of the node, and seeing
      if all of them fall outside of any single plane of the frustum
   */
   Vector3 v, s, t, u, norm;
   float d, startside;
   int hitcount;
   
   for (int i = 0; i < 6; ++i)
   {
      hitcount = 0;
      v = (*frustum)[i].v[0];
      s = (*frustum)[i].v[1];
      t = (*frustum)[i].v[2];
      u = (*frustum)[i].v[3];
      norm = (s - v).cross(t - v);
      norm.normalize();
      
      for (int j = 0; j < 8; ++j)
      {
         d = -norm.dot(s);
         
         startside = norm.dot(vertices[j]) + d;
         
         if (startside > -.0001)  // Completely inside
         {
            ++hitcount;
            break;
         }
      }
      if (!hitcount)
      {
         return false;
      }
   }
   return true;
}


bool ObjectKDTree::infrustum(WorldObjects* obj)
{
   Vector3 v, s, t, u, norm;
   float d, startside;
   
   for (int i = 0; i < 6; ++i)
   {
      v = (*frustum)[i].v[0];
      s = (*frustum)[i].v[1];
      t = (*frustum)[i].v[2];
      u = (*frustum)[i].v[3];
      norm = (s - v).cross(t - v);
      norm.normalize();
      
      d = -norm.dot(s);
      
      startside = norm.dot(Vector3(obj->x, obj->y, obj->z)) + d;
      startside = -startside;
      
      //cout << obj->type << ": " << startside << " > " << obj->size << endl;
      if (startside > obj->size) return false;
      
   }
   return true;
}


// This function should only ever be called on the root node.  Seg faults will result otherwise.
// Also note: This function must be called after copying KDTrees.  The frustum pointer is
// dangling after a copy
void ObjectKDTree::setfrustum(Vector3 pos, Vector3 rots, float nearz, float farz, float fov, float aspect)
{
   Vector3 currpoint;
   float nearx, neary, farx, fary;
   float radfov = fov * PI / 180.;
   float near = -nearz;
   float far = -farz;
   neary = 2 * tan(radfov / 2) * near / 2;
   nearx = neary * aspect;
   fary = 2 * tan(radfov / 2) * far / 2;
   farx = fary * aspect;
   
   currpoint.x = nearx;
   currpoint.y = neary;
   currpoint.z = near;
   p[0].v[0] = currpoint;
   p[2].v[1] = currpoint;
   p[3].v[3] = currpoint;
   
   currpoint.x = nearx;
   currpoint.y = -neary;
   p[0].v[1] = currpoint;
   p[3].v[1] = currpoint;
   p[4].v[3] = currpoint;
   
   currpoint.x = -nearx;
   currpoint.y = neary;
   p[0].v[2] = currpoint;
   p[2].v[3] = currpoint;
   p[5].v[1] = currpoint;
   
   currpoint.x = -nearx;
   currpoint.y = -neary;
   p[0].v[3] = currpoint;
   p[4].v[1] = currpoint;
   p[5].v[3] = currpoint;
   
   currpoint.x = -farx;
   currpoint.y = fary;
   currpoint.z = far;
   p[1].v[0] = currpoint;
   p[2].v[2] = currpoint;
   p[5].v[0] = currpoint;
   
   currpoint.x = -farx;
   currpoint.y = -fary;
   p[1].v[1] = currpoint;
   p[4].v[0] = currpoint;
   p[5].v[2] = currpoint;
   
   currpoint.x = farx;
   currpoint.y = fary;
   p[1].v[2] = currpoint;
   p[2].v[0] = currpoint;
   p[3].v[2] = currpoint;
   
   currpoint.x = farx;
   currpoint.y = -fary;
   p[1].v[3] = currpoint;
   p[3].v[0] = currpoint;
   p[4].v[2] = currpoint;
   
   GraphicMatrix m;
   
   m.rotatex(-rots.x);
   m.rotatey(rots.y);
   //m.rotatez(rots.z);
   m.translate(pos);
   for (int i = 0; i < 6; ++i)
   {
      for (int j = 0; j < 4; ++j)
      {
         p[i].v[j].transform(m.members);
      }
   }
   /*frustum = &p;
   if (haschildren)
   {
      children[0].setfrustum(frustum);
      children[1].setfrustum(frustum);
   }*/
}


void ObjectKDTree::setfrustum(vector<WorldPrimitives>* newp)
{
   frustum = newp;
   if (haschildren)
   {
      children[0].setfrustum(frustum);
      children[1].setfrustum(frustum);
   }
}


// Top then bottom, starting with 0,0 (or closest to it) and following
// the right-hand rule as the worldbounds vectors do
void ObjectKDTree::setvertices(Vector3 v[8])
{
   for (int i = 0; i < 8; ++i)
   {
      vertices[i].x = v[i].x;
      vertices[i].y = v[i].y;
      vertices[i].z = v[i].z;
   }
   vertices[1].x = v[0].x;
   vertices[1].y = v[7].y;
   vertices[1].z = v[0].z;
   
   vertices[2].x = v[7].x;
   vertices[2].y = v[0].y;
   vertices[2].z = v[0].z;
   
   vertices[3].x = v[7].x;
   vertices[3].y = v[7].y;
   vertices[3].z = v[0].z;
   
   vertices[4].x = v[0].x;
   vertices[4].y = v[7].y;
   vertices[4].z = v[7].z;
   
   vertices[5].x = v[7].x;
   vertices[5].y = v[0].y;
   vertices[5].z = v[7].z;
   
   vertices[6].x = v[0].x;
   vertices[6].y = v[0].y;
   vertices[6].z = v[7].z;
}


int ObjectKDTree::size()
{
   return members.size();
}


void ObjectKDTree::setretobjs(set<WorldObjects*>* in)
{
   retobjs = in;
   if (haschildren)
   {
      children[0].setretobjs(retobjs);
      children[1].setretobjs(retobjs);
   }
}


void ObjectKDTree::visualize()
{
   float alpha = .05;
   glDisable(GL_TEXTURE_2D);
   glDisable(GL_FOG);
   glColor4f(0, 0, 1, alpha);
   glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
   
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[0].x - 1, vertices[0].y - 1, vertices[0].z - 1);
   glVertex3f(vertices[7].x - 1, vertices[0].y - 1, vertices[0].z - 1);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[0].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[0].z);
   glEnd();
   
   glColor4f(1, 0, 1, alpha);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[0].x - 1, vertices[0].y - 1, vertices[0].z - 1);
   glVertex3f(vertices[7].x - 1, vertices[0].y - 1, vertices[0].z - 1);
   glVertex3f(vertices[0].x, vertices[0].y, vertices[7].z);
   glVertex3f(vertices[7].x, vertices[0].y, vertices[7].z);
   glEnd();
   
   glColor4f(1, 1, 1, alpha);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[0].x, vertices[0].y, vertices[7].z);
   glVertex3f(vertices[7].x, vertices[0].y, vertices[7].z);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[7].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[7].z);
   glEnd();
   
   glColor4f(1, 0, 0, alpha);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[0].x - 1, vertices[0].y - 1, vertices[0].z - 1);
   glVertex3f(vertices[0].x - 1, vertices[0].y - 1, vertices[7].z - 1);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[0].z);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[7].z);
   glEnd();
   
   glColor4f(1, 1, 0, alpha);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[7].x, vertices[0].y, vertices[0].z);
   glVertex3f(vertices[7].x, vertices[0].y, vertices[7].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[0].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[7].z);
   glEnd();
   
   glColor4f(0, 0, 0, alpha);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[0].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[0].z);
   glVertex3f(vertices[0].x, vertices[7].y, vertices[7].z);
   glVertex3f(vertices[7].x, vertices[7].y, vertices[7].z);
   glEnd();
   
   glColor4f(0, 0, 0, 1);
   glEnable(GL_TEXTURE_2D);
   glEnable(GL_FOG);
   
   if (!haschildren) return;
   for (int i = 0; i < 2; ++i)
      children[i].visualize();
}
