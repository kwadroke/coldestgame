#include "ResourceManager.h"

ResourceManager::ResourceManager() : texhand(), texman(&texhand)
{
}


Material& ResourceManager::LoadMaterial(string filename)
{
   if (materials.find(filename) == materials.end())
   {
      Material newmat(filename, texman, shaderman);
      materials.insert(make_pair(filename, newmat));
   }
   return materials.find(filename)->second;
}


void ResourceManager::LoadTexture(string filename)
{
   texman.LoadTexture(filename);
}


// Note: At this time you must call InitShaders and LoadMaterials again after calling this
void ResourceManager::ReleaseAll()
{
   map<string, Material>::iterator i;
   for (i = materials.begin(); i != materials.end(); ++i)
      i->second.Release();
   materials.clear();
   texhand.ForgetCurrent();
   shaderman.ReloadAll(false);
}

