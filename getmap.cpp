#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include "ProgressBar.h"
#include "GUI.h"
#include "CollisionDetection.h"
#include "TextureHandler.h"
#include "ProceduralTree.h"
#include "Shader.h"
#include "Light.h"
#include "Vector3.h"
#include "types.h"
#include "globals.h"
#include "renderdefs.h"

using namespace std;

vector<Vector3vec> lightmap; // Terrain lightmap

struct TerrainParams
{
   int texture;
   float minheight, maxheight;
   float minslope, maxslope;
   float minrand, maxrand;
};

vector<TerrainParams> terrparams;
int terrainstretch;
WorldPrimitives worldbounds[6];

void Repaint();
float Max(float, float);
Vector3 GetTerrainNormal(int, int, int, int);
float GetSmoothedTerrain(int, int, int, int, vector< vector<float> >&);
float Random(float, float);
void GenShadows(Vector3, float, FBO&);
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);

// This function is waaay too long, but I'm too lazy to split it up
void GetMap(string fn)
{
   cout << "Loading " << fn << endl;
   int numtextures;
   int numobjects;
   int mapw, maph;
   int maxterrainparams = 6;
   float zeroheight;
   float heightscale;
   string dummy;
   string dataname = fn + ".map";
   string heightmapname = fn + ".png";
   string lightmapname = fn + "light.png";
   vector<floatvec> maparray;  // Heightmap data scaled by heightscale
   ProgressBar* progress = (ProgressBar*)loadprogress.GetWidget("loadprogressbar");
   GUI* progtext = loadprogress.GetWidget("progresstext");
   
   ifstream gm(dataname.c_str(), ios_base::in);
   gm >> dummy;
   gm >> tilesize;
   coldet.tilesize = tilesize;
   gm >> dummy;
   gm >> heightscale;
   gm >> dummy;
   gm >> zeroheight;
   gm >> dummy;
   gm >> numtextures;
   gm >> dummy;
   gm >> numobjects;
   gm >> dummy;
   gm >> terrainstretch;
   
   // Read global lighting information
   lights.Add();
   float diff[4];
   float spec[4];
   float amb[4];
   float fromx, fromy, fromz;
   
   gm >> dummy >> dummy;
   gm >> fromx >> fromy >> fromz;
   gm >> dummy;
   gm >> diff[0] >> diff[1] >> diff[2] >> diff[3];
   gm >> dummy;
   gm >> spec[0] >> spec[1] >> spec[2] >> spec[3];
   gm >> dummy;
   gm >> amb[0] >> amb[1] >> amb[2] >> amb[3];
   
   lights.SetDir(0, Vector3(fromx, fromy, fromz));
   lights.SetDiffuse(0, diff);
   lights.SetSpecular(0, spec);
   lights.SetAmbient(0, amb);
   
   // Load the textures themselves
   // Note: first texture must always be the skybox
   progress->SetRange(0, 6);
   progress->value = 0;
   progtext->text = "Loading textures";
   Repaint();
   
   // Pretty sure this call is irrelevant now that we're using shaders
   glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
   cout << "Loading textures(" << numtextures << ")" << endl;
   int currtex;
   string texpath;
   bool alpha;
   
   if (textures.size() > 0)
      glDeleteTextures(textures.size(), &textures[0]);
   textures.clear();
   for (int i = 0; i < numtextures; ++i)
      textures.push_back(0);
   gm >> currtex;
   gm >> texpath;
   for (int i = 0; i < numtextures; i++)
   {
      textures[i] = texman->LoadTexture(texpath);
      cout << ".";
      
      gm >> currtex;
      gm >> texpath;
   }
   cout << endl;
   
   // Read terrain parameters
   gm >> dummy;
   TerrainParams dummytp;
   for (int i = 0; i < maxterrainparams; ++i)
   {
      terrparams.push_back(dummytp);
      gm >> dummy;
      gm >> terrparams[i].texture;
      gm >> dummy;
      gm >> terrparams[i].minheight;
      gm >> terrparams[i].maxheight;
      gm >> dummy;
      gm >> terrparams[i].minslope;
      gm >> terrparams[i].maxslope;
      gm >> dummy;
      gm >> terrparams[i].minrand;
      gm >> terrparams[i].maxrand;
   }
   
   // Read spawnpoints
   spawnpoints.clear();
   SpawnPointData spawntemp;
   gm >> dummy;
   gm >> dummy;
   gm >> spawntemp.team;
   cout << spawntemp.team << endl;
   while (spawntemp.team >= 0 && spawntemp.team < 3)
   {
      cout << spawntemp.team << endl;
      gm >> dummy;
      gm >> spawntemp.position.x;
      gm >> spawntemp.position.y;
      gm >> spawntemp.position.z;
      
      spawnpoints.push_back(spawntemp);
      
      gm >> dummy;
      gm >> spawntemp.team;
   }
   selectedspawn = spawnpoints[0];
   
   // Load objects
   WorldObjects tempobj;
   WorldPrimitives tempprim;
   list<WorldObjects>::iterator currobj;
   objects.clear();
   impfbolist.clear();
   progtext->text = "Loading objects";
   progress->value = 1;
   Repaint();
   
   for (int i = 0; i < numobjects; i++)
   {
      tempobj = WorldObjects();
      tempobj.dynobj = dynobjects.end();
      objects.push_front(tempobj);
      currobj = objects.begin();
      gm >> currobj->type;
      if (currobj->type == "cylinder")
      {
         gm >> currtex;
         currobj->texnum = textures[currtex];
         gm >> tempprim.rad;
         gm >> tempprim.rad1;
         gm >> tempprim.height;
         gm >> tempprim.slices;
         gm >> tempprim.stacks;
         gm >> currobj->x;
         gm >> currobj->y;
         gm >> currobj->z;
         gm >> currobj->rotation;
         gm >> currobj->pitch;
         gm >> currobj->roll;
         currobj->size = max(tempprim.height, max(tempprim.rad, tempprim.rad1));
         tempprim.type = "cylinder";
         tempprim.object = currobj;
         tempprim.texnums[0] = currobj->texnum;
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
         
         // For collision detection
         tempprim.object = currobj;
         tempprim.type = "tristrip";
         tempprim.texnums[0] = currobj->texnum;
         tempprim.v[0].x = tempprim.v[1].x = tempprim.v[2].x = tempprim.v[3].x = 0;
         tempprim.v[0].z = tempprim.v[1].z = currobj->prims.front().height;
         tempprim.v[0].y = tempprim.v[1].y = tempprim.v[2].y = tempprim.v[3].y = 0;
         tempprim.v[2].z = tempprim.v[3].z = 0;
         tempprim.v[0].x -= .01;
         tempprim.v[2].x -= .01;
         tempprim.rad = currobj->prims.front().rad;
         tempprim.rad1 = currobj->prims.front().rad1;
         for (int vec = 0; vec < 4; ++vec)
         {
            tempprim.v[vec].rotate(currobj->pitch, currobj->rotation, currobj->roll);
            tempprim.v[vec].translate(currobj->x, currobj->y, currobj->z);
         }
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
      }
      else if (currobj->type == "tree")
      {
         int numleaves;  // Don't need to store this value
         gm >> currtex;
         currobj->texnum = textures[currtex];
         gm >> currtex;
         currobj->texnum1 = textures[currtex];
         gm >> currtex;
         currobj->texnum2 = textures[currtex];
         gm >> tempprim.rad;
         gm >> tempprim.rad1;
         gm >> tempprim.height;
         gm >> tempprim.slices;
         gm >> tempprim.stacks;
         gm >> currobj->x;
         gm >> currobj->y;
         gm >> currobj->z;
         gm >> currobj->rotation;
         gm >> currobj->pitch;
         gm >> currobj->roll;
         gm >> numleaves;
         tempprim.type = "cylinder";
         tempprim.object = currobj;
         tempprim.texnums[0] = currobj->texnum;
         currobj->pitch -= 90; // Make our trees stand up by default
         currobj->size = tempprim.height * 1.5;
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
         
         // For collision detection
         tempprim.object = currobj;
         tempprim.type = "tristrip";
         tempprim.texnums[0] = currobj->texnum;
         tempprim.v[0].x = tempprim.v[1].x = tempprim.v[2].x = tempprim.v[3].x = 0;
         tempprim.v[0].z = tempprim.v[1].z = currobj->prims.front().height;
         tempprim.v[0].y = tempprim.v[1].y = tempprim.v[2].y = tempprim.v[3].y = 0;
         tempprim.v[2].z = tempprim.v[3].z = 0;
         tempprim.v[0].x -= .01;
         tempprim.v[2].x -= .01;
         tempprim.rad = currobj->prims.front().rad;
         tempprim.rad1 = currobj->prims.front().rad1;
         for (int vec = 0; vec < 4; ++vec)
         {
            tempprim.v[vec].rotate(currobj->pitch, currobj->rotation, currobj->roll);
            tempprim.v[vec].translate(currobj->x, currobj->y, currobj->z);
         }
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
         
         // Generate leaves
         float height = currobj->prims.front().height;
         for (int j = 0; j < numleaves; j++)
         {
            tempprim.texnums[0] = currobj->texnum2;
            tempprim.object = currobj;
            tempprim.type = "tristrip";
            tempprim.transparent = false;
            tempprim.collide = false;
            float leafratio = 1.5;
            tempprim.v[0].x = height / leafratio;
            tempprim.v[0].y = 0;
            tempprim.v[0].z = height / leafratio;
            tempprim.v[1].x = height / leafratio;
            tempprim.v[1].y = 0;
            tempprim.v[1].z = -height / leafratio;
            tempprim.v[2].x = -height / leafratio;
            tempprim.v[2].y = 0;
            tempprim.v[2].z = height / leafratio;
            tempprim.v[3].x = -height / leafratio;
            tempprim.v[3].y = 0;
            tempprim.v[3].z = -height / leafratio;
            float amount = j * 360 / numleaves;
            for (int v = 0; v < 4; v++)
            {
               tempprim.v[v].rotate(amount * 2.5, amount * 3.3, amount);
               tempprim.v[v].translate(0, 0, height / 3 * 2);
               tempprim.v[v].rotate(currobj->pitch, currobj->rotation, currobj->roll);
               tempprim.v[v].translate(currobj->x, currobj->y, currobj->z);
            }
            for (int n = 0; n < 4; n++)
            {
               Vector3 temp1 = tempprim.v[1] - tempprim.v[0];
               Vector3 temp2 = tempprim.v[2] - tempprim.v[0];
               tempprim.n[n] = temp1.cross(temp2);
               tempprim.n[n].normalize();
            }
            currobj->prims.push_back(tempprim);
            tempprim = WorldPrimitives();
         }
      }
      else if (currobj->type == "proctree")
      {
         string dummy;
         ProceduralTree t;
         gm >> currtex;
         currobj->texnum = textures[currtex];
         gm >> currtex;
         currobj->texnum1 = textures[currtex];
         gm >> currtex;
         currobj->texnum2 = textures[currtex];
         currobj->size = 0; // Size is required
         t.ReadParams(gm);
         gm >> dummy >> currobj->impdist;
         gm >> dummy >> currobj->size;
         gm >> currobj->x;
         gm >> currobj->y;
         gm >> currobj->z;
         gm >> currobj->rotation;
         gm >> currobj->pitch;
         gm >> currobj->roll;
         currobj->dynobj = dynobjects.end();
         int save = t.GenTree(currobj);
         cout << "Tree primitives: " << save << endl;
      }
      else if (currobj->type == "bush")
      {
         int numleaves;  // Don't need to store this value
         gm >> currtex;
         currobj->texnum = textures[currtex];
         gm >> tempprim.height;
         gm >> currobj->x;
         gm >> currobj->y;
         gm >> currobj->z;
         gm >> currobj->rotation;
         gm >> currobj->pitch;
         gm >> currobj->roll;
         gm >> numleaves;
         currobj->size = tempprim.height;
         /*prims[nextprim].type = "cylinder";
         prims[nextprim].object = i;
         prims[nextprim].texnum = objects[i].texnum;*/
         
         // Generate leaves
         float height = currobj->size;
         for (int j = 0; j < numleaves; j++)
         {
            tempprim.texnums[0] = currobj->texnum;
            tempprim.object = currobj;
            tempprim.type = "tristrip";
            tempprim.transparent = false;
            tempprim.collide = false;
            float leafratio = .5;
            tempprim.v[0].x = height / leafratio;
            tempprim.v[0].y = 0;
            tempprim.v[0].z = height / leafratio;
            tempprim.v[1].x = height / leafratio;
            tempprim.v[1].y = 0;
            tempprim.v[1].z = -height / leafratio;
            tempprim.v[2].x = -height / leafratio;
            tempprim.v[2].y = 0;
            tempprim.v[2].z = height / leafratio;
            tempprim.v[3].x = -height / leafratio;
            tempprim.v[3].y = 0;
            tempprim.v[3].z = -height / leafratio;
            float amount = j * 360 / numleaves;
            for (int v = 0; v < 4; v++)
            {
               tempprim.v[v].rotate(amount * 2.5, amount * 3.3, amount);
               tempprim.v[v].translate(0, height / 2, 0);// / 3 * 2);
               tempprim.v[v].rotate(currobj->pitch, currobj->rotation, currobj->roll);
               tempprim.v[v].translate(currobj->x, currobj->y, currobj->z);
            }
            /* Right now we shut off lighting for tree leaves because
               it doesn't really look very good, so this step is not necessary
            for (int n = 0; n < 4; n++)
            {
               Vector3 temp1 = prims[nextprim].v[1] - prims[nextprim].v[0];
               Vector3 temp2 = prims[nextprim].v[2] - prims[nextprim].v[0];
               prims[nextprim].n[n] = temp1.cross(temp2);
               prims[nextprim].n[n].normalize();
            }*/
            currobj->prims.push_back(tempprim);
            tempprim = WorldPrimitives();
         }
      }
      else if (currobj->type == "tristrip")
      {
         gm >> currtex;
         currobj->texnum = textures[currtex];
         gm >> currobj->x;
         gm >> currobj->y;
         gm >> currobj->z;
         gm >> tempprim.v[0].x;
         gm >> tempprim.v[0].y;
         gm >> tempprim.v[0].z;
         gm >> tempprim.v[1].x;
         gm >> tempprim.v[1].y;
         gm >> tempprim.v[1].z;
         gm >> tempprim.v[2].x;
         gm >> tempprim.v[2].y;
         gm >> tempprim.v[2].z;
         gm >> tempprim.v[3].x;
         gm >> tempprim.v[3].y;
         gm >> tempprim.v[3].z;
         gm >> currobj->rotation;
         gm >> currobj->pitch;
         gm >> currobj->roll;
         currobj->size = max(tempprim.v[0].distance(tempprim.v[3]),
                             tempprim.v[1].distance(tempprim.v[2]));
         tempprim.type = "tristrip";
         tempprim.object = currobj;
         tempprim.texnums[0] = currobj->texnum;
         for (int v = 0; v < 4; v++)
         {
            tempprim.v[v].rotate(currobj->pitch, currobj->rotation, currobj->roll);
            tempprim.v[v].translate(currobj->x, currobj->y, currobj->z);
         }
         for (int n = 0; n < 4; n++)
         {
            Vector3 temp1 = tempprim.v[1] - tempprim.v[0];
            Vector3 temp2 = tempprim.v[2] - tempprim.v[0];
            tempprim.n[n] = temp1.cross(temp2);
            tempprim.n[n].normalize();
         }
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
      }
      else if (currobj->type == "dynobj")
      {
         /* Note that this will result in pushing a dummy object into the objects list, but
            since we may need something like that eventually for spatial partitioning I'm
            going to let it slide for now.*/
         string fname;
         list<DynamicObject>::iterator dyn;
         gm >> fname;
         dyn = LoadObject(fname, dynobjects);
         gm >> dyn->position.x >> dyn->position.y >> dyn->position.z;
         gm >> dyn->rotation >> dyn->pitch >> dyn->roll;
      }
   }
   
   progress->value = 2;
   progtext->text = "Loading map data";
   Repaint();
   
   // Build terrain objects
   float maxworldheight = 0;
   float minworldheight = 0;
   
   // Load the heightmap from an image
   SDL_Surface *loadmap;
   
   loadmap = IMG_Load(heightmapname.c_str());
   if (!loadmap)
   {
      cout << "Error loading heightmap for file: " << heightmapname << endl;
      exit(-1);
   }
   
   SDL_LockSurface(loadmap);
   unsigned char* data = (unsigned char*)loadmap->pixels;
   
   mapw = loadmap->w;
   maph = loadmap->h;
   
   floatvec fill(mapw);
   maparray.clear();
   for (int i = 0; i < maph; ++i)
      maparray.push_back(fill);
   
   for (int y = 0; y < maph; ++y)
   {
      for (int x = 0; x < mapw; ++x)
      {
         int offset = y * mapw + x;
         maparray[y][x] = data[offset] * heightscale - zeroheight;
         
         if (maparray[y][x] > maxworldheight)
            maxworldheight = maparray[y][x];
         else if (maparray[y][x] < minworldheight)
            minworldheight = maparray[y][x];
      }
   }
   
   SDL_FreeSurface(loadmap);
   maxworldheight *= 5;
   // Done loading heightmap
   
   // Data structures for storing relevant values
   typedef vector<WorldPrimitives> terrvec;
   vector<terrvec> terrprims;
   terrvec temp;
   WorldPrimitives prim; // Make sure all terrain gets defaults
   for (int i = 0; i < maph - 1; ++i)
      temp.push_back(prim);
   for (int i = 0; i < mapw - 1; ++i)
      terrprims.push_back(temp);
   
   vector<Vector3vec> normals;
   Vector3vec temp1;
   Vector3 v;
   
   vector<floatvec> texpercent;
   floatvec temp2;
   
   typedef vector<GLuint> gluintvec;
   vector<gluintvec> tex1;
   vector<gluintvec> tex2;
   gluintvec temp3;

   for (int i = 0; i < maph; ++i)
   {
      temp1.push_back(v);
      temp2.push_back(0.f);
      temp3.push_back(0);
      
   }
   lightmap.clear();
   heightmap.clear();
   for (int i = 0; i < mapw; ++i)
   {
      normals.push_back(temp1);
      lightmap.push_back(temp1);
      texpercent.push_back(temp2);
      heightmap.push_back(temp2);
      tex1.push_back(temp3);
      tex2.push_back(temp3);
   }
   
   // Populate above data structures
   
   // Load lightmap
   loadmap = IMG_Load(lightmapname.c_str());
   if (!loadmap || loadmap->w != mapw || loadmap->h != maph)
   {
      cout << "Error loading lightmap for file: " << heightmapname << endl;
      exit(-1);
   }
   
   SDL_LockSurface(loadmap);
   data = (unsigned char*)loadmap->pixels;
   
   for (int y = 0; y < maph; ++y)
   {
      for (int x = 0; x < mapw; ++x)
      {
         int offset = y * mapw + x;
         offset *= loadmap->format->BytesPerPixel;
         lightmap[x][y].x = data[offset] / 255.f;
         lightmap[x][y].y = data[offset + 1] / 255.f;
         lightmap[x][y].z = data[offset + 2] / 255.f;
      }
   }
   
   // Top
   worldbounds[0].v[0] = Vector3(0, maxworldheight, 0);
   worldbounds[0].v[1] = Vector3((mapw - 1) * tilesize, maxworldheight, 0);
   worldbounds[0].v[2] = Vector3(0, maxworldheight, (maph - 1) * tilesize);
   worldbounds[0].v[3] = Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize);
   // Sides
   worldbounds[1].v[0] = Vector3(0, maxworldheight, 0);
   worldbounds[1].v[1] = Vector3(0, maxworldheight, (maph - 1) * tilesize);
   worldbounds[1].v[2] = Vector3(0, minworldheight, 0);
   worldbounds[1].v[3] = Vector3(0, minworldheight, (maph - 1) * tilesize);
   
   worldbounds[2].v[0] = Vector3(0, maxworldheight, (maph - 1)* tilesize);
   worldbounds[2].v[1] = Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize);
   worldbounds[2].v[2] = Vector3(0, minworldheight, (maph - 1) * tilesize);
   worldbounds[2].v[3] = Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize);
   
   worldbounds[3].v[0] = Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize);
   worldbounds[3].v[1] = Vector3((mapw - 1) * tilesize, maxworldheight, 0);
   worldbounds[3].v[2] = Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize);
   worldbounds[3].v[3] = Vector3((mapw - 1) * tilesize, minworldheight, 0);
   
   worldbounds[4].v[0] = Vector3((mapw - 1) * tilesize, maxworldheight, 0);
   worldbounds[4].v[1] = Vector3(0, maxworldheight, 0);
   worldbounds[4].v[2] = Vector3((mapw - 1) * tilesize, minworldheight, 0);
   worldbounds[4].v[3] = Vector3(0, minworldheight, 0);
   // Bottom
   worldbounds[5].v[0] = Vector3(0, minworldheight, 0);
   worldbounds[5].v[1] = Vector3(0, minworldheight, (maph - 1) * tilesize);
   worldbounds[5].v[2] = Vector3((mapw - 1) * tilesize, minworldheight, 0);
   worldbounds[5].v[3] = Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize);
   
   for (int i = 0; i < 6; ++i)
   {
      worldbounds[i].object = objects.end();
      for (int j = 0; j < 4; ++j)
      {
         coldet.worldbounds[i].v[j] = worldbounds[i].v[j];
         coldet.worldbounds[i].object = objects.end();
      }
   }
   
   float slopecutoff = .75;
   float heightcutoff = 4;
   vector<float> texweights(6); // Can be increased, but will require a number of other changes
   int textouse[2];
   float currweights[2];
   
   for (int x = 0; x < mapw; ++x)
   {
      for (int y = 0; y < maph; ++y)
      {
         heightmap[x][y] = GetSmoothedTerrain(x, y, mapw, maph, maparray);
      }
   }
   for (int x = 0; x < mapw; ++x)
   {
      for (int y = 0; y < maph; ++y)
      {
         normals[x][y] = GetTerrainNormal(x, y, mapw, maph);
         
         // Calculate vertex weights
         for (int i = 0; i < maxterrainparams; ++i)
         {
            texweights[i] = 0;
            if (heightmap[x][y] >= terrparams[i].minheight && heightmap[x][y] <= terrparams[i].maxheight)
               texweights[i] += Random(terrparams[i].minrand, terrparams[i].maxrand);
            if (normals[x][y].y >= terrparams[i].minslope && normals[x][y].y <= terrparams[i].maxslope)
               texweights[i] += Random(terrparams[i].minrand, terrparams[i].maxrand);
         }
         
         textouse[0] = 0;
         textouse[1] = 0;
         currweights[0] = 0; // The larger current weight
         currweights[1] = 0;
         for (int i = 0; i < 6; ++i)
         {
            if (texweights[i] > currweights[0])
            {
               textouse[1] = textouse[0];
               currweights[1] = currweights[0];
               textouse[0] = i;
               currweights[0] = texweights[i];
            }
            else if (texweights[i] > currweights[1])
            {
               textouse[1] = i;
               currweights[1] = texweights[i];
            }
         }
         texpercent[x][y] = currweights[0] / (currweights[0] + currweights[1]);
         tex1[x][y] = textouse[0];
         tex2[x][y] = textouse[1];
      }
   }
   
   progress->value = 3;
   progtext->text = "Building terrain";
   Repaint();
   // Build terrain objects
   int numobjsx = mapw / terrobjsize;
   int numobjsy = maph / terrobjsize;
   vector<list<WorldObjects>::iterator> objits;
   tempobj = WorldObjects();
   tempobj.type = "terrain";
   tempobj.size = tilesize * terrobjsize * sqrt(2);
   tempobj.dynobj = dynobjects.end();
   for (int y = 0; y < numobjsy; ++y)
   {
      for (int x = 0; x < numobjsx; ++x)
      {
         objects.push_front(tempobj);
         objits.push_back(objects.begin());
         currobj = objects.begin();
         currobj->x = x * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f);
         currobj->y = 0;
         currobj->z = y * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f);
      }
   }
   
   // Now build terrain primitives
   tempprim = WorldPrimitives();
   for (int x = 0; x < mapw - 1; ++x)
   {
      for (int y = 0; y < maph - 1; ++y)
      {
         currobj = objits[(y / terrobjsize) * numobjsx + (x / terrobjsize)];
         tempprim.type = "terrain";
         tempprim.object = currobj;
         tempprim.v[0].x = x * tilesize;
         tempprim.v[0].y = heightmap[x][y];
         tempprim.v[0].z = y * tilesize;
         tempprim.v[1].x = x * tilesize;
         tempprim.v[1].y = heightmap[x][y + 1];
         tempprim.v[1].z = (y + 1) * tilesize;
         tempprim.v[2].x = (x + 1) * tilesize;
         tempprim.v[2].y = heightmap[x + 1][y];
         tempprim.v[2].z = y * tilesize;
         tempprim.v[3].x = (x + 1) * tilesize;
         tempprim.v[3].y = heightmap[x + 1][y + 1];
         tempprim.v[3].z = (y + 1) * tilesize;
         tempprim.n[0] = normals[x][y];
         tempprim.n[1] = normals[x][y + 1];
         tempprim.n[2] = normals[x + 1][y];
         tempprim.n[3] = normals[x + 1][y + 1];
         for (int i = 0; i < maxterrainparams; ++i)
            tempprim.texnums[i] = textures[terrparams[i].texture];
         tempprim.shader = "shaders/terrain";
         
         for (int i = 0; i < 6; ++i)
         {
            if (tex1[x][y] == i)
               tempprim.terraintex[0][i] = texpercent[x][y];
            else if (tex2[x][y] == i)
               tempprim.terraintex[0][i] = 1.f - texpercent[x][y];
            else tempprim.terraintex[0][i] = 0.f;
            
            if (tex1[x][y + 1] == i)
               tempprim.terraintex[1][i] = texpercent[x][y + 1];
            else if (tex2[x][y + 1] == i)
               tempprim.terraintex[1][i] = 1.f - texpercent[x][y + 1];
            else tempprim.terraintex[1][i] = 0.f;
            
            if (tex1[x + 1][y] == i)
               tempprim.terraintex[2][i] = texpercent[x + 1][y];
            else if (tex2[x + 1][y] == i)
               tempprim.terraintex[2][i] = 1.f - texpercent[x + 1][y];
            else tempprim.terraintex[2][i] = 0.f;
            
            if (tex1[x + 1][y + 1] == i)
               tempprim.terraintex[3][i] = texpercent[x + 1][y + 1];
            else if (tex2[x + 1][y + 1] == i)
               tempprim.terraintex[3][i] = 1.f - texpercent[x + 1][y + 1];
            else tempprim.terraintex[3][i] = 0.f;
         }
         
         tempprim.color[0][0] = lightmap[x][y].x;
         tempprim.color[0][1] = lightmap[x][y].y;
         tempprim.color[0][2] = lightmap[x][y].z;
         tempprim.color[1][0] = lightmap[x][y + 1].x;
         tempprim.color[1][1] = lightmap[x][y + 1].y;
         tempprim.color[1][2] = lightmap[x][y + 1].z;
         tempprim.color[2][0] = lightmap[x + 1][y].x;
         tempprim.color[2][1] = lightmap[x + 1][y].y;
         tempprim.color[2][2] = lightmap[x + 1][y].z;
         tempprim.color[3][0] = lightmap[x + 1][y + 1].x;
         tempprim.color[3][1] = lightmap[x + 1][y + 1].y;
         tempprim.color[3][2] = lightmap[x + 1][y + 1].z;
         
         // Leaving the alpha as the terrain blending factor, but it's no
         // longer actually used in that capacity anymore
         tempprim.color[0][3] = texpercent[x][y];
         tempprim.color[1][3] = texpercent[x][y + 1];
         tempprim.color[2][3] = texpercent[x + 1][y];
         tempprim.color[3][3] = texpercent[x + 1][y + 1];
         
         float texpiece = 1.f / (float)(terrainstretch);
         tempprim.texcoords[1][0][0] = (x % terrainstretch) * texpiece;
         tempprim.texcoords[1][0][1] = (y % terrainstretch) * texpiece;
         tempprim.texcoords[1][1][0] = (x % terrainstretch) * texpiece;
         tempprim.texcoords[1][1][1] = ((y % terrainstretch) + 1) * texpiece;
         tempprim.texcoords[1][2][0] = ((x % terrainstretch) + 1) * texpiece;
         tempprim.texcoords[1][2][1] = (y % terrainstretch) * texpiece;
         tempprim.texcoords[1][3][0] = ((x % terrainstretch) + 1) * texpiece;
         tempprim.texcoords[1][3][1] = ((y % terrainstretch) + 1) * texpiece;
         
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
      }
   }
   
   
   // Build water object
   float waterminx, waterminy;
   float watermaxx, watermaxy;
   float waterchunksize = 300.f;
   waterminx = waterminy = -5000.f;
   watermaxx = mapw * tilesize + 5000.f;
   watermaxy = maph * tilesize + 5000.f;
   int numwaterx = (int)(watermaxx - waterminx) / (int)waterchunksize;
   int numwatery = (int)(watermaxy - waterminy) / (int)waterchunksize;
   
   tempobj = WorldObjects();
   tempobj.type = "water";
   tempobj.size = (watermaxx - waterminx) + (watermaxy - waterminy);
   tempobj.dynobj = dynobjects.end();
   objects.push_front(tempobj);
   currobj = objects.begin();
   waterobj = currobj;
   
   for (int i = 0; i < numwaterx; ++i)
   {
      for (int j = 0; j < numwatery; ++j)
      {
         tempprim.type = "tristrip";
         tempprim.object = currobj;
         tempprim.v[0].x = i * waterchunksize + waterminx;
         tempprim.v[0].y = 0;
         tempprim.v[0].z = j * waterchunksize + waterminy;
         tempprim.v[1].x = i * waterchunksize + waterminx;
         tempprim.v[1].y = 0;
         tempprim.v[1].z = (j + 1) * waterchunksize + waterminy;
         tempprim.v[2].x = (i + 1) * waterchunksize + waterminx;
         tempprim.v[2].y = 0;
         tempprim.v[2].z = j * waterchunksize + waterminy;
         tempprim.v[3].x = (i + 1) * waterchunksize + waterminx;
         tempprim.v[3].y = 0;
         tempprim.v[3].z = (j + 1) * waterchunksize + waterminy;
         
         tempprim.texcoords[1][0][0] = (watermaxx - i * waterchunksize) / (watermaxx - waterminx);
         tempprim.texcoords[1][0][1] = (watermaxy - j * waterchunksize) / (watermaxy - waterminy);
         tempprim.texcoords[1][1][0] = (watermaxx - i * waterchunksize) / (watermaxx - waterminx);
         tempprim.texcoords[1][1][1] = (watermaxy - (j + 1) * waterchunksize) / (watermaxy - waterminy);
         tempprim.texcoords[1][2][0] = (watermaxx - (i + 1) * waterchunksize) / (watermaxx - waterminx);
         tempprim.texcoords[1][2][1] = (watermaxy - j * waterchunksize) / (watermaxy - waterminy);
         tempprim.texcoords[1][3][0] = (watermaxx - (i + 1) * waterchunksize) / (watermaxx - waterminx);
         tempprim.texcoords[1][3][1] = (watermaxy - (j + 1) * waterchunksize) / (watermaxy - waterminy);
         
         for (int k = 0; k < 4; ++k)
            tempprim.n[k] = Vector3(0, 1, 0);
         tempprim.shader = "shaders/water";
         tempprim.texnums[0] = reflectionfbo.GetTexture();
         tempprim.texnums[1] = noisefbo.GetTexture();
         currobj->prims.push_back(tempprim);
         tempprim = WorldPrimitives();
      }
   }
   
   progress->value = 4;
   progtext->text = "Generating buffers";
   Repaint();
   int fbodim = 32;
   int counter = 0;
   FBO dummyfbo;
   for (list<WorldObjects>::iterator i = objects.begin(); i != objects.end(); ++i)
   {
      if (i->type != "dynobj")
      {
         if (i->impdist)
         {
            if (counter >= fbostarts[2])
               fbodim = 32;
            else if (counter >= fbostarts[1])
               fbodim = 256;
            else fbodim = 512;
            dummyfbo = FBO(fbodim, fbodim, false, &texhand);
            impfbolist.push_back(dummyfbo);
            i->impostorfbo = counter;
            impobjs.push_back(&(*i));
            ++counter;
         }
         i->GenVbo(&shaderhand);
      }
      i->SetHeightAndWidth();
   }
   
   progress->value = 5;
   progtext->text = "Generating spatial tree";
   Repaint();
   // Add objects to kd-tree
   Vector3 points[8];
   for (int i = 0; i < 4; ++i)
   {
      points[i] = worldbounds[0].v[i];// + Vector3(0, 10, 0);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = worldbounds[5].v[i];
   }
   kdtree = ObjectKDTree(&objects, points);
   //kdtree.setvertices(points);
   cout << "Refining KD-Tree..." << flush;
   kdtree.refine(0);
   cout << "Done\n" << flush;
   coldet.kdtree = &kdtree;
   progress->value = 6;
   progtext->text = "Entering game";
   Repaint();
   
   // Render static shadow map
   if (shadows)
   {
      // Generate FBO to render to the shadow map texture
#ifndef DEBUGSMT
      shadowmapfbo = FBO(shadowmapsize, shadowmapsize, true, &texhand);
      worldshadowmapfbo = FBO(shadowmapsize, shadowmapsize, true, &texhand);
#else
      shadowmapfbo = FBO(shadowmapsize, shadowmapsize, false, &texhand);
      worldshadowmapfbo = FBO(shadowmapsize, shadowmapsize, false, &texhand);
#endif
      int shadowsize = mapw > maph ? mapw : maph;
      shadowsize *= tilesize;
      Vector3 center(mapw / 2.f, 0, maph / 2.f);
      center *= tilesize;
      GenShadows(center, shadowsize / 1.4, worldshadowmapfbo);
      texhand.ActiveTexture(7);
      
      texhand.BindTexture(worldshadowmapfbo.GetTexture());
      
      GraphicMatrix biasmat, proj, view;
      GLfloat bias[16] = {.5, 0, 0, 0, 0, .5, 0, 0, 0, 0, .5, 0, .5, .5, .5, 1};
      for (int i = 0; i < 16; ++i)
         biasmat.members[i] = bias[i];
      proj = lights.GetProj(0, shadowsize / 1.4);
      view = lights.GetView(0, center);
      glMatrixMode(GL_TEXTURE);
      glLoadMatrixf(biasmat);
      glMultMatrixf(proj);
      glMultMatrixf(view);
      
      glMatrixMode(GL_MODELVIEW);
      
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE_ARB, GL_COMPARE_R_TO_TEXTURE_ARB);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC_ARB, GL_LEQUAL);
      glTexParameteri(GL_TEXTURE_2D, GL_DEPTH_TEXTURE_MODE_ARB, GL_INTENSITY);
      
      texhand.ActiveTexture(0);
   }
   mapname = fn; // Must do this last as it signals the server thread that the map has been loaded
}


