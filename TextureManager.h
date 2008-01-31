#ifndef __TEXTURE_MANAGER_H
#define __TEXTURE_MANAGER_H

#include "TextureHandler.h"
#include <SDL_opengl.h>
#include <map>
#include <set>

using std::map;
using std::set;
using std::make_pair;

class TextureManager
{
   public:
      TextureManager(TextureHandler* th = NULL);
      ~TextureManager();
      GLuint LoadTexture(string);
      void BindTexture(string);
      void DeleteTexture(string, bool gldelete = true);
      
      TextureHandler* texhand;
      
   private:
      map<string, GLuint> texnames;
      set<string> loaded;
};

#endif
