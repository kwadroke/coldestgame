#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include "gui/ProgressBar.h"
#include "gui/GUI.h"
#include "CollisionDetection.h"
#include "TextureHandler.h"
#include "ProceduralTree.h"
#include "Shader.h"
#include "Light.h"
#include "Vector3.h"
#include "types.h"
#include "globals.h"
#include "renderdefs.h"
#include "editor.h"
#include "IniReader.h"
#include "Quad.h"
#include "Mesh.h"

using namespace std;

vector<Vector3vec> lightmap; // Terrain lightmap

struct TerrainParams
{
   string file;
   int texture;
   float minheight, maxheight;
   float minslope, maxslope;
   float minrand, maxrand;
   float blend;
};

vector<TerrainParams> terrparams;
int terrainstretch;

void Repaint();
float Max(float, float);
Vector3 GetTerrainNormal(int, int, int, int);
float GetSmoothedTerrain(int, int, int, int, vector< floatvec >&);
float Random(float, float);
Vector3 ChooseNormal(const Vector3&, const Vector3&);

// This function is waaay too long, but I'm too lazy to split it up
// Make sure you have clientmutex before calling this.
void GetMap(string fn)
{
   logout << "Loading " << fn << endl;
   int numtextures;
   int numobjects;
   int mapw, maph;
   int maxterrainparams = 0;
   float zeroheight;
   float heightscale;
   string dummy;
   string dataname = fn + ".map";
   string heightmapname = fn + ".png";
   string lightmapname = fn + "light.png";
   string waterfile = "materials/water";
   vector<floatvec> maparray;  // Heightmap data scaled by heightscale
#ifndef DEDICATED
   ProgressBar* progress = (ProgressBar*)gui[loadprogress]->GetWidget("loadprogressbar");
   GUI* progtext = gui[loadprogress]->GetWidget("progresstext");
   GUI* progname = gui[loadprogress]->GetWidget("loadname");
   progname->text = "Loading " + fn;
#endif
   
   IniReader mapdata(dataname);
   
   mapdata.Read(tilesize, "TileSize");
//   coldet.tilesize = tilesize;
   mapdata.Read(heightscale, "HeightScale");
   mapdata.Read(zeroheight, "ZeroHeight");
   mapdata.Read(numtextures, "NumTextures");
   mapdata.Read(numobjects, "NumObjects");
   mapdata.Read(terrainstretch, "Stretch");
   
   // Read global lighting information
#ifndef DEDICATED
   lights.Add();
#endif
   float diff[4];
   float spec[4];
   float amb[4];
   float fromx, fromy, fromz;
   
   mapdata.Read(fromx, "Direction", 0);
   mapdata.Read(fromy, "Direction", 1);
   mapdata.Read(fromz, "Direction", 2);
   
   for (int i = 0; i < 4; ++i)
   {
      mapdata.Read(diff[i], "Diffuse", i);
      mapdata.Read(spec[i], "Specular", i);
      mapdata.Read(amb[i], "Ambient", i);
   }
   
#ifndef DEDICATED
   lights.SetDir(0, Vector3(fromx, fromy, fromz));
   lights.SetDiffuse(0, diff);
   lights.SetSpecular(0, spec);
   lights.SetAmbient(0, amb);
#endif
   
   // Load the textures themselves
   // Actually, the textures get loaded as Materials get loaded now, so this is really a bogus step
#ifndef DEDICATED
   progress->SetRange(0, 8);
   progress->value = 0;
   progtext->text = "Loading textures";
   Repaint();
#endif

   // Release any previously allocated resources so we don't leak memory
   meshes.clear();
   items.clear();
   mapspawns.clear(); 
#ifndef DEDICATED
   resman.ReleaseAll();
   InitShaders();
   LoadMaterials();
   particlemesh = MeshPtr();  // Otherwise we may try to render it later and that will be bad
#endif
   particles.clear();
   deletemeshes.clear(); // Also a problem if not empty when we load a new map
   for (size_t i = 0; i < numbodyparts; ++i) // We deleted all the meshes, so we need to clear these iterators
   {
      player[0].mesh[i] = meshes.end();
   }
   PlayerData local = player[0];
   player.clear();
   player.push_back(local);
   ResetKeys();
   
   IniReader currnode;
#ifndef DEDICATED
   string readskybox;
   mapdata.Read(readskybox, "SkyBox");
   skyboxmat = &resman.LoadMaterial(readskybox);
   
   mapdata.Read(waterfile, "Water");
   
   // Read terrain parameters
   TerrainParams dummytp;
   string nodename;
   string terrainmaterial;
   mapdata.Read(terrainmaterial, "TerrainMaterial");
   IniReader texnode = mapdata.GetItemByName("TerrainParams");
   maxterrainparams = texnode.NumChildren();
   for (int i = 0; i < maxterrainparams; ++i)
   {
      terrparams.push_back(dummytp);
      currnode = texnode(i);
      
      currnode.Read(terrparams[i].file, "File");
      currnode.Read(terrparams[i].minheight, "HeightRange", 0);
      currnode.Read(terrparams[i].maxheight, "HeightRange", 1);
      currnode.Read(terrparams[i].minslope, "SlopeRange", 0);
      currnode.Read(terrparams[i].maxslope, "SlopeRange", 1);
      currnode.Read(terrparams[i].minrand, "RandRange", 0);
      currnode.Read(terrparams[i].maxrand, "RandRange", 1);
      terrparams[i].blend = 0;
      currnode.Read(terrparams[i].blend, "Blend");
   }
#endif
   
   // Read spawnpoints
   spawnpoints.clear();
   SpawnPointData spawntemp;
   IniReader spawnnode = mapdata.GetItemByName("SpawnPoints");
   
   for (int i = 0; i < spawnnode.NumChildren(); ++i)
   {
      currnode = spawnnode(i);
      currnode.Read(spawntemp.team, "Team");
      currnode.Read(spawntemp.position.x, "Location", 0);
      currnode.Read(spawntemp.position.y, "Location", 1);
      currnode.Read(spawntemp.position.z, "Location", 2);
      currnode.Read(spawntemp.name, "Name");
      spawnpoints.push_back(spawntemp);
#ifndef DEDICATED
      if (editor)
      {
         MeshPtr newmesh = meshcache->GetNewMesh("models/base/base");
         newmesh->Move(spawntemp.position);
         newmesh->dynamic = true;
         newmesh->GenVbo();
         meshes.push_back(*newmesh);
         spawnmeshes.push_back(&meshes.back());
      }
#endif
   }
   spawnschanged = true; 
   player[0].team = 0;
   
   // Load objects
#ifndef DEDICATED
   progtext->text = "Loading objects";
   progress->value = 1;
   Repaint();
#endif
   
   IniReader objectlist = mapdata.GetItemByName("Objects");
   string currmaterial;
   for (int i = 0; i < objectlist.NumChildren(); ++i)
   {
      currnode = objectlist(i);
      Mesh currmesh("", resman, currnode);
      meshes.push_back(currmesh);
#ifndef DEDICATED
      if (editor)
      {
         string type;
         currnode.Read(type, "Type");
         if (type == "proctree")
         {
            ProceduralTree t;
            t.ReadParams(currnode);
            t.mesh = &meshes.back();
            treemap[&meshes.back()] = t;
         }
      }
#endif
   }
   
#ifndef DEDICATED
   progress->value = 2;
   progtext->text = "Loading map data";
   Repaint();
#endif
   
   // Build terrain objects
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
   coldet.worldbounds[0].SetVertex(0, Vector3(0, maxworldheight, 0));
   coldet.worldbounds[0].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   coldet.worldbounds[0].SetVertex(1, Vector3(0, maxworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[0].SetVertex(2, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   // Sides
   coldet.worldbounds[1].SetVertex(0, Vector3(0, maxworldheight, 0));
   coldet.worldbounds[1].SetVertex(3, Vector3(0, maxworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[1].SetVertex(1, Vector3(0, minworldheight, 0));
   coldet.worldbounds[1].SetVertex(2, Vector3(0, minworldheight, (maph - 1) * tilesize));
   
   coldet.worldbounds[2].SetVertex(0, Vector3(0, maxworldheight, (maph - 1)* tilesize));
   coldet.worldbounds[2].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[2].SetVertex(1, Vector3(0, minworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[2].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   
   coldet.worldbounds[3].SetVertex(0, Vector3((mapw - 1) * tilesize, maxworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[3].SetVertex(3, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   coldet.worldbounds[3].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[3].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   
   coldet.worldbounds[4].SetVertex(0, Vector3((mapw - 1) * tilesize, maxworldheight, 0));
   coldet.worldbounds[4].SetVertex(3, Vector3(0, maxworldheight, 0));
   coldet.worldbounds[4].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   coldet.worldbounds[4].SetVertex(2, Vector3(0, minworldheight, 0));
   // Bottom
   coldet.worldbounds[5].SetVertex(0, Vector3(0, minworldheight, 0));
   coldet.worldbounds[5].SetVertex(3, Vector3(0, minworldheight, (maph - 1) * tilesize));
   coldet.worldbounds[5].SetVertex(1, Vector3((mapw - 1) * tilesize, minworldheight, 0));
   coldet.worldbounds[5].SetVertex(2, Vector3((mapw - 1) * tilesize, minworldheight, (maph - 1) * tilesize));
   
   float slopecutoff = .75;
   float heightcutoff = 4;
   floatvec texweights(6, 0.f); // Can be increased, but will require a number of other changes
   int textouse[2];
   float currweights[2];
   
   for (int x = 0; x < mapw; ++x)
   {
      for (int y = 0; y < maph; ++y)
      {
         heightmap[x][y] = GetSmoothedTerrain(x, y, mapw, maph, maparray);
      }
   }
#ifndef DEDICATED
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
               texweights[i] += Random(terrparams[i].minrand, terrparams[i].maxrand) * 
               smoothstep(terrparams[i].minheight, terrparams[i].minheight + terrparams[i].blend, heightmap[x][y]) *
               (1.f - smoothstep(terrparams[i].maxheight - terrparams[i].blend, terrparams[i].maxheight, heightmap[x][y]));
            if (normals[x][y].y >= terrparams[i].minslope && normals[x][y].y <= terrparams[i].maxslope)
               texweights[i] += Random(terrparams[i].minrand, terrparams[i].maxrand) *
               smoothstep(terrparams[i].minslope, terrparams[i].minslope + terrparams[i].blend, normals[x][y].y) *
               (1 - smoothstep(terrparams[i].maxslope - terrparams[i].blend, terrparams[i].maxslope, normals[x][y].y));
         }
         
         textouse[0] = 0;
         textouse[1] = 0;
         currweights[0] = 0; // The larger current weight
         currweights[1] = 0;
         for (int i = 0; i < maxterrainparams; ++i)
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
#endif
   // Build terrain meshes
   int numobjsx = mapw / terrobjsize;
   int numobjsy = maph / terrobjsize;
   vector<Meshlist::iterator> meshits;
   Mesh baseterrain("models/terrain/base", resman);
   
   for (int y = 0; y < numobjsy; ++y)
   {
      for (int x = 0; x < numobjsx; ++x)
      {
         Mesh tempmesh(baseterrain);
         tempmesh.Move(Vector3(x * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f),
                               0,
                               y * terrobjsize * tilesize + tilesize * (terrobjsize / 2.f)));
         tempmesh.drawdistmult = console.GetFloat("terrainmulti");
         tempmesh.terrain = true;
         meshes.push_front(tempmesh);
         meshits.push_back(meshes.begin());
      }
   }
   
   // Now build terrain triangles
   Meshlist::iterator currmesh;
   map<set<int>, Material*> texmats;
   for (int x = 0; x < mapw - 1; ++x)
   {
      for (int y = 0; y < maph - 1; ++y)
      {
         currmesh = meshits[(y / terrobjsize) * numobjsx + (x / terrobjsize)];
         Quad tempquad(currmesh->vertheap);
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
#ifndef DEDICATED
         set<int> currtex;
         currtex.insert(tex1[x][y]);
         currtex.insert(tex2[x][y]);
         currtex.insert(tex1[x][y + 1]);
         currtex.insert(tex2[x][y + 1]);
         currtex.insert(tex1[x + 1][y]);
         currtex.insert(tex2[x + 1][y]);
         currtex.insert(tex1[x + 1][y + 1]);
         currtex.insert(tex2[x + 1][y + 1]);
         
         Material* currmat;
         if (currtex.size() > 6)
         {
            logout << "Warning: Too many textures on terrain.\n";
            logout << "Location : " << (x * tilesize) << " " << heightmap[x][y] << " " << (y * tilesize) << endl;
            currmat = &resman.LoadMaterial("materials/default");
         }
         else
         {
            if (texmats.find(currtex) == texmats.end())
            {
               string matfile = "materials/terrain/base";
               string currname;
               matfile += ToString(currtex.size());
               Material newmat(matfile, resman.texman, resman.shaderman);
               int count = 0;
               for (set<int>::iterator i = currtex.begin(); i != currtex.end(); ++i)
               {
                  newmat.SetTexture(count, terrparams[*i].file);
                  ++count;
               }
               currname = "terrain" + ToString(texmats.size());
               resman.AddMaterial(currname, newmat);
               texmats[currtex] = &resman.LoadMaterial(currname);
            }
            currmat = texmats[currtex];
         }
         tempquad.SetMaterial(currmat);
         
         int realtex = 0;
         for (set<int>::iterator i = currtex.begin(); i != currtex.end(); ++i)
         {
            if (tex1[x][y] == *i)
               tempquad.SetTerrainWeight(0, realtex, texpercent[x][y]);
            else if (tex2[x][y] == *i)
               tempquad.SetTerrainWeight(0, realtex, 1.f - texpercent[x][y]);
            else tempquad.SetTerrainWeight(0, realtex, 0.f);
            
            if (tex1[x][y + 1] == *i)
               tempquad.SetTerrainWeight(1, realtex, texpercent[x][y + 1]);
            else if (tex2[x][y + 1] == *i)
               tempquad.SetTerrainWeight(1, realtex, 1.f - texpercent[x][y + 1]);
            else tempquad.SetTerrainWeight(1, realtex, 0.f);
            
            if (tex1[x + 1][y + 1] == *i)
               tempquad.SetTerrainWeight(2, realtex, texpercent[x + 1][y + 1]);
            else if (tex2[x + 1][y + 1] == *i)
               tempquad.SetTerrainWeight(2, realtex, 1.f - texpercent[x + 1][y + 1]);
            else tempquad.SetTerrainWeight(2, realtex, 0.f);
            
            if (tex1[x + 1][y] == *i)
               tempquad.SetTerrainWeight(3, realtex, texpercent[x + 1][y]);
            else if (tex2[x + 1][y] == *i)
               tempquad.SetTerrainWeight(3, realtex, 1.f - texpercent[x + 1][y]);
            else tempquad.SetTerrainWeight(3, realtex, 0.f);
            ++realtex;
         }
         
         GLubytevec tempcol(4, 255);
         tempcol[0] = (GLubyte)lightmap[x][y].x * 255;
         tempcol[1] = (GLubyte)lightmap[x][y].y * 255;
         tempcol[2] = (GLubyte)lightmap[x][y].z * 255;
         tempquad.SetColor(0, tempcol);
         tempcol[0] = (GLubyte)lightmap[x][y + 1].x * 255;
         tempcol[1] = (GLubyte)lightmap[x][y + 1].y * 255;
         tempcol[2] = (GLubyte)lightmap[x][y + 1].z * 255;
         tempquad.SetColor(1, tempcol);
         tempcol[0] = (GLubyte)lightmap[x + 1][y + 1].x * 255;
         tempcol[1] = (GLubyte)lightmap[x + 1][y + 1].y * 255;
         tempcol[2] = (GLubyte)lightmap[x + 1][y + 1].z * 255;
         tempquad.SetColor(2, tempcol);
         tempcol[0] = (GLubyte)lightmap[x + 1][y].x * 255;
         tempcol[1] = (GLubyte)lightmap[x + 1][y].y * 255;
         tempcol[2] = (GLubyte)lightmap[x + 1][y].z * 255;
         tempquad.SetColor(3, tempcol);
         
         float texpiece = 1.f / (float)(terrainstretch);
         floatvec temptc(2, 0.f);
         temptc[0] = (x % terrainstretch) * texpiece;
         temptc[1] = (y % terrainstretch) * texpiece;
         tempquad.SetTexCoords(0, 1, temptc);
         temptc[0] = (x % terrainstretch) * texpiece;
         temptc[1] = ((y % terrainstretch) + 1) * texpiece;
         tempquad.SetTexCoords(1, 1, temptc);
         temptc[0] = ((x % terrainstretch) + 1) * texpiece;
         temptc[1] = ((y % terrainstretch) + 1) * texpiece;
         tempquad.SetTexCoords(2, 1, temptc);
         temptc[0] = ((x % terrainstretch) + 1) * texpiece;
         temptc[1] = (y % terrainstretch) * texpiece;
         tempquad.SetTexCoords(3, 1, temptc);
#endif
         tempquad.SetCollide(true);
         
         // Smooth things out a bit by intelligently splitting quads
         Vector3 mid1 = tempquad.GetVertex(0) + tempquad.GetVertex(2);
         mid1 /= 2.f;
         Vector3 mid2 = tempquad.GetVertex(1) + tempquad.GetVertex(3);
         mid2 /= 2.f;
         
         float tri1 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(1), tempquad.GetVertex(3));
         float tri2 = Triangle::Perimeter(tempquad.GetVertex(1), tempquad.GetVertex(2), tempquad.GetVertex(3));
         float size1 = min(tri1, tri2);
         tri1 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(1), tempquad.GetVertex(2));
         tri2 = Triangle::Perimeter(tempquad.GetVertex(0), tempquad.GetVertex(2), tempquad.GetVertex(3));
         float size2 = min(tri1, tri2);
         if (size1 - size2 > float(tilesize) * .2f || 
             (mid1.y < mid2.y && size1 - size2 > -float(tilesize) * .2f))// Then rotate the quad so the triangle split happens on the other axis
         {
            VertexVHP last = tempquad.GetVertexVHP(0);
            for (size_t i = 0; i < 3; ++i)
            {
               tempquad.SetVertexVHP(i, tempquad.GetVertexVHP((i + 1) % 4));
            }
            tempquad.SetVertexVHP(3, last);
               
         }
         
         // Need the mesh center to be somewhere near the actual center of the tris or the object
         // ends up getting collision detected too often
         Vector3 midpoint;
         for (size_t i = 0; i < 4; ++i)
            midpoint += tempquad.GetVertex(i);
         midpoint /= 4.f;
         
         currmesh->Move(currmesh->GetPosition() + Vector3(0, midpoint.y, 0));
         
         currmesh->Add(tempquad);
      }
   }
   
   for (size_t i = 0; i < meshits.size(); ++i)
   {
      Vector3 currpos = meshits[i]->GetPosition();
      currpos.y /= meshits[i]->NumTris() / 2.f;
      meshits[i]->Move(currpos);
   }
   
   
   // This has to happen before generating buffers because OpenGL is not threadsafe, so when the server
   // copies the meshes they cannot have had GenVbo run on them yet
   mapname = fn; // Signal server that the map data is available
   SDL_mutexV(clientmutex);
   if (server)   // Then wait for the server to copy the data before generating buffers
      while (!serverhasmap) SDL_Delay(1);
   SDL_mutexP(clientmutex);
   
#ifndef DEDICATED
   // All meshes added from here on out will not be present on the server
   // Build water object
   float waterminx, waterminy;
   float watermaxx, watermaxy;
   float waterchunksize = 1000.f;
   waterminx = waterminy = -5000.f;
   watermaxx = mapw * tilesize + 5000.f;
   watermaxy = maph * tilesize + 5000.f;
   int numwaterx = (int)(watermaxx - waterminx) / (int)waterchunksize;
   int numwatery = (int)(watermaxy - waterminy) / (int)waterchunksize;
   //logout << numwaterx << "  " << numwatery << endl;
   
   if (watermesh) delete watermesh;
   
   watermesh = new Mesh("models/empty/base", resman);
   watermesh->collide = false;
   
   for (int i = 0; i < numwaterx; ++i)
   {
      for (int j = 0; j < numwatery; ++j)
      {
         Quad tempquad(watermesh->vertheap);
         tempquad.SetVertex(0, Vector3(i * waterchunksize + waterminx, 0, j * waterchunksize + waterminy));
         tempquad.SetVertex(1, Vector3(i * waterchunksize + waterminx, 0, (j + 1) * waterchunksize + waterminy));
         tempquad.SetVertex(2, Vector3((i + 1) * waterchunksize + waterminx, 0, (j + 1) * waterchunksize + waterminy));
         tempquad.SetVertex(3, Vector3((i + 1) * waterchunksize + waterminx, 0, j * waterchunksize + waterminy));
         
         
         floatvec temptc(2, 0.f);
         temptc[0] = (watermaxx - i * waterchunksize) / (watermaxx - waterminx);
         temptc[1] = (watermaxy - j * waterchunksize) / (watermaxy - waterminy);
         tempquad.SetTexCoords(0, 1, temptc);
         temptc[0] = (watermaxx - i * waterchunksize) / (watermaxx - waterminx);
         temptc[1] = (watermaxy - (j + 1) * waterchunksize) / (watermaxy - waterminy);
         tempquad.SetTexCoords(1, 1, temptc);
         temptc[0] = (watermaxx - (i + 1) * waterchunksize) / (watermaxx - waterminx);
         temptc[1] = (watermaxy - (j + 1) * waterchunksize) / (watermaxy - waterminy);
         tempquad.SetTexCoords(2, 1, temptc);
         temptc[0] = (watermaxx - (i + 1) * waterchunksize) / (watermaxx - waterminx);
         temptc[1] = (watermaxy - j * waterchunksize) / (watermaxy - waterminy);
         tempquad.SetTexCoords(3, 1, temptc);
         
         for (int k = 0; k < 4; ++k)
            tempquad.SetNormal(k, Vector3(0, 1, 0));
         Material* watermat = &resman.LoadMaterial(waterfile);
         watermat->SetTexture(0, reflectionfbo.GetTexture());
         watermat->SetTexture(1, noisefbo.GetTexture());
         tempquad.SetMaterial(watermat);
         watermesh->Add(tempquad);
      }
   }
   watermesh->GenVbo();
   
   
   // Generate grass - do this after the server has meshes because it doesn't care about grass, but before
   // generating the KDTree because we definitely want spatial partitioning of grass
   progress->value = 4;
   progtext->text = "Generating grass";
   Repaint();
   IniReader grassnode = mapdata.GetItemByName("GrassData");
   for (size_t i = 0; i < grassnode.NumChildren(); ++i)
   {
      string file, model;
      int grassw, grassh, groupsize = 10;
      float density, gscale = 1.f;
      currnode = grassnode(i);
      float maxtilt = 50.f, mintilt = 25.f;
      
      currnode.Read(file, "File");
      file = fn + file + ".png";
      currnode.Read(model, "Model");
      currnode.Read(groupsize, "GroupSize");
      currnode.Read(density, "Density");
      currnode.Read(maxtilt, "MaxTilt");
      currnode.Read(mintilt, "MinTilt");
      currnode.Read(gscale, "Scale");
      
      SDL_Surface *loadgrass;
   
      loadgrass = IMG_Load(file.c_str());
      if (!loadgrass)
      {
         logout << "Error loading grassmap for file: " << file << endl;
         exit(-1);
      }
      
      grassw = loadgrass->w;
      grassh = loadgrass->h;
      float grasssizex = mapwidth / float(grassw);
      float grasssizey = mapheight / float(grassh);
      float maxperpoint = 100;
      float grassdensity = console.GetFloat("grassdensity");
   
      SDL_LockSurface(loadgrass);
      data = (unsigned char*)loadgrass->pixels;
      
      Mesh basemesh(model, resman); // Don't need GL because this is a temp mesh
      
      logout << "Generating grass" << endl;
      // Iterate over the entire map in groups of groupsize
      for (int x = 0; x < grassw; x += groupsize)
      {
         for (int y = 0; y < grassh; y += groupsize)
         {
            Mesh grassmesh("models/empty/base", resman);
            // Iterate over each group
            for (int ix = 0; ix < groupsize && ix + x < grassw; ++ix)
            {
               for (int iy = 0; iy < groupsize && iy + y < grassh; ++iy)
               {
                  int offset = (y + iy) * grassw + (x + ix);
                  offset *= loadgrass->format->BytesPerPixel;
                  float d = static_cast<float>(data[offset]) / 255.f * density * grassdensity;
                  d *= Random(0, 2.f);
                  int num = static_cast<int>(d);
                  
                  for (int j = 0; j < num; ++j)
                  {
                     float angle = Random(0, 2.f * PI);
                     float dist = Random(0, mapwidth / (float)grassw);
                     float newx = dist * cos(angle) + (x + ix) * grasssizex;
                     float newy = dist * sin(angle) + (y + iy) * grasssizey;
                     Vector3 rots;
                     rots.x = Random(mintilt, maxtilt);
                     rots.y = Random(0, 360);
                     
                     if (newx > 0 && newx < mapwidth && newy > 0 && newy < mapwidth)
                     {
                        Mesh newmesh(basemesh);
                        Vector3 newpos(newx, GetTerrainHeight(newx, newy), newy);
                        newmesh.Scale(sqrt(d / density) * gscale);
                        newmesh.Move(newpos);
                        newmesh.Rotate(rots);
                        newmesh.LoadMaterials();
                        newmesh.AdvanceAnimation();
                        
                        grassmesh.Add(newmesh);
                     }
                  }
               }
            }
            if (grassmesh.NumTris())
            {
               float mx = (x + (float)groupsize / 2.f) * grasssizex;
               float my = (y + (float)groupsize / 2.f) * grasssizey;
               grassmesh.Move(Vector3(mx, 0, my));
               grassmesh.CalcBounds();
               grassmesh.collide = false;
               grassmesh.terrain = true;
               grassmesh.drawdistmult = console.GetFloat("grassdrawdist") / console.GetFloat("viewdist");
               meshes.push_back(grassmesh);
            }
         }
      }
   }
   
   progress->value = 6;
   progtext->text = "Partitioning world";
   Repaint();
   
   // Must be done here so it's available for KDTree creation
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      i->CalcBounds();
   }
   
   // Add objects to kd-tree
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = coldet.worldbounds[0].GetVertex(i);// + Vector3(0, 10, 0);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = coldet.worldbounds[5].GetVertex(i);
   }
   kdtree = ObjectKDTree(&meshes, points);
   logout << "Refining KD-Tree..." << flush;
   kdtree.refine(0);
   logout << "Done\n" << flush;
   
   progress->value = 6;
   progtext->text = "Generating buffers";
   Repaint();
   
   RegenFBOList();
   
   progress->value = 7;
   progtext->text = "Caching meshes";
   Repaint();
   if (console.GetBool("cache") && !editor)
      CacheMeshes();
   
   progress->value = 8;
   progtext->text = "Rendering maps";
   Repaint();
   
   // Render static shadow map
   // Generate FBO to render to the shadow map texture
   int shadowres = console.GetInt("shadowres");
#ifndef DEBUGSMT
   if (!shadowmapfbo.IsValid())
      shadowmapfbo = FBO(shadowres, shadowres, true, &resman.texhand);
   if (!worldshadowmapfbo.IsValid() || worldshadowmapfbo.GetWidth() != shadowres)
      worldshadowmapfbo = FBO(shadowres, shadowres, true, &resman.texhand);
#else
   if (!shadowmapfbo.IsValid())
      shadowmapfbo = FBO(shadowres, shadowres, false, &resman.texhand);
   if (!worldshadowmapfbo.IsValid() || worldshadowmapfbo.GetWidth() != shadowres)
      worldshadowmapfbo = FBO(shadowres, shadowres, false, &resman.texhand);
#endif
   float shadowsize = (int)(mapw > maph ? mapw : maph);
   shadowsize *= tilesize;
   Vector3 center((mapw - 1) / 2.f, 0, (maph - 1) / 2.f);
   center *= tilesize;
   GenShadows(center, shadowsize / 1.4f, worldshadowmapfbo, player[0]);
   resman.texhand.ActiveTexture(7);
   
   resman.texhand.BindTexture(worldshadowmapfbo.GetTexture());
   
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
   
   resman.texhand.ActiveTexture(0);
   
   
   // Render minimap
   minimapfbo = FBO(512, 512, false, &resman.texhand);
   minimapfbo.Bind();
   float minimapheight = 10000.f;
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   glOrtho(-mapwidth / 2.f, mapwidth / 2.f, -mapheight / 2.f, mapheight / 2.f, 10, minimapheight * 2.f);
   GUI* minimaplabel = gui[hud]->GetWidget("minimap");
   float ratio;
   if (mapwidth > mapheight)
   {
      ratio = mapheight / mapwidth;
      minimaplabel->height *= ratio;
   }
   else
   {
      ratio = mapwidth / mapheight;
      minimaplabel->width *= ratio;
   }
   
   glMatrixMode(GL_MODELVIEW);
   Vector3 cam = center;
   cam.y = minimapheight;
   kdtree.setfrustum(cam, Vector3(90, 0, 0), 10, minimapheight * 2.f, 90, 1);
   gluLookAt(cam.x, cam.y, cam.z, center.x, 0, center.z, 0, 0, -1);
   
   glFogf(GL_FOG_START, minimapheight * 2.f);
   glFogf(GL_FOG_END, minimapheight * 2.f);
   
   glViewport(0, 0, 512, 512);
   
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   
   staticdrawdist = true;
   float saveidm = console.GetFloat("impdistmulti");
   console.Parse("set impdistmulti 10000", false);
   lights.Place();
   RenderObjects(player[0]);
   UpdateNoise();
   UpdateReflection(player[0]);
   minimapfbo.Bind();
   glViewport(0, 0, 512, 512);
   RenderWater();
   console.Parse("set impdistmulti " + ToString(saveidm), false);
   staticdrawdist = false;
   int viewdist = console.GetInt("viewdist");
   glFogf(GL_FOG_START, float(viewdist) * .5f);
   glFogf(GL_FOG_END, float(viewdist));
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   
   glViewport(0, 0, console.GetInt("screenwidth"), console.GetInt("screenheight"));
   minimapfbo.Unbind();
   
   // Signal the net thread that we can sync now
   needsync = true;
#endif
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


// Currently this doesn't work well, so TBD whether it will go back in
Vector3 ChooseNormal(const Vector3& actual, const Vector3& smooth)
{
   /*
   float cliffcutoff = .5f;
   Vector3 retval = smooth;
   if (actual.distance(smooth) > .6f)
   {
      retval += actual * 2.f;
      retval.normalize();
      return retval;
   }
   */
   return smooth;
}
