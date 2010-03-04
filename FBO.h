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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __FBO_H
#define __FBO_H

#include "glinc.h"
#include <iostream>
#include "TextureHandler.h"

class FBO
{
   public:
      FBO();
      FBO(const FBO&);
      FBO(int, int, bool, TextureHandler*);
      ~FBO();
      FBO& operator=(const FBO&);
      
      void Bind();
      void Unbind();
      GLuint GetTexture();
      int GetWidth();
      int GetHeight();
      bool IsValid();
   
   private:
      void init();
      
      GLuint texture;
      GLuint fboid;
      GLuint tex[2];
      GLuint depthbuffer;
      bool depth;
      int width, height;
      TextureHandler* texhand;
      bool valid;
};

#endif
