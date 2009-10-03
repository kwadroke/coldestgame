void basiclighting(inout vec3, in vec3, out vec4, out vec4, out vec4, in float);
void shadow(vec4, vec4, float, inout vec4);
void fog(float, inout vec4);

uniform sampler2D tex;
uniform float reflectval;

varying float dist;
varying vec3 normal;
varying vec3 worldcoords;

void main()
{
   // Reflection
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   // Texturing
   vec4 color;
   vec4 ambient, diffuse;
   vec3 localnorm = vec3(0., 0., 1.);
   
   // Always light as though we're pointed directly at the light
   basiclighting(localnorm, vec3(0., 0., -1.), color, ambient, diffuse, 1.);
   
   shadow(diffuse, vec4(0.), dist, color);
   
   color *= texture2D(tex, gl_TexCoord[0].st);
   
   fog(dist, color);
   
   gl_FragColor = color;
}