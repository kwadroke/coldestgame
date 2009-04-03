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


#ifndef __RESOURCEMANAGER_H
#define __RESOURCEMANAGER_H

#include <list>
#include <map>
#include "Material.h"
#include "TextureManager.h"
#include "Shader.h"
#ifndef DEDICATED
#include "SoundManager.h"
#endif

using std::map;
using std::string;

class ResourceManager
{
   public:
      ResourceManager();
      Material& LoadMaterial(string);
      void AddMaterial(string, Material);
      void LoadTexture(string);
      void ReleaseAll();
      
#ifndef DEDICATED
      // Do not reorder these, texhand needs to come before texman
      TextureHandler texhand;
      TextureManager texman;
      Shader shaderman;
      SoundManager soundman;
#endif
      
   private:
      map<string, Material> materials;
#ifdef DEDICATED
      Material dummymat;
#endif
};

#endif

