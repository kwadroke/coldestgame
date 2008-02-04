uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec3 amb, vec3 diff, float d, inout vec4 col)
{
   float detailmapsize = 200.;
   float alpha = col.a;
   
   col.rgb *= amb.rgb + (shadow2DProj(worldshadowtex, worldshadowmappos).rgb * diff);
   col.a = alpha;
}
