uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float detailmapsize = 200.;
   float alpha = col.a;
   
   col.rgb *= amb.rgb + (shadow2DProj(worldshadowtex, worldshadowmappos).rgb * diff.rgb * diff.a);
   col.a = alpha;
}
