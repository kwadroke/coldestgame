uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 diff, vec4 spec, float d, inout vec4 col)
{
   float alpha = col.a;
   
   float shadowval = 1. - shadow2DProj(worldshadowtex, worldshadowmappos).r;
   col.rgb -= diff.rgb * shadowval;
   col.rgb -= spec.rgb * shadowval;
   col.a = alpha;
}