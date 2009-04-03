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


#include "PrimitiveOctree.h"

PrimitiveOctree::PrimitiveOctree(vector<GenericPrimitive> p)
{
   prims = p;
   haschildren = false;
   vector<GenericPrimitive>::iterator i;
   for (i = p.begin(); i != p.end(); ++i)
   {
      if (!i->collide)
         p.erase(i);
   }
}


/* 
   First remove any primitives that are not actually within the bounding
   box of this octree node.  Then try to further subdivide self by
   inserting all of our primitives into the children and recursively
   calling refine on them.
*/
void PrimitiveOctree::refine()
{
   refine(0);
}
/* refine() now just calls refine(int) so that we can keep track of how many
   levels the tree has.  It is possible with this algorithm to end up in
   infinite recursion so we cut it off at a semi-arbitrary level*/
void PrimitiveOctree::refine(int level)
{
   vector<GenericPrimitive>::iterator it = prims.begin();
   bool remove[prims.size()];
   for (int i = 0; i < prims.size(); ++i)
      remove[i] = false;
   
   bool allempty = true;
   for (int i = 0; i < 8; ++i)
   {
      //logout << "Child: " << i << endl;
      if (!haschildren)
      {
         vector<GenericPrimitive> temp;
         child[i] = new PrimitiveOctree(temp);
      }
      else
      {
         child[i]->clear();
      }
      Vector3 v[8];
      float halfx = vertices[0].x + vertices[7].x;
      halfx /= 2;
      float halfy = vertices[0].y + vertices[7].y;
      halfy /= 2;
      float halfz = vertices[0].z + vertices[7].z;
      halfz /= 2;
      switch (i) // No doubt a more elegant way to do this
      {
         case 0:
            v[0].x = vertices[0].x;
            v[0].y = vertices[0].y;
            v[0].z = vertices[0].z;
            v[7].x = halfx;
            v[7].y = halfy;
            v[7].z = halfz;
            break;
         case 1:
            v[0].x = halfx;
            v[0].y = vertices[0].y;
            v[0].z = vertices[0].z;
            v[7].x = vertices[7].x;
            v[7].y = halfy;
            v[7].z = halfz;
            break;
         case 2:
            v[0].x = vertices[0].x;
            v[0].y = halfy;
            v[0].z = vertices[0].z;
            v[7].x = halfx;
            v[7].y = vertices[7].y;
            v[7].z = halfz;
            break;
         case 3:
            v[0].x = halfx;
            v[0].y = halfy;
            v[0].z = vertices[0].z;
            v[7].x = vertices[7].x;
            v[7].y = vertices[7].y;
            v[7].z = halfz;
            break;
         case 4:
            v[0].x = vertices[0].x;
            v[0].y = vertices[0].y;
            v[0].z = halfz;
            v[7].x = halfx;
            v[7].y = halfy;
            v[7].z = vertices[7].z;
            break;
         case 5:
            v[0].x = halfx;
            v[0].y = vertices[0].y;
            v[0].z = halfz;
            v[7].x = vertices[7].x;
            v[7].y = halfy;
            v[7].z = vertices[7].z;
            break;
         case 6:
            v[0].x = vertices[0].x;
            v[0].y = halfy;
            v[0].z = halfz;
            v[7].x = halfx;
            v[7].y = vertices[7].y;
            v[7].z = vertices[7].z;
            break;
         case 7:
            v[0].x = halfx;
            v[0].y = halfy;
            v[0].z = halfz;
            v[7].x = vertices[7].x;
            v[7].y = vertices[7].y;
            v[7].z = vertices[7].z;
            break;
      }
      child[i]->setvertices(v);
      int j = 0;
      while (it != prims.end())
      {
         if (child[i]->innode(*it))  // Add to child and schedule for removal
         {
            child[i]->add(*it);
            //it = prims.erase(it); // Returns iterator to next
            remove[j] = true;
         }
         ++it;
         ++j;
      }
      it = prims.begin();  // Reset in case we loop again
      if (!child[i]->empty())
         allempty = false;
      //logout << size() << endl;
      if (child[i]->size() > 40 && level < 10)
      {
         child[i]->refine(level + 1);
         //logout << "Returned\n";
      }
   }
   it = prims.begin();
   int i = 0;
   while (it != prims.end())
   {
      if (remove[i])  // Remove it 
         it = prims.erase(it); // Returns iterator to next
      else  // Go to the next manually
         ++it;
      ++i;
   }
   if (allempty)
      for (int i = 0; i < 8; ++i)
         delete child[i];
   haschildren = !allempty;
}


