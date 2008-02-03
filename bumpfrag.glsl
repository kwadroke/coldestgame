void shadow(vec3 amb, vec3 diff, float d, inout vec4 color);
void fog(float dist, inout vec4 color);

uniform sampler2D tex, bumptex;
uniform float reflectval;

//varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
//varying vec4 ambient;//, diffuse;
varying vec3 worldcoords;
varying vec3 view, lightdir;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0 && reflectval > .5) discard;
   
   /* Texturing */
   vec4 color = texture2D(tex, gl_TexCoord[0].st);
   
   vec3 bump = texture2D(bumptex, gl_TexCoord[0].st).xyz * 2 - 1;
   
   float ndotl = max(0.0, dot(normalize(bump), normalize(lightdir)));
   
   //vec3 diffuse = gl_LightSource[0].diffuse.rgb * ndotl;
   vec3 diffuse = vec3(1, 1, 1) * ndotl;
   
   vec3 ambient = vec3(.4, .4, .4);
   shadow(ambient, diffuse, dist, color);
   
   fog(dist, color);
   
   gl_FragColor.rgb = ambient + diffuse;
   gl_FragColor.rgb *= color.rgb;
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