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


#include "MeshCache.h"

MeshCache::MeshCache(ResourceManager& rm) : resman(rm)
{
   mutex = SDL_CreateMutex();
}


MeshCache::~MeshCache()
{
   SDL_DestroyMutex(mutex);
}


Mesh MeshCache::GetMesh(string filename)
{
   EnsureBase(filename);
   
   SDL_mutexP(mutex);
   
   if (meshes.find(filename) == meshes.end())
   {
      meshes[filename] = MeshPtr(new Mesh(filename, resman));
   }
   
   MeshPtr retval = meshes[filename];
   
   SDL_mutexV(mutex);
   retval->animtimer.start();
   return *retval;
}


MeshPtr MeshCache::GetNewMesh(string filename)
{
   EnsureBase(filename);
   
   SDL_mutexP(mutex);
   
   if (meshes.find(filename) == meshes.end())
   {
      meshes[filename] = MeshPtr(new Mesh(filename, resman));
   }
   
   MeshPtr retval = MeshPtr(new Mesh(*meshes[filename]));
   
   SDL_mutexV(mutex);
   retval->animtimer.start();
   return retval;
}


void MeshCache::EnsureBase(string& filename)
{
   if (filename.substr(filename.length() - 4) != "base" || filename == "models/base")
   {
      if (filename.substr(filename.length() - 1) != "/")
         filename += "/base";
      else
         filename += "base";
   }
}
