uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float shadowres;
uniform float detailmapsize;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 diff, vec4 spec, float d, inout vec4 col)
{
   float alpha = col.a;
   vec4 color1 = col;
   
   float shadowval = 1. - shadow2DProj(shadowtex, shadowmappos).r;
   col.rgb -= diff.rgb * shadowval;
   col.rgb -= spec.rgb * shadowval;
   col.a = alpha;
   
   shadowval = 1. - shadow2DProj(worldshadowtex, worldshadowmappos).r;
   color1.rgb -= diff.rgb * shadowval;
   color1.rgb -= spec.rgb * shadowval;
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}