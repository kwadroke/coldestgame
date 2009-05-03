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
// Copyright 2008, 2009 Ben Nemec
// @End License@


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


GLuint TextureManager::LoadTexture(string filename, bool mipmap)
{
   if (filename == "") return 0;
   
   if (loaded.find(filename) == loaded.end())
   {
      GLuint texnum;
      bool alpha;
      glGenTextures(1, &texnum);
      texhand->LoadTexture(filename, texnum, mipmap, &alpha);
      texnames[filename] = texnum;
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
