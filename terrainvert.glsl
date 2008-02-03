#version 110

void basiclighting(out vec3 amb, out vec3 diff);

varying vec4 shadowmappos, worldshadowmappos;
varying vec3 texweight, texweight1;
varying vec4 worldcoords;
varying vec3 diffuse;
varying vec3 ambient;

attribute vec3 terrainwt, terrainwt1;

void main()
{
   gl_TexCoord[0].st = gl_MultiTexCoord0.st;
   gl_TexCoord[0].pq = gl_MultiTexCoord1.st;
   
   basiclighting(ambient, diffuse);
   // Debugging
   //ambient = vec3(.2, .2, .2);
   //diffuse = vec3(.7, .7, .7);
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
      using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   //dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   worldcoords.w = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   worldcoords.xyz = gl_Vertex.xyz;
   
   /* Terrain */
   texweight = terrainwt;
   texweight1 = terrainwt1;
   
   gl_Position = ftransform();
   
   /* For fogging - method above is better, probably a little slower though*/
   /*dist = gl_Position.z;*/
}
