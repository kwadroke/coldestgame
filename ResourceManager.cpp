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


// Note: Doesn't actually release shaders at the moment.
void ResourceManager::ReleaseAll()
{
   materials.clear();
   texman.Clear();
   texhand.ForgetCurrent();
}

