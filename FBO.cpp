#include "FBO.h"

// Note: the FBO is not ready for use after running this constructor
FBO::FBO()
{
   valid = false;
}


// depth indicates whether color rendering should be enabled - primarily intended for shadow maps
FBO::FBO(int widthin, int heightin, bool depthin, TextureHandler *texhandin)
{
   //cout << "Called constructor\n";
   width = widthin;
   height = heightin;
   depth = depthin;
   texhand = texhandin;
   init();
}


FBO::~FBO()
{
   //cout << "Called destructor\n";
   if (!valid) return;
   glDeleteTextures(2, tex);
   glDeleteFramebuffersEXT(1, &fboid);
   if (depth)
      glDeleteRenderbuffersEXT(1, &depthbuffer);
}


FBO::FBO(const FBO &f)
{
   //cout << "Called copy constructor\n";
   width = f.width;
   height = f.height;
   depth = f.depth;
   texhand = f.texhand;
   init();
}


FBO& FBO::operator=(const FBO &f)
{
   if (this == &f) return *this;
   
   //cout << "Called operator=\n";
   width = f.width;
   height = f.height;
   depth = f.depth;
   texhand = f.texhand;
   init();
}


void FBO::init()
{
   glGenFramebuffersEXT(1, &fboid);
   cout << "Creating framebuffer object " << fboid << endl;
   glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboid);
   
   glGenTextures(2, tex);
   
   texhand->BindTexture(tex[0]);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
      
   glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, tex[0], 0);
   
   if (!depth) // Just attach a generic depth buffer
   {
      glGenRenderbuffersEXT(1, &depthbuffer);
      glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer);
      glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, width, height);
      glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer);
      texture = tex[0];
   }
   else // Attach a depth texture so we can use it
   {
      texhand->BindTexture(tex[1]);
      glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, width, height, 0,
                  GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, NULL);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
   
      glDrawBuffer(GL_NONE);
      glReadBuffer(GL_NONE);
      glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_TEXTURE_2D, tex[1], 0);
      texture = tex[1];
   }
   
   if (glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) != GL_FRAMEBUFFER_COMPLETE_EXT)
      cout << "Failed to create framebuffer.\n" << hex << glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) << endl;
   
   glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
   valid = true;
}


GLuint FBO::GetTexture()
{
   return texture;
}


void FBO::Bind()
{
   if (!valid)
   {
      cout << "Warning: Attempted to bind invalid framebuffer object" << endl;
      return;
   }
   glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboid);
}


void FBO::Unbind()
{
   glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
}
