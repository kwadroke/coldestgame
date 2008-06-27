void basiclighting(in vec3, in vec3, out vec4, out vec4, out vec4, in float);
vec4 specular(vec3, vec3, in vec3, inout vec4);
void shadow(vec4, vec4, float, inout vec4);
void fog(float, inout vec4);

uniform sampler2D tex, bumptex;
uniform float reflectval;

//varying vec4 shadowmappos, worldshadowmappos; // Just a reminder
varying float dist;
varying vec3 worldcoords;
varying vec3 view, lightdir;

void main()
{
   // Reflection
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   // Texturing
   vec4 color = gl_Color;
   
   vec3 bump = texture2D(bumptex, gl_TexCoord[0].st).xyz * 2. - 1.;
   
   vec4 ambient, diffuse;
   basiclighting(bump, lightdir, color, ambient, diffuse, 0.);
   vec4 specval = specular(bump, lightdir, view, color);
   shadow(diffuse, specval, dist, color);
   
   fog(dist, color);
   
   gl_FragColor = color * texture2D(tex, gl_TexCoord[0].st);
}