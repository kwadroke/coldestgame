#include "WorldObjects.h"
#include "WorldPrimitives.h"

/* If we don't point the object member of this class at something in the constructor,
   then it becomes unsafe for copying because default constructed iterators have
   undefined copying behavior.
*/
extern list<WorldObjects> objects;

WorldPrimitives::WorldPrimitives()
{
   type = "none";
   depthtest = true;
   collide = true;
   transparent = false;
   rad = 0;
   rad1 = 0;
   dynamic = false;
   vector<float> tc(2);
   tc[0] = 0;
   tc[1] = 0;
   vector< vector<float> > tcv;
   for (int i = 0; i < 4; ++i)
      tcv.push_back(tc);
   
   for (int j = 0; j < 6; ++j)
   {
      for (int i = 0; i < 4; ++i)
      {
         n[i] = Vector3();
         terraintex[i][j] = 0;
      }
      texcoords.push_back(tcv);
      texcoords[j][1][1] = 1;
      texcoords[j][2][0] = 1;
      texcoords[j][3][0] = 1;
      texcoords[j][3][1] = 1;
   }
   for (int i = 0; i < 4; ++i)
   {
      for (int j = 0; j < 4; ++j)
         color[i][j] = 1.f;
   }
   shader = "shaders/standard";
   dist = 0.f;
   object = objects.end();
}


/* Shaders have top priority because they are the heaviest state change,
   but if they're equal then we sort by textures since they're the
   next heaviest.  Note that at the moment we assume if texnums[0] is
   equal, then all textures will be equal.  This may need to be changed.
*/
bool WorldPrimitives::operator<(const WorldPrimitives &c) const
{
   if (shader < c.shader) return true;
   else if (shader > c.shader) return false;
   else if (texnums[0] < c.texnums[0]) return true;
   else if (texnums[0] > c.texnums[0]) return false;
   return dist < c.dist;
}

bool WorldPrimitives::operator>(const WorldPrimitives &c) const
{
   if (shader > c.shader) return true;
   else if (shader < c.shader) return false;
   else if (texnums[0] > c.texnums[0]) return true;
   else if (texnums[0] < c.texnums[0]) return false;
   return dist > c.dist;
}
