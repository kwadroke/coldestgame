void basiclighting(in vec3, in vec3, out vec4, out vec4, out vec4, in float);
void shadow(vec3, vec4, vec4, float, inout vec4);
void fog(float, inout vec4);

uniform sampler2D tex;
uniform float reflectval;

varying float dist;
varying vec3 normal;
varying vec3 worldcoords;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   /* Texturing */
   vec4 color;
   vec4 ambient, diffuse;
   
   basiclighting(normal, normalize(vec3(gl_LightSource[0].position)), color, ambient, diffuse, 1.);
   
   shadow(worldcoords.xyz, ambient, diffuse, dist, color);
          
   color *= texture2D(tex, gl_TexCoord[0].st);
   
   fog(dist, color);
   
   gl_FragColor = color;
}