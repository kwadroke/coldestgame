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
// Copyright 2008, 2011 Ben Nemec
// @End License@
#include "Map.h"
#include "globals.h"
#include "ProceduralTree.h"
#include "serverdefs.h"

Map::Map(const string& mn)
{
   mapmeshes = &servermeshes;
   Init(mn);
}

// This is particularly important in the base Map class because both client and server use some of this code
#define meshes ERROR DO NOT USE THIS DIRECTLY
#define servermeshes ERROR DO NOT USE THIS DIRECTLY

void Map::Init(const string& mn)
{
   numtextures = 0;
   numobjects = 0;
   mapw = 0;
   maph = 0;
   maxterrainparams = 0;
   terrainstretch = 8;
   zeroheight = 0.f;
   heightscale = 0.f;
   mapname = mn;
   waterfile = "materials/water";
   worldbounds.resize(6);
}


// Load must be called after constructing the object because it calls virtual functions, which won't work
// if we call it directly from the constructor
void Map::Load()
{
   InitGui(mapname);

   ReadBasics();

   LoadLight();

   ResetGlobals();

   ReadMisc();
   ReadTerrParams();
   ReadSpawnPoints();
   SetProgress("Loading objects", 0);
   LoadObjects();
   SetProgress("Loading map data", 1);
   LoadMapData();
   SetProgress("Building terrain", 2);
   BuildTerrain();

   LoadWater();
   SetProgress("Generating grass", 3);
   CreateGrass();
   SetProgress("Paritioning world", 4);
   GenerateKDTree();
   SetProgress("Generating buffers", 5);
   GenBuffers();
   SetProgress("Caching meshes", 6);
   CreateCache();
   SetProgress("Rendering maps", 7);
   // These two functions really don't belong here, but I don't feel like messing with them right now
   CreateShadowmap();
   CreateMinimap();
   Finish();
}


void Map::ReadBasics()
{
   base = "maps/" + mapname;
   dataname = base + ".map";
   heightmapname = base + ".png";
   lightmapname = base + "light.png";

   mapdata = NTreeReader(dataname);

   mapdata.Read(tilesize, "TileSize");
   mapdata.Read(heightscale, "HeightScale");
   mapdata.Read(zeroheight, "ZeroHeight");
   mapdata.Read(numtextures, "NumTextures");
   mapdata.Read(numobjects, "NumObjects");
   mapdata.Read(terrainstretch, "Stretch");
}


void Map::ReadSpawnPoints()
{
   spawnpoints.clear();
   SpawnPointData spawntemp;
   NTreeReader spawnnode = mapdata.GetItemByName("SpawnPoints");
   
   for (size_t i = 0; i < spawnnode.NumChildren(); ++i)
   {
      const NTreeReader& currnode = spawnnode(i);
      currnode.Read(spawntemp.team, "Team");
      currnode.Read(spawntemp.position.x, "Location", 0);
      currnode.Read(spawntemp.position.y, "Location", 1);
      currnode.Read(spawntemp.position.z, "Location", 2);
      currnode.Read(spawntemp.name, "Name");
      spawnpoints.push_back(spawntemp);
   }
   spawnschanged = true;

   ReadSpawnPointsExtra();
}


void Map::LoadObjects()
{
   NTreeReader objectlist = mapdata.GetItemByName("Objects");
   string currmaterial;
   for (size_t i = 0; i < objectlist.NumChildren(); ++i)
   {
      const NTreeReader& currnode = objectlist(i);
      Mesh currmesh(currnode, resman);
      currmesh.dynamic = false;
      mapmeshes->push_back(currmesh);
   }
}


