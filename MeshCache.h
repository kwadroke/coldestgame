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
