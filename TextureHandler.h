#ifndef __TEXTUREHANDLER
#define __TEXTUREHANDLER

#define NO_SDL_GLEXT
#include <string>
#include <iostream>
#include <GL/glew.h>
#include "SDL_opengl.h"
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
      void SetTextureParams();
      GLuint boundtex[8];
      bool bound[8];
      int curractive;
      GLuint dummytex;
};

#endif
