varying vec3 normal;
varying vec3 light;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   normal = gl_Normal;/*normalize(gl_NormalMatrix * gl_Normal);*/
   light = gl_LightSource[0].position.xyz;/*normalize(gl_NormalMatrix * gl_LightSource[0].position.xyz);*/
   
   gl_Position = ftransform();
}
