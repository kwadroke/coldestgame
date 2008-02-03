#include "Material.h"
#include "globals.h"

int Material::nummats = 0;

Material::Material(string filename, TextureManager& tm, Shader& s) : diffuse(4, 0.f), ambient(4, 0.f), specular(4, 0.f),
                   texid(8, 0), texfilename(8, ""), texman(tm), shaderhand(s), id(nummats)
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
   
   ++nummats;
}


void Material::Use() const
{
   for (int i = 0; i < 8; ++i)
   {
      texman.texhand->ActiveTexture(i);
      if (texfilename[i] != "")
         texman.BindTexture(texfilename[i]);
      else
         texman.texhand->BindTexture(texid[i]);
   }
   texman.texhand->ActiveTexture(0);
   
   shaderhand.UseShader(shader);
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

