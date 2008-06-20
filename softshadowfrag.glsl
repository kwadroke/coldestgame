uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float shadowres;
uniform float detailmapsize;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float alpha = col.a;
   vec4 color1 = col;
   
   float total = 0.;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(0., -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(0., 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, 1. / shadowres, 0., 0.)).r;
   
   //col.rgb -= diff.rgb * (1 - shadow2DProj(shadowtex, shadowmappos).r);
   col.rgb -= diff.rgb * (1. - smoothstep(0., .95, total / 9.));
   col.a = alpha;
   
   color1.rgb -= diff.rgb * (1. - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
