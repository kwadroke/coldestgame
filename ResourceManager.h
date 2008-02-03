#ifndef __RESOURCEMANAGER_H
#define __RESOURCEMANAGER_H

#include <list>
#include <map>
#include "Material.h"
#include "TextureManager.h"
#include "Shader.h"

using std::map;
using std::string;

class ResourceManager
{
   public:
      ResourceManager();
      Material& LoadMaterial(string);
      void LoadTexture(string);
      void ReleaseAll();
      
      // Do not reorder these, texhand needs to come before texman
      TextureHandler texhand;
      TextureManager texman;
      Shader shaderman;
      
   private:
      map<string, Material> materials;
};

#endif

