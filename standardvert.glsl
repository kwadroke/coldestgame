#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec4 ambient, diffuse;
varying vec3 worldcoords;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   /*gl_TexCoord[1] = gl_MultiTexCoord1;
   gl_TexCoord[2] = gl_MultiTexCoord2;
   gl_TexCoord[3] = gl_MultiTexCoord3;*/
   
   vec3 normal, lightdir;
   float ndotl;
   
   /* Diffuse calculations */
   normal = normalize(gl_NormalMatrix * gl_Normal);
   lightdir = normalize(vec3(gl_LightSource[0].position));
   ndotl = max(dot(normal, lightdir), dot(-normal, lightdir));
   diffuse = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
   
   /* Ambient calculations */
   ambient = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
   ambient += gl_FrontMaterial.ambient * gl_LightModel.ambient;
   
   /* Combine our lighting calculations to get a color*/
   gl_FrontColor = ndotl * diffuse + ambient;
   gl_FrontColor *= gl_Color;
   gl_BackColor = gl_FrontColor;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
      using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   gl_Position = ftransform();
   
   /* For fogging - method above is better, probably a little slower though*/
   /*dist = gl_Position.z;*/
}