void Map::LoadMapData()
{
   float maxworldheight = 0;
   float minworldheight = 0;
   
   // Load the heightmap from an image
   SDL_Surface *loadmap;
   
   loadmap = IMG_Load(heightmapname.c_str());
   if (!loadmap)
   {
      logout << "Error loading heightmap for file: " << heightmapname << endl;
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
         offset *= loadmap->format->BytesPerPixel;
         maparray[y][x] = data[offset] * heightscale - zeroheight;
         
         if (maparray[y][x] > maxworldheight)
            maxworldheight = maparray[y][x];
         else if (maparray[y][x] < minworldheight)
            minworldheight = maparray[y][x];
      }
   }
   
   SDL_FreeSurface(loadmap);
   maxworldheight *= 5;
   mapwidth = (mapw - 1) * tilesize;
   mapheight = (maph - 1) * tilesize;
   // Done loading heightmap
   
   // Data structures for storing relevant values
   Vector3vec temp1;
   Vector3 v;
   
   floatvec temp2;
   
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
      logout << "Error loading lightmap for file: " << heightmapname << endl;
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
   worldbounds[0].SetVertex(0, Vector3(0, maxworldheight, 0));
   worldbounds[0].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   worldbounds[0].SetVertex(1, Vector3(0, maxworldheight, (maph - 1) * tilesize));
   worldbounds[0].SetVertex(2, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   // Sides
   worldbounds[1].SetVertex(0, Vector3(0, maxworldheight, 0));
   worldbounds[1].SetVertex(3, Vector3(0, maxworldheight, (maph - 1) * tilesize));
   worldbounds[1].SetVertex(1, Vector3(0, minworldheight, 0));
   worldbounds[1].SetVertex(2, Vector3(0, minworldheight, (maph - 1) * tilesize));
   
   worldbounds[2].SetVertex(0, Vector3(0, maxworldheight, (maph - 1)* tilesize));
   worldbounds[2].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   worldbounds[2].SetVertex(1, Vector3(0, minworldheight, (maph - 1) * tilesize));
   worldbounds[2].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   
   worldbounds[3].SetVertex(0, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   worldbounds[3].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   worldbounds[3].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   worldbounds[3].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   
   worldbounds[4].SetVertex(0, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   worldbounds[4].SetVertex(3, Vector3(0, maxworldheight, 0));
   worldbounds[4].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   worldbounds[4].SetVertex(2, Vector3(0, minworldheight, 0));
   // Bottom
   worldbounds[5].SetVertex(0, Vector3(0, minworldheight, 0));
   worldbounds[5].SetVertex(3, Vector3(0, minworldheight, (maph - 1) * tilesize));
   worldbounds[5].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   worldbounds[5].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   
   for (int x = 0; x < mapw; ++x)
   {
      for (int y = 0; y < maph; ++y)
      {
         heightmap[x][y] = GetSmoothedTerrain(x, y, mapw, maph, maparray);
      }
   }

   CalcMapTextures();
}


// Build terrain meshes
void Map::BuildTerrain()
{
   int numobjsx = mapw / terrobjsize;
   int numobjsy = maph / terrobjsize;
   vector<Meshlist::iterator> meshits;
   Mesh baseterrain(NTreeReader("models/terrain/base"), resman);
   
   for (int y = 0; y < numobjsy; ++y)
   {
      for (int x = 0; x < numobjsx; ++x)
      {
         Mesh tempmesh(baseterrain);
         tempmesh.Move(Vector3(x * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f),
                               0,
                               y * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f)));
         tempmesh.terrain = true;
         tempmesh.dynamic = false;
         tempmesh.occluder = true;
         mapmeshes->push_front(tempmesh);
         meshits.push_back(mapmeshes->begin());
      }
   }
   
   // Now build terrain triangles
   Meshlist::iterator currmesh;
   for (int x = 0; x < mapw - 1; ++x)
   {
      for (int y = 0; y < maph - 1; ++y)
      {
         currmesh = meshits[(y / terrobjsize) * numobjsx + (x / terrobjsize)];
         Quad tempquad;
         tempquad.SetVertex(0, Vector3(x * tilesize, heightmap[x][y], y * tilesize));
         tempquad.SetVertex(1, Vector3(x * tilesize, heightmap[x][y + 1], (y + 1) * tilesize));
         tempquad.SetVertex(2, Vector3((x + 1) * tilesize, heightmap[x + 1][y + 1], (y + 1) * tilesize));
         tempquad.SetVertex(3, Vector3((x + 1) * tilesize, heightmap[x + 1][y], y * tilesize));
         
         // Determine whether to use the smoothed normal or the actual normal
         Vector3 actualnorm = tempquad.GetVertex(1) - tempquad.GetVertex(0);
         actualnorm = actualnorm.cross(tempquad.GetVertex(3) - tempquad.GetVertex(0));
         actualnorm.normalize();
         if (actualnorm.y < 0)
         {
            actualnorm *= -1.f;
         }
         Vector3 tempnorm = ChooseNormal(actualnorm, normals[x][y]);
         tempquad.SetNormal(0, tempnorm);
         tempnorm = ChooseNormal(actualnorm, normals[x][y + 1]);
         tempquad.SetNormal(1, tempnorm);
         tempnorm = ChooseNormal(actualnorm, normals[x + 1][y + 1]);
         tempquad.SetNormal(2, tempnorm);
         tempnorm = ChooseNormal(actualnorm, normals[x + 1][y]);
         tempquad.SetNormal(3, tempnorm);

         tempquad.SetCollide(true);

         SetTerrainTextures(x, y, tempquad);
         
         // Smooth things out a bit by intelligently splitting quads
         Vector3 mid1 = tempquad.GetVertex(0) + tempquad.GetVertex(2);
         mid1 /= 2.f;
         Vector3 mid2 = tempquad.GetVertex(1) + tempquad.GetVertex(3);
         mid2 /= 2.f;
         
         float tri1 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(1), tempquad.GetVertex(3));
         float tri2 = Triangle::Perimeter(tempquad.GetVertex(1), tempquad.GetVertex(2), tempquad.GetVertex(3));
         float size1 = std::min(tri1, tri2);
         tri1 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(1), tempquad.GetVertex(2));
         tri2 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(2), tempquad.GetVertex(3));
         float size2 = std::min(tri1, tri2);
         if (size1 - size2 > float(tilesize) * .2f ||
            (mid1.y < mid2.y && size1 - size2 > -float(tilesize) * .2f))// Then rotate the quad so the triangle split happens on the other axis
         {
            VertexPtr last = tempquad.GetVertexPtr(0);
            for (size_t i = 0; i < 3; ++i)
            {
               tempquad.SetVertexPtr(i, tempquad.GetVertexPtr((i + 1) % 4));
            }
            tempquad.SetVertexPtr(3, last);

         }

         // Add up the average heights of the quads we add - these will be averaged below once all the quads have been added
         Vector3 midpoint;
         for (size_t i = 0; i < 4; ++i)
            midpoint += tempquad.GetVertex(i);
         midpoint /= 4.f;

         currmesh->Move(currmesh->GetPosition() + Vector3(0, midpoint.y, 0));

         currmesh->Add(tempquad);
      }
      Keepalive();
   }

   // Average out mesh positions so that we don't collision detect them unnecessarily
   for (size_t i = 0; i < meshits.size(); ++i)
   {
      Vector3 currpos = meshits[i]->GetPosition();
      currpos.y /= meshits[i]->NumTris() / 2.f;
      meshits[i]->Move(currpos);
   }
}


