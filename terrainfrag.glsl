uniform sampler2D tex, tex1, tex2, tex3;
uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float reflectval;

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 texweight, texweight1;
varying vec3 worldcoords;
varying vec4 diffuse;

void main()
{
   vec4 ambient = vec4(.4, .4, .4, .4);
   // Texturing
   vec4 base = gl_Color;
   base.a = 1.;
   vec4 color = vec4(0, 0, 0, 0);
   
   float normweight = smoothstep(-500., 1000., dist) * .7;
   float detailweight = 1. - normweight;
   color += texweight.r * texture2D(tex, gl_TexCoord[0].st) * detailweight;
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].st) * detailweight;
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].st) * detailweight;
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].st) * detailweight;
   color += texweight.r * texture2D(tex, gl_TexCoord[0].pq) * normweight;
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].pq) * normweight;
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].pq) * normweight;
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].pq) * normweight;
   color *= base;
   vec4 color1 = color;
   float alpha = color.a;
   float detailmapsize = 200.;
   
   // Shadows
   if (dist < detailmapsize)
   {
      color.rgb *= ambient.rgb + (shadow2DProj(shadowtex, shadowmappos).rgb * diffuse.rgb * diffuse.a);
      color.a = alpha;
   }
   else color *= ambient + diffuse;
   
   color1.rgb *= ambient.rgb + (shadow2DProj(worldshadowtex, worldshadowmappos).rgb * diffuse.rgb * diffuse.a);
   color1.a = alpha;
   
   color = mix(color, color1, smoothstep(0.8, 1.0, dist / detailmapsize));
   
   // Fogging
   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   // Reflection
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   gl_FragColor = color;
}