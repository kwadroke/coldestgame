#ifndef MAP_H
#define MAP_H

#include "types.h"
#include "gui/ProgressBar.h"
#include "NTreeReader.h"
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
      Map(const string&);
      void ClientLoad();

      tsint waitingforserver;

   private:
      void Load(const string&);
      void LoadLight();
      void ResetGlobals();
      void ReadMisc();
      void ReadTerrParams();
      void ReadSpawnPoints();
      void LoadObjects();
      void SetProgress(const string& text, const int step);
      void LoadMapData();
      void BuildTerrain();

      Vector3 GetTerrainNormal(int, int, int, int);
      float GetSmoothedTerrain(int, int, int, int, vector< floatvec >&);
      void Keepalive();
      void LoadWater();
      void CreateGrass();
      void GenerateKDTree();
      void CreateCache();
      void CreateShadowmap();
      void CreateMinimap();

      NTreeReader mapdata;

      int numtextures;
      int numobjects;
      int mapw, maph;
      int maxterrainparams;
      int terrainstretch;
      float zeroheight;
      float heightscale;

      string mapname;
      string dataname;
      string heightmapname;
      string lightmapname;
      string waterfile;

      vector<floatvec> maparray;  // Heightmap data scaled by heightscale
      vector<Vector3vec> lightmap; // Terrain lightmap
      vector<TerrainParams> terrparams; // Parameters that determine how we texture terrain

#ifndef DEDICATED
      ProgressBar* progress;
      GUI* progtext;
      GUI* progname;
#endif
};

typedef boost::shared_ptr<Map> MapPtr;

#endif // MAP_H
