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


#include "TextureHandler.h"

using std::endl;

TextureHandler::TextureHandler() : af(1.f)
{
   for (int i = 0; i < 8; ++i)
   {
      boundtex[i] = 0;
      bound[i] = false;
   }
   curractive = 0;
   dummytex = 0;
}

/* Takes the name of the image, the OpenGL texture id to store it in, and a bool to
   determine whether the texture should be mipmapped.
   
   Returns whether the image had an alpha channel in the alpha parameter
   */
void TextureHandler::LoadTexture(string filename, GLuint texnum, bool mipmap, bool* alpha)
{
   SDL_Surface *loadtex;
   
   BindTexture(texnum);
   SetTextureParams(mipmap);
   loadtex = IMG_Load(filename.c_str());
   if (!loadtex)
   {
      logout << "Error loading texture: " << filename << endl;
      return;
   }
   SDL_LockSurface(loadtex);
   
   if (loadtex->format->BytesPerPixel == 3)
   {
      *alpha = false;
      if (mipmap)
         gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, loadtex->w, loadtex->h, GL_RGB, GL_UNSIGNED_BYTE, loadtex->pixels);
      else
         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, loadtex->w, loadtex->h, 0, GL_RGB, GL_UNSIGNED_BYTE, loadtex->pixels);
   }
   else
   {
      *alpha = true;
      if (mipmap)
         gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, loadtex->w, loadtex->h, GL_RGBA, GL_UNSIGNED_BYTE, loadtex->pixels);
      else
         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, loadtex->w, loadtex->h, 0, GL_RGBA, GL_UNSIGNED_BYTE, loadtex->pixels);
   }
   
   SDL_FreeSurface(loadtex);
}


void TextureHandler::BindTexture(GLuint texnum)
{
   if (texnum == 0) return;
   if (texnum != boundtex[curractive] || !bound[curractive])
   {
      bound[curractive] = true;
      boundtex[curractive] = texnum;
      glBindTexture(GL_TEXTURE_2D, texnum);
      ++binds;
   }
}


// The same as the above, except it allows us to force texture lookups to behave a certain way
void TextureHandler::BindTextureDebug(GLuint texnum)
{
   bool debug = false;
   if (!dummytex && debug)
   {
      bool b;
      glGenTextures(1, &dummytex);
      LoadTexture("textures/dummy.png", dummytex, true, &b);
   }
   
   if (debug)
      texnum = dummytex;
   //bound[curractive] = false;
   
   if (texnum == 0) return;
   if (texnum != boundtex[curractive] || !bound[curractive])
   {
      bound[curractive] = true;
      boundtex[curractive] = texnum;
      glBindTexture(GL_TEXTURE_2D, texnum);
      ++binds;
   }
}


void TextureHandler::ActiveTexture(int num)
{
   if (curractive != num)
   {
      switch (num)
      {
         case 0:
            glActiveTextureARB(GL_TEXTURE0_ARB);
            break;
         case 1:
            glActiveTextureARB(GL_TEXTURE1_ARB);
            break;
         case 2:
            glActiveTextureARB(GL_TEXTURE2_ARB);
            break;
         case 3:
            glActiveTextureARB(GL_TEXTURE3_ARB);
            break;
         case 4:
            glActiveTextureARB(GL_TEXTURE4_ARB);
            break;
         case 5:
            glActiveTextureARB(GL_TEXTURE5_ARB);
            break;
         case 6:
            glActiveTextureARB(GL_TEXTURE6_ARB);
            break;
         case 7:
            glActiveTextureARB(GL_TEXTURE7_ARB);
            break;
         default:
            logout << "Warning: Attempting to activate invalid texture" << endl;
            break;
      }
      curractive = num;
   }
}


void TextureHandler::ForgetCurrent()
{
   for (int i = 0; i < 8; ++i)
      bound[i] = false;
}


void TextureHandler::SetTextureParams(bool mipmap)
{
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   if (mipmap)
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
   else
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
   glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, af);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
}

