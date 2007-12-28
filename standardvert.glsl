#version 110

void basiclighting(out vec4 amb, out vec4 diff);

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
   
   basiclighting(ambient, diffuse);
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
