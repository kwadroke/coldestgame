#ifndef __TEXTUREHANDLER
#define __TEXTUREHANDLER

#include "glinc.h"
#include <string>
#include <iostream>
#include "SDL.h"
#include "SDL_image.h"

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
