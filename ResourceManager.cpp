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


#include "ResourceManager.h"

#ifndef DEDICATED
ResourceManager::ResourceManager() : texhand(), texman(&texhand)
{
}
#else
ResourceManager::ResourceManager(){}
#endif


Material& ResourceManager::LoadMaterial(string filename)
{
#ifndef DEDICATED
   if (materials.find(filename) == materials.end())
   {
      Material newmat(filename, texman, shaderman);
      materials.insert(make_pair(filename, newmat));
   }
   return materials.find(filename)->second;
#else
   return dummymat;
#endif
}


void ResourceManager::AddMaterial(string filename, Material newmat)
{
#ifndef DEDICATED
   if (materials.find(filename) == materials.end())
      materials.insert(make_pair(filename, newmat));
#endif
}


void ResourceManager::LoadTexture(string filename)
{
#ifndef DEDICATED
   texman.LoadTexture(filename);
#endif
}


// Note: At this time you must call InitShaders and LoadMaterials again after calling this
void ResourceManager::ReleaseAll()
{
#ifndef DEDICATED
   map<string, Material>::iterator i;
   for (i = materials.begin(); i != materials.end(); ++i)
      i->second.Release();
   materials.clear();
   texhand.ForgetCurrent();
   shaderman.ReloadAll(false);
#endif
}

