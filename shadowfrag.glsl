uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float detailmapsize = 200.;
   float alpha = col.a;
   vec4 color1 = col;
   
   col.rgb *= amb.rgb + (shadow2DProj(shadowtex, shadowmappos).rgb * diff.rgb * diff.a);
   col.a = alpha;
   
   color1.rgb *= amb.rgb + (shadow2DProj(worldshadowtex, worldshadowmappos).rgb * diff.rgb * diff.a);
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
