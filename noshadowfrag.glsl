uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float alpha = col.a;
   
   col.rgb -= diff.rgb * (1 - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   col.a = alpha;
}