#ifndef __MATERIAL_H
#define __MATERIAL_H

#include "glinc.h"
#include <vector>
#include <string>
#include "TextureManager.h"
#include "types.h"
#include "IniReader.h"
#include "Shader.h"
#include <boost/shared_ptr.hpp>

using std::vector;
using std::string;
using boost::shared_ptr;

class Material
{
   public:
#ifndef DEDICATED
      Material(string, TextureManager&, Shader&);
#else
      Material();
#endif
      void Use() const;
      void UseTextureOnly() const;
      void SetTexture(int, GLuint);
      GLuint GetTexture(int);
      bool operator<(const Material&) const;
      void Release();
      
      floatvec diffuse;
      floatvec ambient;
      floatvec specular;
      float shininess;
      
   private:
      vector<GLuint> texid;
      vector<string> texfilename;
      string shader;
#ifndef DEDICATED
      TextureManager& texman;
      Shader& shaderhand;
#endif
      int id;
      static int nummats;
      bool cullface, doalphatest, alphatocoverage, additive, depthtest, depthwrite;
      float alphatest;
};

typedef shared_ptr<Material> MaterialPtr;

#endif

