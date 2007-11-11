#version 110

varying float dist;
varying vec3 location;
varying vec3 worldcoords;
varying vec3 lightdir;

void main()
{
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_Vertex;
   gl_TexCoord[1] = gl_MultiTexCoord1;
   
   // This way looks like crap
   //halfvector = normalize(gl_LightSource[0].halfVector.xyz);
   
   location = gl_ModelViewMatrixInverse[3].xyz;
   worldcoords = gl_Vertex.xyz;
   lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   lightdir.x *= -1.; // Not entirely clear on why this is necessary, but it is
   lightdir.z *= -1.;
   
   gl_Position = ftransform();
   
   /* For fogging*/
   dist = gl_Position.z;
}
