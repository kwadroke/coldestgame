#include "ClientMap.h"
#include "globals.h"
#include "editor.h"

ClientMap::ClientMap(const string& mn)
{
   mapmeshes = &meshes;
   Init(mn);
}


// This is mostly to ensure that I don't miss anything while moving code in here
#define meshes ERROR DO NOT USE THIS DIRECTLY
#define servermeshes ERROR DO NOT USE THIS DIRECTLY

void ClientMap::Finish()
{
   ShowGUI(loadoutmenu);
}


void ClientMap::InitGui(const string& mn)
{
   ShowGUI(loadprogress);
   progress = (ProgressBar*)gui[loadprogress]->GetWidget("loadprogressbar");
   progtext = gui[loadprogress]->GetWidget("progresstext");
   progname = gui[loadprogress]->GetWidget("loadname");
   progname->text = "Loading " + mn;
   progress->SetRange(0, 7);
   progress->value = 0;
}


void ClientMap::SetProgress(const string& text, const int step)
{
   progtext->text = text;
   progress->value = step;
   Repaint();
}


// Read global lighting information
void ClientMap::LoadLight()
{
   lights.Clear();
   lights.Add();
   
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
   
   lights.SetDir(0, Vector3(fromx, fromy, fromz));
   lights.SetDiffuse(0, diff);
   lights.SetSpecular(0, spec);
   lights.SetAmbient(0, amb);
}


// Release any previously allocated resources so we don't leak memory
void ClientMap::ResetGlobals()
{
   mapmeshes->clear();
   items.clear();
   spawnpoints.clear();
   resman.ReleaseAll();
   InitShaders();
   LoadMaterials();
   particlemesh = MeshPtr();  // Otherwise we may try to render it later and that will be bad
   particles.clear();
   for (size_t i = 0; i < numbodyparts; ++i) // We deleted all the meshes, so we need to clear these iterators
   {
      player[0].mesh[i] = mapmeshes->end();
   }
   player[0].spawned = false;
   player[0].team = 0;
   PlayerData local = player[0];
   player.clear();
   player.push_back(local);
   ResetKeys();
}


// Various map parameters that we need to read but don't take much processing
void ClientMap::ReadMisc()
{
   string readskybox;
   mapdata.Read(readskybox, "SkyBox");
   skyboxmat = &resman.LoadMaterial(readskybox);
   
   float fogcol[3] = {.5f, .5f, .5f};
   mapdata.Read(fogcol[0], "FogColor", 0);
   mapdata.Read(fogcol[1], "FogColor", 1);
   mapdata.Read(fogcol[2], "FogColor", 2);
   glFogfv(GL_FOG_COLOR, fogcol);
   
   mapdata.Read(waterfile, "Water");
}


