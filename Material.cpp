#include "Material.h"
#include "globals.h"

int Material::nummats = 0;

Material::Material(string filename, TextureManager& tm, Shader& s) : diffuse(4, 0.f), ambient(4, 0.f), specular(4, 0.f),
                   texid(8, 0), texfilename(8, ""), texman(tm), shaderhand(s), id(nummats), cullface(true), alphatest(0.f)
{
   IniReader reader(filename);
   
   for (int i = 0; i < 4; ++i)
      reader.Read(diffuse[i], "Diffuse", i);
   
   for (int i = 0; i < 4; ++i)
      reader.Read(ambient[i], "Ambient", i);
   
   for (int i = 0; i < 4; ++i)
      reader.Read(specular[i], "Specular", i);
   
   for (int i = 0; i < 8; ++i)
   {
      string name = "Texture";
      name += ToString(i);
      reader.Read(texfilename[i], name);
      if (texfilename[i] != "")
         texid[i] = texman.LoadTexture(texfilename[i]);
   }
#ifndef NOEXT  // Hold the phone, I think if the modeller does glewInit we don't need these...must try sometime
   reader.Read(shader, "Shader");
   shaderhand.LoadShader(shader);
#endif
   reader.Read(cullface, "CullFace");
   
   reader.Read(alphatest, "AlphaTest");
   if (alphatest > 1e-6)
      doalphatest = true;
   
   ++nummats;
}


void Material::Use() const
{
#ifndef NOEXT
   for (int i = 0; i < 6; ++i) // At this time, textures 7 and 8 are reserved for shadowmaps
   {
      texman.texhand->ActiveTexture(i);
      if (texfilename[i] != "")
         texman.BindTexture(texfilename[i]);
      else
         texman.texhand->BindTexture(texid[i]);
   }
   
   texman.texhand->ActiveTexture(0);
   shaderhand.UseShader(shader);
#endif
   
   if (cullface)
   {
      glEnable(GL_CULL_FACE);
      glCullFace(GL_BACK);
   }
   else glDisable(GL_CULL_FACE);
   
   if (doalphatest)
   {
      //glPushAttrib(GL_ENABLE_BIT | GL_COLOR_BUFFER_BIT);
      // Nice alpha textured tree leaves
      glAlphaFunc(GL_GREATER, alphatest);
      
      glEnable(GL_ALPHA_TEST);
      glBlendFunc(GL_ONE, GL_ZERO);
      glEnable(GL_BLEND);
#ifndef NOEXT
      /* Not entirely happy with the way this looks, but it could be worse*/
      glEnable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glSampleCoverage(1.f, GL_FALSE);
      glDisable(GL_BLEND);
#endif
      //glAlphaFunc(GL_GREATER, 0.5);
      
      //glDisable(GL_LIGHTING);
   }
   else
   {
      //glAlphaFunc(GL_GREATER, 0.5);
      
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glDisable(GL_ALPHA_TEST);
      
      //glDisable(GL_BLEND);
#ifndef NOEXT
      glDisable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glEnable(GL_BLEND);
#endif
   }
   
   glDisable(GL_COLOR_MATERIAL); // TODO: This should probably be removed at some point
   glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, &ambient[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, &diffuse[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, &specular[0]);
}


void Material::UseTextureOnly() const
{
   if (texfilename[0] != "")
      texman.BindTexture(texfilename[0]);
   else
      texman.texhand->BindTexture(texid[0]);
}


void Material::SetTexture(int texunit, GLuint tex)
{
   texfilename[texunit] = "";
   texid[texunit] = tex;
}


// Define an ordering on materials so that WorldPrimitives can sort by material
bool Material::operator<(const Material& m) const
{
   return id < m.id;
}

