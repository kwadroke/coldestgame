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
// Copyright 2008-2012 Ben Nemec
// @End License@
#ifndef MAP_H
#define MAP_H

#include "types.h"
#include "gui/ProgressBar.h"
#include "NTreeReader.h"
#include "Quad.h"
#include "Mesh.h"
#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>


using std::string;
using std::vector;

struct TerrainParams
{
   string file;
   int texture;
   float minheight, maxheight;
   float minslope, maxslope;
   float minrand, maxrand;
   float blend;
};

class Map
{
   public:
      Map(){}
      Map(const string&);
      void Load();
      string MapName() {return mapname;}
      string DataName() {return dataname;}
      string PathName() {return dataname.substr(0, dataname.length() - 4) + ".path";}
      vector<SpawnPointData> SpawnPoints() {return spawnpoints;}
      SpawnPointData SpawnPoints(const size_t i) {return spawnpoints[i];}
      Quad& WorldBounds(const int i) {return worldbounds[i];}
      size_t Width();
      size_t Height();
      size_t MaxHeight() {return worldbounds[0].GetVertex(0).y;}
      float PathNodeSize() {return pathnodesize;}
      float PathNodeCheckDist() {return pathnodecheckdist;}
      float BotCheckDist() {return botcheckdist;}

   protected:
      void Init(const string&);
      void ReadBasics();
      virtual void Finish(){}
      virtual void InitGui(const string&){}
      virtual void LoadLight(){}
      virtual void ResetGlobals(){}
      virtual void ReadMisc(){}
      virtual void ReadTerrParams(){}
      virtual void CalcMapTextures(){}
      void ReadSpawnPoints();
      virtual void ReadSpawnPointsExtra(){}
      virtual void LoadObjects();
      virtual void SetProgress(const string& text, const int step) { (void)text; (void)step; }
      void LoadMapData();
      virtual void SetTerrainTextures(int x, int y, Quad&) { (void)x; (void)y; }
      void BuildTerrain();

      Vector3 GetTerrainNormal(int, int, int, int);
      float GetSmoothedTerrain(int, int, int, int, vector< floatvec >&);
      virtual void Keepalive(){}
      virtual void LoadWater(){}
      virtual void CreateGrass(){}
      virtual void GenerateKDTree();
      virtual void GenBuffers(){}
      void CreateCache();
      virtual void CreateShadowmap(){}
      virtual void CreateMinimap(){}
      Vector3 ChooseNormal(const Vector3&, const Vector3&);

      NTreeReader mapdata;
      Meshlist* mapmeshes;

      int numtextures;
      int numobjects;
      int mapw, maph;
      int maxterrainparams;
      int terrainstretch;
      float zeroheight;
      float heightscale;
      float pathnodesize;
      float pathnodecheckdist;
      float botcheckdist;

      string base;
      string mapname;
      string dataname;
      string heightmapname;
      string lightmapname;
      string waterfile;

      Vector3 center;

      // TODO These should all be cleared after loading is complete
      vector<floatvec> maparray;  // Heightmap data scaled by heightscale
      vector<Vector3vec> lightmap; // Terrain lightmap
      vector<TerrainParams> terrparams; // Parameters that determine how we texture terrain
      vector<Vector3vec> normals;
      vector<gluintvec> tex1;
      vector<gluintvec> tex2;
      vector<floatvec> texpercent;
      // These should not
      vector<SpawnPointData> spawnpoints;
      vector<Quad> worldbounds;
};

typedef boost::shared_ptr<Map> MapPtr;

#endif // MAP_H