// Terrain parameters that determine how we texture
void ClientMap::ReadTerrParams()
{
   TerrainParams dummytp;
   string nodename;
   string terrainmaterial;
   mapdata.Read(terrainmaterial, "TerrainMaterial");
   NTreeReader texnode = mapdata.GetItemByName("TerrainParams");
   maxterrainparams = texnode.NumChildren();
   for (int i = 0; i < maxterrainparams; ++i)
   {
      terrparams.push_back(dummytp);
      const NTreeReader& currnode = texnode(i);
      
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
}


void ClientMap::CalcMapTextures()
{
   floatvec texweights(6, 0.f); // Can be increased, but will require a number of other changes
   int textouse[2];
   float currweights[2];
   
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
}


// Sets up the material for the quad at x, y
void ClientMap::SetTerrainTextures(int x, int y, Quad& tempquad)
{
   map<set<GLuint>, Material*> texmats;
   
   set<GLuint> currtex;
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
         for (set<GLuint>::iterator i = currtex.begin(); i != currtex.end(); ++i)
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
   for (set<GLuint>::iterator i = currtex.begin(); i != currtex.end(); ++i)
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
}


void ClientMap::ReadSpawnPointsExtra()
{
   if (editor)
   {
      NTreeReader spawnnode = mapdata.GetItemByName("SpawnPoints");
      
      for (size_t i = 0; i < spawnnode.NumChildren(); ++i)
      {
         Vector3 position;
         spawnnode.Read(position.x, "Location", 0);
         spawnnode.Read(position.y, "Location", 1);
         spawnnode.Read(position.z, "Location", 2);
         MeshPtr newmesh = meshcache->GetNewMesh("models/base/base");
         newmesh->dynamic = true;
         newmesh->Move(position);
         newmesh->Update();
         mapmeshes->push_back(*newmesh);
         spawnmeshes.push_back(&mapmeshes->back());
      }
   }
}


void ClientMap::LoadObjects()
{
   NTreeReader objectlist = mapdata.GetItemByName("Objects");
   string currmaterial;
   for (size_t i = 0; i < objectlist.NumChildren(); ++i)
   {
      const NTreeReader& currnode = objectlist(i);
      Mesh currmesh(currnode, resman);
      if (!editor)
         currmesh.dynamic = false;
      mapmeshes->push_back(currmesh);
      if (editor)
      {
         string type;
         currnode.Read(type, "Type");
         if (type == "proctree")
         {
            ProceduralTree t;
            t.ReadParams(currnode);
            t.mesh = &mapmeshes->back();
            treemap[&mapmeshes->back()] = t;
         }
      }
      Keepalive();
   }
}


void ClientMap::LoadWater()
{
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
   
   watermesh = new Mesh(NTreeReader("models/empty/base"), resman);
   watermesh->collide = false;
   watermesh->dynamic = false;
   
   for (int i = 0; i < numwaterx; ++i)
   {
      for (int j = 0; j < numwatery; ++j)
      {
         Quad tempquad;
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
   watermesh->Update();
   Keepalive();
}


// Generate grass - do this after the server has meshes because it doesn't care about grass, but before
// generating the KDTree because we definitely want spatial partitioning of grass
void ClientMap::CreateGrass()
{
   NTreeReader grassnode = mapdata.GetItemByName("GrassData");
   size_t grasstris = 0;
   for (size_t i = 0; i < grassnode.NumChildren(); ++i)
   {
      string file, model;
      int grassw, grassh, groupsize = 10;
      float density, gscale = 1.f;
      const NTreeReader& currnode = grassnode(i);
      float maxtilt = 50.f, mintilt = 25.f;
      
      currnode.Read(file, "File");
      file = base + file + ".png";
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
      //float maxperpoint = 100;   unused
      float grassdensity = console.GetFloat("grassdensity");
      
      SDL_LockSurface(loadgrass);
      unsigned char* data = (unsigned char*)loadgrass->pixels;
      
      Mesh basemesh(model, resman);
      
      logout << "Generating grass" << endl;
      // Iterate over the entire map in groups of groupsize
      for (int x = 0; x < grassw; x += groupsize)
      {
         for (int y = 0; y < grassh; y += groupsize)
         {
            Mesh grassmesh = meshcache->GetMesh("models/empty");
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
                        newmesh.EnsureMaterials();
                        newmesh.Update();
                        
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
               grassmesh.Update();
               grassmesh.collide = false;
               grassmesh.terrain = true;
               grassmesh.dynamic = false;
               grassmesh.drawdistmult = console.GetFloat("grassdrawdist") / console.GetFloat("viewdist");
               mapmeshes->push_back(grassmesh);
               grasstris += grassmesh.NumTris();
            }
            Keepalive();
         }
      }
   }
   logout << "Generated " << grasstris << " grass tris\n";
}


void ClientMap::GenerateKDTree()
{
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
   kdtree = ObjectKDTree(mapmeshes, points);
   logout << "Refining KD-Tree..." << std::flush;
   kdtree.refine(0);
   Keepalive();
   logout << "Done" << endl;
}


void ClientMap::GenBuffers()
{
   RegenFBOList();
}


// Render static shadow map
void ClientMap::CreateShadowmap()
{
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
   center = Vector3((mapw - 1) / 2.f, 0, (maph - 1) / 2.f);
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
   Keepalive();
}


// Render minimap
void ClientMap::CreateMinimap()
{
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
   glLoadIdentity();
   PlayerData fake = player[0];
   fake.pos = center;
   fake.pos.y = minimapheight;
   fake.pitch = 89.99f;
   fake.rotation = 0;
   fake.facing = 0;
   
   glFogf(GL_FOG_START, minimapheight * 2.f);
   glFogf(GL_FOG_END, minimapheight * 2.f);
   
   glViewport(0, 0, 512, 512);
   
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   
   staticdrawdist = true;
   float saveidm = console.GetFloat("impdistmulti");
   float saveviewdist = console.GetFloat("viewdist");
   console.Parse("set impdistmulti 10000", false);
   console.Parse("set viewdist " + ToString(minimapheight * 2.f), false);
   
   SetMainCamera(fake);
   lights.Place();
   RenderObjects(fake);
   UpdateNoise();
   UpdateReflection(fake);
   minimapfbo.Bind();
   glViewport(0, 0, 512, 512);
   RenderWater();
   console.Parse("set impdistmulti " + ToString(saveidm), false);
   console.Parse("set viewdist " + ToString(saveviewdist), false);
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
   Keepalive();
}


