#ifndef CLIENTMAP_H
#define CLIENTMAP_H

#include "Map.h"
#include "gui/ProgressBar.h"
#include <string>

class ClientMap : public Map
{
   public:
      ClientMap(const string&);
      
   protected:
      virtual void Finish();
      virtual void InitGui(const string&);
      virtual void SetProgress(const string&, const int);
      virtual void LoadLight();
      virtual void ResetGlobals();
      virtual void ReadMisc();
      virtual void ReadTerrParams();
      virtual void CalcMapTextures();
      virtual void SetTerrainTextures(int, int, Quad&);
      virtual void ReadSpawnPointsExtra();
      virtual void LoadObjects();
      virtual void LoadWater();
      virtual void CreateGrass();
      virtual void GenerateKDTree();
      virtual void GenBuffers();
      virtual void CreateShadowmap();
      virtual void CreateMinimap();
      
      ProgressBar* progress;
      GUI* progtext;
      GUI* progname;
};

#endif // CLIENTMAP_H
