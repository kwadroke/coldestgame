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

