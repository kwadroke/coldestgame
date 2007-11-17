#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 texweight, texweight1;
varying vec3 worldcoords;
varying vec4 diffuse;

attribute vec3 terrainwt, terrainwt1;

void main()
{
   gl_TexCoord[0].st = gl_MultiTexCoord0.st;
   gl_TexCoord[0].pq = gl_MultiTexCoord1.st;
   
   vec4 ambient;
   
   vec3 normal, lightdir;
   float ndotl;
   
   /* Diffuse calculations */
   normal = normalize(gl_NormalMatrix * gl_Normal);
   lightdir = normalize(vec3(gl_LightSource[0].position));
   ndotl = max(dot(normal, lightdir), 0.0);
   diffuse = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
   
   /* Ambient calculations */
   ambient = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
   ambient += gl_FrontMaterial.ambient * gl_LightModel.ambient;
   
   /* Combine our lighting calculations to get a color*/
   gl_FrontColor = ndotl * diffuse + ambient;
   gl_FrontColor *= gl_Color;
   diffuse.a = ndotl;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
      using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   worldcoords.xyz = gl_Vertex.xyz;
   
   /* Terrain */
   texweight = terrainwt;
   texweight1 = terrainwt1;
   
   gl_Position = ftransform();
   
   /* ATI OpenGL stupidity
   depth = gl_Position.zw;*/
   
   /* For fogging - method above is better, probably a little slower though*/
   /*dist = gl_Position.z;*/
}
