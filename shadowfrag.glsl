uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float shadowres;
uniform float detailmapsize;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float alpha = col.a;
   vec4 color1 = col;
   
   col.rgb -= diff.rgb * (1 - shadow2DProj(shadowtex, shadowmappos).r);
   col.a = alpha;
   
   color1.rgb -= diff.rgb * (1. - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
