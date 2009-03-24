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

#ifndef __TEXTUREHANDLER
#define __TEXTUREHANDLER

#include "glinc.h"
#include <string>
#include <iostream>
#include "SDL.h"
#include "SDL_image.h"
#include "logout.h"

using namespace std;

class TextureHandler
{
   public:
      TextureHandler();
      void LoadTexture(string, GLuint, bool, bool*);
      void BindTexture(GLuint);
      void BindTextureDebug(GLuint);
      void ActiveTexture(int);
      void ForgetCurrent();
      int binds; // Counts how many times glBindTexture is actually called
      float af;
      
   private:
      void SetTextureParams(bool);
      GLuint boundtex[8];
      bool bound[8];
      int curractive;
      GLuint dummytex;
};

#endif
