uniform sampler2D spectex;

vec4 specular(vec3 norm, vec3 lightdir, in vec3 viewv, inout vec4 color)
{
   vec4 speccolor = texture2D(spectex, gl_TexCoord[0].st);
   
   vec3 halfvec = normalize(viewv + lightdir);
   
   float ndothv = max(dot(norm, halfvec), 0.);
   vec4 specval = speccolor * pow(ndothv, gl_FrontMaterial.shininess) * 2.;
   color.rgb += specval.rgb;
   return specval;
}
