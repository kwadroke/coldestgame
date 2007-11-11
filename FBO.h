#ifndef __FBO_H
#define __FBO_H

#define NO_SDL_GLEXT
#include <iostream>
#include "TextureHandler.h"
#include <GL/glew.h>
#include "SDL_opengl.h"

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
