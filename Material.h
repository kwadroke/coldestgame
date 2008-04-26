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
      Material(string, TextureManager&, Shader&);
      void Use() const;
      void UseTextureOnly() const;
      void SetTexture(int, GLuint);
      GLuint GetTexture(int);
      bool operator<(const Material&) const;
      
      floatvec diffuse;
      floatvec ambient;
      floatvec specular;
      
   private:
      vector<GLuint> texid;
      vector<string> texfilename;
      string shader;
      TextureManager& texman;
      Shader& shaderhand;
      int id;
      static int nummats;
      bool cullface, doalphatest, alphatocoverage, additive, depthtest;
      float alphatest;
};

typedef shared_ptr<Material> MaterialPtr;

#endif

