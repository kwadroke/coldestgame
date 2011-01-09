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
// Copyright 2008, 2011 Ben Nemec
// @End License@


#include "Material.h"
#include "globals.h"

int Material::nummats = 0;

#ifndef DEDICATED
Material::Material(string filename, TextureManager& tm, Shader& s) : diffuse(4, 0.f), ambient(4, 0.f), specular(4, 0.f), shininess(0.f),
                   texid(8, 0), texfilename(8, ""), shader(""), shaderid(0), texman(&tm), shaderhand(&s), id(nummats), cullface(true), doalphatest(false),
                   alphatocoverage(false), additive(false), depthtest(true), depthwrite(true), noshadowcull(false), alphatest(0.f)
{
   ifstream check(filename.c_str());
   if (check.fail())
   {
      logout << "Failed to load material " << filename << endl;
      filename = "materials/default";
   }
   NTreeReader reader(filename);

   for (int i = 0; i < 4; ++i)
      reader.Read(diffuse[i], "Diffuse", i);

   for (int i = 0; i < 4; ++i)
      reader.Read(ambient[i], "Ambient", i);

   for (int i = 0; i < 4; ++i)
      reader.Read(specular[i], "Specular", i);

   reader.Read(shininess, "Shininess");

   bool repeat = false;
   reader.Read(repeat, "Repeat");
   for (int i = 0; i < 8; ++i)
   {
      string name = "Texture";
      name += ToString(i);
      reader.Read(texfilename[i], name);
      if (texfilename[i] != "")
         texid[i] = texman->LoadTexture(texfilename[i]);

      if (repeat)
      {
         glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
         glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      }
   }

   reader.Read(shader, "Shader");
   shaderhand->LoadShader(shader);

   reader.Read(cullface, "CullFace");
   reader.Read(noshadowcull, "NoShadowCull");

   reader.Read(alphatest, "AlphaTest");
   if (alphatest > 1e-6)
      doalphatest = true;

   reader.Read(additive, "Additive");

   reader.Read(alphatocoverage, "AlphaToCoverage");

   reader.Read(depthtest, "DepthTest");

   reader.Read(depthwrite, "DepthWrite");

   ++nummats;
}
#else

Material::Material(){}

#endif


void Material::Use() const
{
#ifndef DEDICATED
   for (int i = 0; i < 6; ++i) // At this time, textures 7 and 8 are reserved for shadowmaps
   {
      if (texid[i])
      {
         texman->texhand->ActiveTexture(i);
         texman->texhand->BindTexture(texid[i]);
      }
   }

   texman->texhand->ActiveTexture(0);
   shaderhand->UseShader(shader);

   if (cullface)
   {
      glEnable(GL_CULL_FACE);
      glCullFace(GL_BACK);
   }
   else glDisable(GL_CULL_FACE);

   if (depthtest)
      glEnable(GL_DEPTH_TEST);
   else glDisable(GL_DEPTH_TEST);

   if (depthwrite)
      glDepthMask(GL_TRUE);
   else glDepthMask(GL_FALSE);

   if (doalphatest)
   {
      glAlphaFunc(GL_GREATER, alphatest);

      glEnable(GL_ALPHA_TEST);
      glEnable(GL_BLEND);
      glBlendFunc(GL_ONE, GL_ZERO);
   }
   else
   {
      if (additive)
         glBlendFunc(GL_SRC_ALPHA, GL_ONE);
      else
         glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glDisable(GL_ALPHA_TEST);
   }

   if (alphatocoverage)
   {
      // Not entirely happy with the way this looks, but it could be worse
      glEnable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glSampleCoverage(1.f, GL_FALSE);
      glDisable(GL_BLEND);
   }
   else
   {
      glDisable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glEnable(GL_BLEND);
   }

   //glDisable(GL_COLOR_MATERIAL); // TODO: This should probably be removed at some point
   glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, &ambient[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, &diffuse[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, &specular[0]);
   glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, shininess);
#endif
}


void Material::UseTextureOnly() const
{
#ifndef DEDICATED
   texman->texhand->BindTexture(texid[0]);

   // Also do face culling so we can render only back faces for shadowing
   if (cullface && !noshadowcull)
   {
      glEnable(GL_CULL_FACE);
   }
   else glDisable(GL_CULL_FACE);
#endif
}


void Material::SetTexture(int texunit, GLuint tex)
{
   if (texfilename[texunit] != "")
      logout << "Warning: Possible memory leak in Material::SetTexture" << endl;
   texfilename[texunit] = "";
   texid[texunit] = tex;
}


void Material::SetTexture(int texunit, string tex)
{
#ifndef DEDICATED
   if (texfilename[texunit] != "")
      logout << "Warning: Possible memory leak in Material::SetTexture" << endl;
   texfilename[texunit] = tex;
   texid[texunit] = texman->LoadTexture(texfilename[texunit]);
#endif
}


GLuint Material::GetTexture(int texunit)
{
   return texid[texunit];
}


// Define an ordering on materials so that Mesh can sort by material
bool Material::operator<(const Material& m) const
{
   return id < m.id;
}


void Material::Release()
{
#ifndef DEDICATED
   for (int i = 0; i < 6; ++i)
   {
      if (texfilename[i] != "")
         texman->DeleteTexture(texfilename[i]);
      // Textures in texid are not our problem because they should come from FBO's.
   }
#endif
}

