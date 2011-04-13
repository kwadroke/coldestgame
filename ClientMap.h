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
      virtual void Keepalive();
      
      ProgressBar* progress;
      GUI* progtext;
      GUI* progname;
      map<set<GLuint>, Material*> texmats;
};

#endif // CLIENTMAP_H
