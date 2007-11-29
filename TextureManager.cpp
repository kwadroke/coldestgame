#include "TextureManager.h"

TextureManager::TextureManager(TextureHandler* th)
{
   texhand = th;
}


TextureManager::~TextureManager()
{
   map<string, GLuint>::iterator i;
   //for (i = texnames.begin(); i != texnames.end(); ++i)
      //glDeleteTextures(   Not sure on the syntax of the map object
}


GLuint TextureManager::LoadTexture(string filename)
{
   if (loaded.find(filename) == loaded.end())
   {
      GLuint texnum;
      bool alpha;
      glGenTextures(1, &texnum);
      texhand->LoadTexture(filename, texnum, true, &alpha);
      texnames.insert(make_pair(filename, texnum));
      loaded.insert(filename);
      return texnum;
   }
   return(texnames[filename]);
}


void TextureManager::BindTexture(string filename)
{
   texhand->BindTexture(texnames[filename]);
}