// Utility function to calculate the smoothed normal of a given vertex on the map
Vector3 GetTerrainNormal(int x, int y, int mapw, int maph)
{
   Vector3 v1, v2, current, total;
   int count = 0;
   current = Vector3(0, heightmap[x][y], 0);
   if (x - 1 >= 0)
   {
      v1 = Vector3(-tilesize, heightmap[x - 1][y], 0);
      if (y - 1 >= 0)
      {
         v2 = Vector3(0, heightmap[x][y - 1], -tilesize);
         total += (v2 - current).cross(v1 - current);
         ++count;
      }
   }
   if (y - 1 >= 0)
   {
      v1 = Vector3(0, heightmap[x][y - 1], -tilesize);
      if (x + 1 < mapw)
      {
         v2 = Vector3(tilesize, heightmap[x + 1][y], 0);
         total += (v2 - current).cross(v1 - current);
         ++count;
      }
   }
   if (x + 1 < mapw)
   {
      v1 = Vector3(tilesize, heightmap[x + 1][y], 0);
      if (y + 1 < maph)
      {
         v2 = Vector3(0, heightmap[x][y + 1], tilesize);
         total += (v2 - current).cross(v1 - current);
         ++count;
      }
   }
   if (y + 1 < maph)
   {
      v1 = Vector3(0, heightmap[x][y + 1], tilesize);
      if (x - 1 >= 0)
      {
         v2 = Vector3(-tilesize, heightmap[x - 1][y], 0);
         total += (v2 - current).cross(v1 - current);
         ++count;
      }
   }
   
   total /= count;
   total.normalize();
   return total;
}


float GetSmoothedTerrain(int x, int y, int mapw, int maph, vector<floatvec>& maparray)
{
   float total = 0;
   int count = 4;
   total += maparray[y][x] * 4;
   if (y + 1 < maph && fabs(maparray[y + 1][x] - maparray[y][x]) < 50)
   {
      total += maparray[y + 1][x];
      ++count;
   }
   if (x + 1 < mapw && fabs(maparray[y][x + 1] - maparray[y][x]) < 50)
   {
      total += maparray[y][x + 1];
      ++count;
   }
   if (y - 1 >= 0 && fabs(maparray[y - 1][x] - maparray[y][x]) < 50)
   {
      total += maparray[y - 1][x];
      ++count;
   }
   if (x - 1 >= 0 && fabs(maparray[y][x - 1] - maparray[y][x]) < 50)
   {
      total += maparray[y][x - 1];
      ++count;
   }
   return total / (float)count;
}
