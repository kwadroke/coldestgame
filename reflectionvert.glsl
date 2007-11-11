varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec4 ambient, diffuse;
varying vec3 texweight, texweight1;
varying vec3 worldcoords;

attribute vec3 terrainwt, terrainwt1;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
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
   
   /* For fogging - method above is better, probably a little slower though*/
   /*dist = gl_Position.z;*/
}
