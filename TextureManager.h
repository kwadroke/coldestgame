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


#ifndef __TEXTURE_MANAGER_H
#define __TEXTURE_MANAGER_H

#include "TextureHandler.h"
#include "glinc.h"
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
      GLuint LoadTexture(string, bool mipmap = true);
      void BindTexture(string);
      void DeleteTexture(string, bool gldelete = true);
      void Clear();
      
      TextureHandler* texhand;
      
   private:
      map<string, GLuint> texnames;
      set<string> loaded;
};

#endif
