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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __MESHCACHE_H
#define __MESHCACHE_H

#include <map>
#include <boost/shared_ptr.hpp>
#include "Mesh.h"

using std::map;
using boost::shared_ptr;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class MeshCache
{
   public:
      MeshCache(ResourceManager&);
      ~MeshCache();
      Mesh GetMesh(string);
      MeshPtr GetNewMesh(string);
      
   private:
      MeshCache(const MeshCache&); // I don't feel like dealing with this, and it isn't necessary
      MeshCache& operator=(const MeshCache&);
      void EnsureBase(string&);
      
      map<string, MeshPtr> meshes;
      ResourceManager& resman;
      SDL_mutex* mutex;
   
};

typedef shared_ptr<MeshCache> MeshCachePtr;

#endif
