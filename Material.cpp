#include "Material.h"
#include "globals.h"

int Material::nummats = 0;

Material::Material(string filename, TextureManager& tm, Shader& s) : diffuse(4, 0.f), ambient(4, 0.f), specular(4, 0.f),
                   texid(8, 0), texfilename(8, ""), texman(tm), shaderhand(s), id(nummats), cullface(true)
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
   
   reader.Read(shader, "Shader");
   shaderhand.LoadShader(shader);
   
   reader.Read(cullface, "CullFace");
   
   ++nummats;
}


void Material::Use() const
{
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
   
   if (cullface)
      glEnable(GL_CULL_FACE);
   else glDisable(GL_CULL_FACE);
   
   glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, &ambient[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, &diffuse[0]);
   glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, &specular[0]);
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