void PrimitiveOctree::add(GenericPrimitive p)
{
   prims.push_back(p);
}


void PrimitiveOctree::addall(vector<GenericPrimitive> p)
{
   prims = p;
}


/* Helper function that just returns whether the primitive p is
 contained within the bounding box of node
 Want to use vertices 0 and 7 

 Because tristrips that are being used to collision detect cylinders
 need to be considered part of any node within the cylinder's radius,
 we set the rad and rad1 properties of them to the radius of the
 cylinder and use those values here.  v[0] is the cylinder's position.*/
bool PrimitiveOctree::innode(GenericPrimitive &p)
{
   bool contained = false;
   for (int i = 0; i < 4; ++i)
   {
      if (p.rad < .001)
      {
         if (p.v[i].x >= vertices[0].x && p.v[i].x <= vertices[7].x &&
            p.v[i].y <= vertices[0].y && p.v[i].y >= vertices[7].y &&
            p.v[i].z >= vertices[0].z && p.v[i].z <= vertices[7].z)
            contained = true;
      }
      else
      {
         float r;
         if (p.rad > p.rad1)
            r = p.rad;
         else r = p.rad1;
         if (p.v[i].x >= vertices[0].x - r && p.v[i].x <= vertices[7].x + r &&
            p.v[i].y <= vertices[0].y + r && p.v[i].y >= vertices[7].y - r &&
            p.v[i].z >= vertices[0].z - r && p.v[i].z <= vertices[7].z + r)
            contained = true;
      }
   }
   return contained;
}


// Top then bottom, starting with 0,0 (or closest to it) and following
// the right-hand rule as the worldbounds vectors do
void PrimitiveOctree::setvertices(Vector3 v[8])
{
   for (int i = 0; i < 8; ++i)
   {
      vertices[i].x = v[i].x;
      vertices[i].y = v[i].y;
      vertices[i].z = v[i].z;
   }
}


bool PrimitiveOctree::empty()
{
   return prims.empty();
}


void PrimitiveOctree::clear()
{
   prims.clear();
}


int PrimitiveOctree::size()
{
   return prims.size();
}


/* Return a vector containing all of the primitives that it is
   possible for the sphere at pos of radius size to intercept */
vector<GenericPrimitive> PrimitiveOctree::getprims(Vector3 pos, float size)
{
   vector<GenericPrimitive> ret = prims;
   if (haschildren)  // If no children we'll get a null pointer error
   {
      bool foundchild[8];
      for (int i = 0; i < 8; ++i)
         foundchild[i] = false;
      GenericPrimitive temp;
      for (int j = 0; j < 4; ++j)  // Generate dummy primitive
         temp.v[j] = pos;
      temp.rad = temp.rad1 = size;
      
      for (int j = 0; j < 8; ++j) // Check eight children
      {
         if (child[j]->innode(temp))
         {
            if (!foundchild[j]) // Don't return a child's prims > once
            {
               vector<GenericPrimitive> tempret = child[j]->getprims(pos, size);
               for (int k = 0; k < tempret.size(); ++k)
                  ret.push_back(tempret[k]);
            }
            foundchild[j] = true;
         }
      }
   }
   return ret;
}


// Render translucent boxes representing the tree for debugging purposes
void PrimitiveOctree::visualize()
{
   float alpha = .05;
   glDisable(GL_TEXTURE_2D);
   glDisable(GL_FOG);
   glColor4f(0, 0, 1, alpha);
   glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
   
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
   for (int i = 0; i < 8; ++i)
      child[i]->visualize();
}
