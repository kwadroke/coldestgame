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
   if (filename == "") return 0;
   
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


void TextureManager::DeleteTexture(string filename, bool gldelete)
{
   if (loaded.find(filename) != loaded.end())
   {
      if (gldelete)
         glDeleteTextures(1, &texnames[filename]);
      texnames.erase(filename);
      loaded.erase(filename);
   }
}


void TextureManager::Clear()
{
   loaded.clear();
   
   for (map<string, GLuint>::iterator i = texnames.begin(); i != texnames.end(); ++i)
   {
      glDeleteTextures(1, &(i->second));
   }
   texnames.clear();
}
