#version 110

varying vec3 location;
varying vec3 worldcoords;
varying vec3 lightdir;
varying vec4 shadowmappos, worldshadowmappos;

void main()
{
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_Vertex;
   gl_TexCoord[1] = gl_MultiTexCoord1;
   
   // This way looks like crap
   //halfvector = normalize(gl_LightSource[0].halfVector.xyz);
   
   location = gl_ModelViewMatrixInverse[3].xyz;
   worldcoords = gl_Vertex.xyz;
   lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
   using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   gl_Position = ftransform();
}
