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
   retval->lastanimtick = SDL_GetTicks();
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
   retval->lastanimtick = SDL_GetTicks();
   return retval;
}


void MeshCache::EnsureBase(string& filename)
{
   if (filename.substr(filename.length() - 4) != "base")
   {
      if (filename.substr(filename.length() - 1) != "/")
         filename += "/base";
      else
         filename += "base";
   }
}