void Map::GenerateKDTree()
{
   /* This step is done outside of this class on the server so that it includes the base items that get created
   // Must be done here so it's available for KDTree creation
   for (Meshlist::iterator i = mapmeshes->begin(); i != mapmeshes->end(); ++i)
   {
      i->Update();
   }
   
   // Add objects to kd-tree
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = worldbounds[0].GetVertex(i);// + Vector3(0, 10, 0);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = worldbounds[5].GetVertex(i);
   }
   Keepalive();
   serverkdtree = ObjectKDTree(mapmeshes, points);
   logout << "Refining KD-Tree..." << std::flush;
   serverkdtree.refine(0);
   Keepalive();
   logout << "Done" << endl;
   */
}



void Map::CreateCache()
{
   Keepalive();
   if (console.GetBool("cache") && !editor)
      CacheMeshes();
   Keepalive();
}




















// This didn't work well so for the moment it doesn't do anything
Vector3 Map::ChooseNormal(const Vector3& actual, const Vector3& smooth)
{
   return smooth;
}

// Utility function to calculate the smoothed normal of a given vertex on the map
Vector3 Map::GetTerrainNormal(int x, int y, int mapw, int maph)
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


float Map::GetSmoothedTerrain(int x, int y, int mapw, int maph, vector<floatvec>& maparray)
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


size_t Map::Width()
{
   return (mapw - 1) * tilesize;
}

size_t Map::Height()
{
   return (maph - 1) * tilesize;
}


