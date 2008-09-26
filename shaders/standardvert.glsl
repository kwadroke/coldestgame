#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 normal;
varying vec3 worldcoords;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   normal = normalize(gl_NormalMatrix * gl_Normal);
   gl_FrontColor = vec4(1, 1, 1, 1);
   //gl_BackColor = gl_FrontColor;
   
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
