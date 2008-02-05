void basiclighting(in vec3 norm, in vec3 lightdir, out vec4 col, out vec4 amb, out vec4 diff);
void shadow(vec4 amb, vec4 diff, float d, inout vec4 color);
void fog(float dist, inout vec4 color);

uniform sampler2D tex, bumptex;
uniform float reflectval;

//varying vec4 shadowmappos, worldshadowmappos; // Just a reminder
varying float dist;
varying vec3 worldcoords;
varying vec3 view, lightdir;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   /* Texturing */
   vec4 color = gl_Color;
   
   vec3 bump = texture2D(bumptex, gl_TexCoord[0].st).xyz * 2. - 1.;
   
   vec4 ambient, diffuse;
   basiclighting(bump, lightdir, color, ambient, diffuse);
   shadow(ambient, diffuse, dist, color);
   
   fog(dist, color);
   
   gl_FragColor = color * texture2D(tex, gl_TexCoord[0].st);
   //gl_FragColor.rgb = -view;
   //gl_FragColor.rgb = vec3(ndotl, ndotl, ndotl);
   //gl_FragColor.rgb = lightdir * .5 + .5;
   //gl_FragColor.rgb = lightdir;
   //gl_FragColor.rgb = bump * .5 + .5;
   //gl_FragColor.rgb = cross(bump, lightdir);
   //vec3 templ = lightdir;
   //templ.x *= -1;
   //gl_FragColor.rgb = templ * .5 + lightdir * .5;
   
   gl_FragColor.a = 1.;
}