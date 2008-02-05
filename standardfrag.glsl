void basiclighting(in vec3 norm, in vec3 lightdir, out vec4 col, out vec4 amb, out vec4 diff);
void shadow(vec4 amb, vec4 diff, float d, inout vec4 color);
void fog(float dist, inout vec4 color);

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
   
   basiclighting(normal, normalize(vec3(gl_LightSource[0].position)), color, ambient, diffuse);
   
   shadow(ambient, diffuse, dist, color);
          
   color *= texture2D(tex, gl_TexCoord[0].st);
   
   fog(dist, color);
   
   gl_FragColor = color;
}