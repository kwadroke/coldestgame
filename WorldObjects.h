#ifndef __WORLDOBJECTS
#define __WORLDOBJECTS

#define NO_SDL_GLEXT
#include <GL/glew.h>
#include "WorldPrimitives.h"
#include "DynamicObject.h"
#include "FBO.h"
#include "Shader.h"
#include "TextureHandler.h"
#include "SDL_opengl.h"
#include "SDL.h"

#define FBODIM 512

class WorldObjects     // Define objects in the world
{
   public:
      WorldObjects();
      ~WorldObjects();
      WorldObjects(const WorldObjects&);
      WorldObjects& operator=(const WorldObjects&);
      bool operator<(const WorldObjects&) const;
      bool operator>(const WorldObjects&) const;
      void GenVbo(Shader*);
      void RenderVbo(int, int);
      void RenderVbo();
      void BindVbo();
      void UnbindVbo();
      void GenFbo(TextureHandler*);
      void RenderList();
      void SetHeightAndWidth();
      
      string type;
      
      int texnum, texnum1, texnum2;
      //int firstprim;
      
      float x, y, z;   // Translation of object
      float rotation, pitch, roll;
      float size;
      float height, width;
      float impdist;
      vector<WorldPrimitives> prims;
      vector<WorldPrimitives> tprims; // Translucent primitives
      // Variables for impostoring
      FBO impostorfbo;
      GLuint imptex;
      GLuint vbo;
      int normstart, colorstart, attstart, att1start, tcstart[6]; // VBO offsets
      vector<int> vbocount;
      
      list<DynamicObject>::iterator dynobj;
      Uint32 lastimpupdate;
      bool hasfbo, hasvbo;
      float dist;
      bool dlcurrent;
      GLuint displaylist;
      
   private:
      int vbosize;
      static int numobjs;
      Shader* shaderhand;
      
      /* The following list only exists to give the dynobj iterator something to point to by default,
         since a default constructed iterator is singular which means that many operations
         (specifically copying) have undefined behavior.
      */
      list<DynamicObject> dummydolist;

};

#endif
