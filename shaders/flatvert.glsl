#version 110

varying float dist;
varying vec3 worldcoords;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   gl_FrontColor = gl_Color;
   gl_BackColor = gl_Color;
   
   gl_Position = ftransform();
}
