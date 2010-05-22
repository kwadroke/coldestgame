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


#ifndef __MATERIAL_H
#define __MATERIAL_H

#include "glinc.h"
#include <vector>
#include <string>
#include "TextureManager.h"
#include "types.h"
#include "NTreeReader.h"
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
      void SetTexture(int, string);
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
      GLhandleARB shaderid;
#ifndef DEDICATED
      TextureManager* texman;
      Shader* shaderhand;
#endif
      int id;
      static int nummats;
      bool cullface, doalphatest, alphatocoverage, additive, depthtest, depthwrite, noshadowcull;
      float alphatest;
};

typedef shared_ptr<Material> MaterialPtr;

#endif

